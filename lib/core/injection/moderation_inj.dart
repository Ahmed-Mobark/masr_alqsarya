import 'package:get_it/get_it.dart';
import 'package:masr_al_qsariya/core/moderation/chat_moderation_remote_data_source.dart';
import 'package:masr_al_qsariya/core/moderation/chat_moderation_service.dart';
import 'package:masr_al_qsariya/core/moderation/openai_moderation_remote_data_source.dart';
import 'package:masr_al_qsariya/core/moderation/tone_assistant_service.dart';

void initModerationInjection(GetIt sl) {
  // WARNING: Putting OpenAI keys in the client is insecure.
  // This reads from: flutter run --dart-define=OPENAI_API_KEY=...
  const openAiKey = String.fromEnvironment('OPENAI_API_KEY');

  if (openAiKey.trim().isNotEmpty) {
    sl.registerLazySingleton<OpenAiModerationRemoteDataSource>(
      () => OpenAiModerationRemoteDataSource(apiKey: openAiKey.trim()),
    );

    sl.registerLazySingleton<ChatModerationRemoteDataSource>(
      () => _ChatModerationRemoteFromOpenAi(sl<OpenAiModerationRemoteDataSource>()),
    );
  } else {
    // Free mode: DON'T call backend moderation endpoint (often not available).
    // We'll rely on ToneAssistantService (on-device) for pre-send filtering/UX.
    sl.registerLazySingleton<ChatModerationRemoteDataSource>(
      () => const _AllowAllModerationRemote(),
    );
  }

  sl.registerLazySingleton<ChatModerationService>(
    () => ChatModerationService(remote: sl<ChatModerationRemoteDataSource>()),
  );

  sl.registerLazySingleton<ToneAssistantService>(() => const ToneAssistantService());
}

class _AllowAllModerationRemote implements ChatModerationRemoteDataSource {
  const _AllowAllModerationRemote();

  @override
  Future<Map<String, dynamic>> review({
    String? text,
    List<String> attachmentPaths = const [],
  }) async {
    return const {'allowed': true};
  }
}

class _ChatModerationRemoteFromOpenAi implements ChatModerationRemoteDataSource {
  const _ChatModerationRemoteFromOpenAi(this._openAi);

  final OpenAiModerationRemoteDataSource _openAi;

  @override
  Future<Map<String, dynamic>> review({
    String? text,
    List<String> attachmentPaths = const [],
  }) async {
    // Text decision
    _OpenAiDecisionAgg? agg;
    if (text != null && text.trim().isNotEmpty) {
      final d = await _openAi.reviewText(text.trim());
      agg = _OpenAiDecisionAgg.from(d);
    }

    // Image decisions (only for image/* files)
    final blocked = <String>[];
    for (final p in attachmentPaths) {
      final lower = p.toLowerCase();
      final isImage = lower.endsWith('.png') ||
          lower.endsWith('.jpg') ||
          lower.endsWith('.jpeg') ||
          lower.endsWith('.webp') ||
          lower.endsWith('.gif');
      if (!isImage) continue;

      final d = await _openAi.reviewImagePath(p);
      final current = _OpenAiDecisionAgg.from(d);
      if (!current.allowed) {
        blocked.add(p.split('/').last);
      }
      agg = _OpenAiDecisionAgg.merge(agg, current);
    }

    return {
      'allowed': agg?.allowed ?? true,
      'reason': agg?.reason,
      'severity': agg?.severity ?? 0,
      'blocked_attachments': blocked,
    };
  }
}

class _OpenAiDecisionAgg {
  const _OpenAiDecisionAgg({
    required this.allowed,
    this.reason,
    this.severity = 0,
  });

  factory _OpenAiDecisionAgg.from(dynamic d) {
    if (d is Map<String, dynamic>) {
      return _OpenAiDecisionAgg(
        allowed: d['allowed'] is bool ? d['allowed'] as bool : true,
        reason: d['reason'] is String ? d['reason'] as String : null,
        severity: d['severity'] is num ? (d['severity'] as num).toInt() : 0,
      );
    }
    // If it's any other object, treat as allowed.
    return const _OpenAiDecisionAgg(allowed: true);
  }

  final bool allowed;
  final String? reason;
  final int severity;

  static _OpenAiDecisionAgg merge(_OpenAiDecisionAgg? a, _OpenAiDecisionAgg b) {
    if (a == null) return b;
    if (!a.allowed) return a;
    if (!b.allowed) return b;
    return a.severity >= b.severity ? a : b;
  }
}

