import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_audit_log_entry.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_tone_insights.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_audit_logs_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_tone_insights_usecase.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/conversation_insights_state.dart';

class ConversationInsightsCubit extends Cubit<ConversationInsightsState> {
  ConversationInsightsCubit(
    this._getToneInsights,
    this._getAuditLogs,
  ) : super(const ConversationInsightsState());

  final GetChatToneInsightsUseCase _getToneInsights;
  final GetChatAuditLogsUseCase _getAuditLogs;

  int? _workspaceId;
  int? _chatId;

  Future<void> retry() async {
    final w = _workspaceId;
    final c = _chatId;
    if (w == null || c == null) return;
    return load(workspaceId: w, chatId: c);
  }

  Future<void> load({
    required int workspaceId,
    required int chatId,
  }) async {
    _workspaceId = workspaceId;
    _chatId = chatId;
    emit(
      state.copyWith(
        toneStatus: ConversationInsightsSliceStatus.loading,
        logsStatus: ConversationInsightsSliceStatus.loading,
        clearToneError: true,
        clearLogsError: true,
      ),
    );

    final toneResult = await _getToneInsights(workspaceId, chatId);
    final logsResult = await _getAuditLogs(workspaceId, chatId);

    ChatToneInsights? tone;
    String? toneErr;
    toneResult.fold((f) => toneErr = f.message, (t) => tone = t);

    List<ChatAuditLogEntry> logs = const [];
    String? logsErr;
    logsResult.fold((f) => logsErr = f.message, (l) => logs = l);

    emit(
      state.copyWith(
        toneStatus: toneErr != null
            ? ConversationInsightsSliceStatus.failure
            : ConversationInsightsSliceStatus.success,
        logsStatus: logsErr != null
            ? ConversationInsightsSliceStatus.failure
            : ConversationInsightsSliceStatus.success,
        tone: tone,
        logs: logs,
        toneError: toneErr,
        logsError: logsErr,
      ),
    );
  }
}
