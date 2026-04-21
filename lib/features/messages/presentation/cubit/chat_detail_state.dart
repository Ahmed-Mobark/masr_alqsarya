import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';

enum ChatDetailStatus { initial, loading, success, failure }

class ChatBubbleRow extends Equatable {
  const ChatBubbleRow({
    required this.text,
    required this.time,
    required this.isSent,
    this.attachments = const [],
  });

  final String text;
  final String time;
  final bool isSent;
  final List<ChatAttachment> attachments;

  @override
  List<Object?> get props => [text, time, isSent, attachments];
}

class ChatDetailState extends Equatable {
  const ChatDetailState({
    this.status = ChatDetailStatus.initial,
    this.messages = const [],
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
    String? errorMessage,
    bool? workspaceMissing,
    bool clearError = false,
    bool? isSending,
    String? sendError,
    bool clearSendError = false,
    int? downloadingAttachmentId,
    bool clearDownloadingAttachment = false,
    String? attachmentFeedback,
    String? attachmentSavedLabel,
    bool clearAttachmentFeedback = false,
  }) {
    return ChatDetailState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
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
        errorMessage,
        workspaceMissing,
        isSending,
        sendError,
        downloadingAttachmentId,
        attachmentFeedback,
        attachmentSavedLabel,
      ];
}
