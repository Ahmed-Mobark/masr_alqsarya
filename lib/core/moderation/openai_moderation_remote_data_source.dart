import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

/// Calls OpenAI directly from the client (NOT recommended for production
/// because API keys can be extracted from the app binary).
///
/// Prefer using a server-issued ephemeral token or a backend proxy.
class OpenAiModerationRemoteDataSource {
  OpenAiModerationRemoteDataSource({
    required String apiKey,
    Dio? dio,
    String baseUrl = 'https://api.openai.com/v1',
    Duration timeout = const Duration(seconds: 20),
    this.textModel = 'omni-moderation-latest',
    this.visionModel = 'gpt-4o-mini',
  }) : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: timeout,
                receiveTimeout: timeout,
                sendTimeout: timeout,
                headers: {
                  'Authorization': 'Bearer $apiKey',
                  'Content-Type': 'application/json',
                },
              ),
            );

  final Dio _dio;
  final String textModel;
  final String visionModel;

  Future<Map<String, dynamic>> reviewText(String text) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/responses',
      data: {
        'model': visionModel,
        'input': [
          {
            'role': 'system',
            'content': [
              {
                'type': 'text',
                'text':
                    'You are a strict Arabic+English content moderation classifier for a family-friendly chat app. '
                    'Detect profanity, sexual content, harassment, hate, slurs, threats, and obscene phrases (including Arabic dialect). '
                    'Respond ONLY with compact JSON: {"allowed": boolean, "reason": string, "severity": number}. '
                    'Severity is 0..10.',
              }
            ],
          },
          {
            'role': 'user',
            'content': [
              {
                'type': 'text',
                'text': text,
              }
            ],
          },
        ],
      },
    );

    final body = res.data ?? const <String, dynamic>{};
    final output = body['output'];
    final outText = _extractFirstText(output) ?? '';
    final parsed = _tryParseJson(outText);
    if (parsed != null) {
      final allowed = parsed['allowed'];
      final reason = parsed['reason'];
      final severity = parsed['severity'];
      return {
        'allowed': allowed is bool ? allowed : true,
        'reason': reason is String ? reason : null,
        'severity': severity is num ? severity.toInt() : 0,
      };
    }
    return const {'allowed': true};
  }

  Future<Map<String, dynamic>> reviewImagePath(String path) async {
    final bytes = await File(path).readAsBytes();
    final b64 = base64Encode(bytes);
    final mime = lookupMimeType(path) ?? 'image/jpeg';
    final dataUrl = 'data:$mime;base64,$b64';

    final res = await _dio.post<Map<String, dynamic>>(
      '/responses',
      data: {
        'model': visionModel,
        'input': [
          {
            'role': 'system',
            'content': [
              {
                'type': 'text',
                'text':
                    'You are a strict content moderation classifier for a family-friendly chat app. '
                    'Decide if the image contains nudity, sexual content, extreme violence, hate symbols, or harassment. '
                    'Respond ONLY with a compact JSON object: '
                    '{"allowed": boolean, "reason": string, "severity": number}.',
              }
            ],
          },
          {
            'role': 'user',
            'content': [
              {'type': 'input_image', 'image_url': dataUrl}
            ],
          },
        ],
      },
    );

    final body = res.data ?? const <String, dynamic>{};
    final output = body['output'];
    // Best-effort parsing (API responses vary by model/version).
    final text = _extractFirstText(output) ?? '';
    final parsed = _tryParseJson(text);
    if (parsed != null) {
      final allowed = parsed['allowed'];
      final reason = parsed['reason'];
      final severity = parsed['severity'];
      return {
        'allowed': allowed is bool ? allowed : true,
        'reason': reason is String ? reason : null,
        'severity': severity is num ? severity.toInt() : 0,
      };
    }

    // If we cannot parse, default to allow (fail-open).
    return const {'allowed': true};
  }

  String? _extractFirstText(dynamic output) {
    if (output is! List) return null;
    for (final item in output) {
      if (item is! Map) continue;
      final content = item['content'];
      if (content is! List) continue;
      for (final c in content) {
        if (c is! Map) continue;
        final t = c['text'];
        if (t is String && t.trim().isNotEmpty) return t.trim();
      }
    }
    return null;
  }

  Map<String, dynamic>? _tryParseJson(String raw) {
    final s = raw.trim();
    if (s.isEmpty) return null;
    try {
      final decoded = jsonDecode(s);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } catch (_) {
      // Some models wrap JSON in prose; try to extract the first {...} block.
      final start = s.indexOf('{');
      final end = s.lastIndexOf('}');
      if (start != -1 && end != -1 && end > start) {
        final cut = s.substring(start, end + 1);
        try {
          final decoded = jsonDecode(cut);
          if (decoded is Map) return Map<String, dynamic>.from(decoded);
        } catch (_) {}
      }
    }
    return null;
  }
}

