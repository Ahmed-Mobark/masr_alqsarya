import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/network/reverb/reverb_service.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/download_chat_attachment_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/get_chat_messages_usecase.dart';
import 'package:masr_al_qsariya/features/messages/domain/usecases/send_chat_message_usecase.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/chat_detail_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/chat_view.dart';

/// Pushes [ChatView] with API-backed messages.
class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.name,
    required this.avatarUrl,
  });

  final int chatId;
  final String name;
  final String avatarUrl;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatDetailCubit(
        sl<GetChatMessagesUseCase>(),
        sl<SendChatMessageUseCase>(),
        sl<DownloadChatAttachmentUseCase>(),
        sl<WorkspaceIdStorage>(),
        sl<Storage>(),
        ReverbService(),
        chatId,
      )..loadMessages(),
      child: ChatView(chatId: chatId, name: name, avatarUrl: avatarUrl),
    );
  }
}
