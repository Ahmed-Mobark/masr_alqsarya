import 'package:equatable/equatable.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.body,
    this.createdAtIso,
    this.senderId,
    this.attachments = const [],
    this.isFlagged = false,
  });

  final int id;
  final String body;
  final String? createdAtIso;
  final int? senderId;
  final List<ChatAttachment> attachments;
  final bool isFlagged;

  @override
  List<Object?> get props => [
        id,
        body,
        createdAtIso,
        senderId,
        attachments,
        isFlagged,
      ];
}
