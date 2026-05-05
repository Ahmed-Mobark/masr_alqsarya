import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';

enum ChatDetailStatus { initial, loading, success, failure }

class ChatBubbleRow extends Equatable {
  const ChatBubbleRow({
    this.messageId,
    required this.text,
    required this.time,
    required this.isSent,
    this.attachments = const [],
    this.isFlagged = false,
  });

  final int? messageId;
  final String text;
  final String time;
  final bool isSent;
  final List<ChatAttachment> attachments;
  final bool isFlagged;

  @override
  List<Object?> get props => [
        messageId,
        text,
        time,
        isSent,
        attachments,
        isFlagged,
      ];
}

class ChatDetailState extends Equatable {
  const ChatDetailState({
    this.status = ChatDetailStatus.initial,
    this.messages = const [],
    this.pendingAttachmentNames = const [],
    this.warningCount = 0,
    this.moderationBlockReason,
    this.toneWarning,
    this.toneSuggestedAlternative,
    this.errorMessage,
    this.workspaceMissing = false,
    this.isSending = false,
    this.sendError,
    this.downloadingAttachmentId,
    this.attachmentFeedback,
    this.attachmentSavedLabel,
  });

  final ChatDetailStatus status;
  final List<ChatBubbleRow> messages;
  final List<String> pendingAttachmentNames;
  final int warningCount;
  final String? moderationBlockReason;
  final String? toneWarning;
  final String? toneSuggestedAlternative;
  final String? errorMessage;
  final bool workspaceMissing;
  final bool isSending;
  /// Transient error from send action (not full-screen failure).
  final String? sendError;
  final int? downloadingAttachmentId;
  /// `__download_ok__` | `__download_fail__` | `__workspace_missing__`
  final String? attachmentFeedback;
  final String? attachmentSavedLabel;

  ChatDetailState copyWith({
    ChatDetailStatus? status,
    List<ChatBubbleRow>? messages,
    List<String>? pendingAttachmentNames,
    int? warningCount,
    String? moderationBlockReason,
    String? toneWarning,
    String? toneSuggestedAlternative,
    String? errorMessage,
    bool? workspaceMissing,
    bool clearError = false,
    bool? isSending,
    String? sendError,
    bool clearSendError = false,
    bool clearToneIntervention = false,
    int? downloadingAttachmentId,
    bool clearDownloadingAttachment = false,
    String? attachmentFeedback,
    String? attachmentSavedLabel,
    bool clearAttachmentFeedback = false,
  }) {
    return ChatDetailState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      pendingAttachmentNames:
          pendingAttachmentNames ?? this.pendingAttachmentNames,
      warningCount: warningCount ?? this.warningCount,
      moderationBlockReason: clearSendError
          ? null
          : (moderationBlockReason ?? this.moderationBlockReason),
      toneWarning: clearToneIntervention ? null : (toneWarning ?? this.toneWarning),
      toneSuggestedAlternative: clearToneIntervention
          ? null
          : (toneSuggestedAlternative ?? this.toneSuggestedAlternative),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      workspaceMissing: workspaceMissing ?? this.workspaceMissing,
      isSending: isSending ?? this.isSending,
      sendError: clearSendError ? null : (sendError ?? this.sendError),
      downloadingAttachmentId: clearDownloadingAttachment
          ? null
          : (downloadingAttachmentId ?? this.downloadingAttachmentId),
      attachmentFeedback: (clearAttachmentFeedback && attachmentFeedback == null)
          ? null
          : (attachmentFeedback ?? this.attachmentFeedback),
      attachmentSavedLabel: (clearAttachmentFeedback && attachmentSavedLabel == null)
          ? null
          : (attachmentSavedLabel ?? this.attachmentSavedLabel),
    );
  }

  @override
  List<Object?> get props => [
        status,
        messages,
        pendingAttachmentNames,
        warningCount,
        moderationBlockReason,
        toneWarning,
        toneSuggestedAlternative,
        errorMessage,
        workspaceMissing,
        isSending,
        sendError,
        downloadingAttachmentId,
        attachmentFeedback,
        attachmentSavedLabel,
      ];
}
