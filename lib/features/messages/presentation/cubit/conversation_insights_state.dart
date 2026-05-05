import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_audit_log_entry.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_tone_insights.dart';

enum ConversationInsightsSliceStatus { initial, loading, success, failure }

class ConversationInsightsState extends Equatable {
  const ConversationInsightsState({
    this.toneStatus = ConversationInsightsSliceStatus.initial,
    this.logsStatus = ConversationInsightsSliceStatus.initial,
    this.tone,
    this.logs = const [],
    this.toneError,
    this.logsError,
  });

  final ConversationInsightsSliceStatus toneStatus;
  final ConversationInsightsSliceStatus logsStatus;
  final ChatToneInsights? tone;
  final List<ChatAuditLogEntry> logs;
  final String? toneError;
  final String? logsError;

  ConversationInsightsState copyWith({
    ConversationInsightsSliceStatus? toneStatus,
    ConversationInsightsSliceStatus? logsStatus,
    ChatToneInsights? tone,
    List<ChatAuditLogEntry>? logs,
    String? toneError,
    String? logsError,
    bool clearToneError = false,
    bool clearLogsError = false,
  }) {
    return ConversationInsightsState(
      toneStatus: toneStatus ?? this.toneStatus,
      logsStatus: logsStatus ?? this.logsStatus,
      tone: tone ?? this.tone,
      logs: logs ?? this.logs,
      toneError: clearToneError ? null : (toneError ?? this.toneError),
      logsError: clearLogsError ? null : (logsError ?? this.logsError),
    );
  }

  @override
  List<Object?> get props => [
        toneStatus,
        logsStatus,
        tone,
        logs,
        toneError,
        logsError,
      ];
}
