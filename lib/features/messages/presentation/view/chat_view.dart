import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/chat_detail_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/chat_detail_state.dart';

class ChatView extends StatefulWidget {
  final int chatId;
  final String name;
  final String avatarUrl;

  const ChatView({
    super.key,
    required this.chatId,
    required this.name,
    required this.avatarUrl,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatDetailCubit, ChatDetailState>(
      listenWhen: (prev, curr) =>
          (prev.sendError != curr.sendError && curr.sendError != null) ||
          (prev.isSending && !curr.isSending && curr.sendError == null) ||
          (prev.attachmentFeedback != curr.attachmentFeedback &&
              curr.attachmentFeedback != null),
      listener: (context, state) {
        if (state.attachmentFeedback != null) {
          final messenger = ScaffoldMessenger.of(context);
          if (state.attachmentFeedback == '__workspace_missing__') {
            messenger.showSnackBar(
              SnackBar(content: Text(context.tr.messagesWorkspaceMissing)),
            );
          } else if (state.attachmentFeedback == '__download_ok__' &&
              state.attachmentSavedLabel != null) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  context.tr.chatAttachmentDownloadSuccess(
                    state.attachmentSavedLabel!,
                  ),
                ),
              ),
            );
          } else if (state.attachmentFeedback == '__download_fail__') {
            messenger.showSnackBar(
              SnackBar(content: Text(context.tr.chatAttachmentDownloadFailed)),
            );
          }
          context.read<ChatDetailCubit>().clearAttachmentFeedback();
          return;
        }
        if (state.sendError != null) {
          final msg = state.sendError == '__workspace_missing__'
              ? context.tr.messagesWorkspaceMissing
              : state.sendError!;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(msg)));
          context.read<ChatDetailCubit>().clearSendError();
          return;
        }
        _messageController.clear();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.scaffoldBg,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.darkText),
              onPressed: () => Navigator.pop(context),
            ),
            titleSpacing: 0,
            title: Row(
              children: [
                ClipOval(
                  child: widget.avatarUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: widget.avatarUrl,
                          width: 36,
                          height: 36,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 36,
                            height: 36,
                            color: AppColors.inputBg,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 36,
                            height: 36,
                            color: AppColors.inputBg,
                            child: const Icon(
                              Iconsax.user,
                              size: 18,
                              color: AppColors.greyText,
                            ),
                          ),
                        )
                      : Container(
                          width: 36,
                          height: 36,
                          color: AppColors.inputBg,
                          child: const Icon(
                            Iconsax.user,
                            size: 18,
                            color: AppColors.greyText,
                          ),
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.name,
                    style: AppTextStyles.heading2(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatDetailCubit, ChatDetailState>(
                  builder: (context, state) {
                    if (state.status == ChatDetailStatus.loading &&
                        state.messages.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (state.status == ChatDetailStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.workspaceMissing
                                    ? context.tr.messagesWorkspaceMissing
                                    : (state.errorMessage ??
                                          context.tr.chatLoadError),
                                textAlign: TextAlign.center,
                                style: AppTextStyles.body(
                                  color: AppColors.greyText,
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () => context
                                    .read<ChatDetailCubit>()
                                    .loadMessages(),
                                child: Text(context.tr.messagesRetry),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    if (state.messages.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                context.tr.chatEmptyTitle,
                                style: AppTextStyles.heading2(),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                context.tr.chatEmptySubtitle,
                                style: AppTextStyles.caption(
                                  color: AppColors.greyText,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return _ChatBubble(
                          message: state.messages[index],
                          downloadingAttachmentId:
                              state.downloadingAttachmentId,
                        );
                      },
                    );
                  },
                ),
              ),
              BlocBuilder<ChatDetailCubit, ChatDetailState>(
                buildWhen: (p, c) =>
                    p.isSending != c.isSending ||
                    p.pendingAttachmentNames != c.pendingAttachmentNames,
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsetsDirectional.only(
                      start: 16,
                      end: 8,
                      top: 10,
                      bottom: MediaQuery.of(context).padding.bottom + 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.pendingAttachmentNames.isNotEmpty)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsetsDirectional.only(
                              start: 6,
                              end: 6,
                              bottom: 8,
                            ),
                            padding: const EdgeInsetsDirectional.only(
                              start: 10,
                              end: 10,
                              top: 8,
                              bottom: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.scaffoldBg,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.darkText.withValues(alpha: 0.06),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 34,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: state.pendingAttachmentNames.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, i) {
                                        final name = state.pendingAttachmentNames[i];
                                        return Container(
                                          padding: const EdgeInsetsDirectional.only(
                                            start: 10,
                                            end: 6,
                                            top: 6,
                                            bottom: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(999),
                                            border: Border.all(
                                              color: AppColors.darkText
                                                  .withValues(alpha: 0.06),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Iconsax.document,
                                                size: 16,
                                                color: AppColors.greyText,
                                              ),
                                              const SizedBox(width: 6),
                                              ConstrainedBox(
                                                constraints: const BoxConstraints(
                                                  maxWidth: 170,
                                                ),
                                                child: Text(
                                                  name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: AppTextStyles.caption(
                                                    color: AppColors.darkText,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              InkWell(
                                                onTap: state.isSending
                                                    ? null
                                                    : () => context
                                                        .read<ChatDetailCubit>()
                                                        .removePendingAttachmentAt(
                                                          i,
                                                        ),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                                child: const Padding(
                                                  padding: EdgeInsets.all(2),
                                                  child: Icon(
                                                    Icons.close,
                                                    size: 16,
                                                    color: AppColors.greyText,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: state.isSending
                                      ? null
                                      : () => context
                                          .read<ChatDetailCubit>()
                                          .clearPendingAttachments(),
                                  style: TextButton.styleFrom(
                                    foregroundColor: AppColors.greyText,
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 8),
                                    minimumSize: const Size(0, 34),
                                  ),
                                  child: Text(
                                    'مسح',
                                    style: AppTextStyles.caption(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: state.isSending
                                  ? null
                                  : () => context.read<ChatDetailCubit>().pickFiles(),
                              icon: const Icon(
                                Iconsax.paperclip,
                                color: AppColors.darkText,
                              ),
                            ),
                            IconButton(
                              onPressed: state.isSending
                                  ? null
                                  : () =>
                                      context.read<ChatDetailCubit>().pickImages(),
                              icon: const Icon(
                                Iconsax.gallery,
                                color: AppColors.darkText,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.scaffoldBg,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        AppColors.darkText.withValues(alpha: 0.05),
                                  ),
                                ),
                                child: TextField(
                                  controller: _messageController,
                                  readOnly: state.isSending,
                                  textAlign: TextAlign.start,
                                  decoration: InputDecoration(
                                    hintText: context.tr.chatTypeMessageHint,
                                    hintStyle: AppTextStyles.caption(
                                      color: AppColors.greyText,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 14,
                                    ),
                                  ),
                                  style: AppTextStyles.bodyMedium(),
                                  onSubmitted: state.isSending
                                      ? null
                                      : (_) => _submitMessage(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: state.isSending
                                  ? const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.darkText,
                                      ),
                                    )
                                  : IconButton(
                                      onPressed: () => _submitMessage(context),
                                      icon: const Icon(
                                        Icons.send_rounded,
                                        size: 20,
                                        color: AppColors.darkText,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitMessage(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<ChatDetailCubit>().sendMessage(_messageController.text);
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatBubbleRow message;
  final int? downloadingAttachmentId;

  const _ChatBubble({
    required this.message,
    required this.downloadingAttachmentId,
  });

  @override
  Widget build(BuildContext context) {
    // Outgoing on physical right, incoming on physical left (same in ar/en/fr).
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: message.isSent
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.72,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: message.isSent
                      ? AppColors.primary
                      : AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(message.isSent ? 16 : 4),
                    bottomRight: Radius.circular(message.isSent ? 4 : 16),
                  ),
                  boxShadow: message.isSent
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (message.text.isNotEmpty)
                      Text(
                        message.text,
                        textAlign: TextAlign.start,
                        style: AppTextStyles.body(color: AppColors.darkText),
                      ),
                    if (message.attachments.isNotEmpty) ...[
                      if (message.text.isNotEmpty) const SizedBox(height: 8),
                      ...message.attachments.map((a) {
                        final label = a.displayName.isNotEmpty
                            ? a.displayName
                            : context.tr.chatAttachmentFallback;
                        final loading = downloadingAttachmentId == a.id;
                        final isImage =
                            (a.mimeType ?? '').toLowerCase().startsWith('image/');
                        return Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 6),
                          child: Material(
                            color: AppColors.darkText.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              onTap: loading
                                  ? null
                                  : (a.id < 0)
                                      ? null
                                      : isImage && (a.url ?? '').isNotEmpty
                                          ? () => _showImagePreview(context, a)
                                          : () => context
                                                .read<ChatDetailCubit>()
                                                .downloadAttachment(a),
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (loading)
                                      const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.primary,
                                        ),
                                      )
                                    else
                                      Icon(
                                        isImage ? Iconsax.image : Iconsax.document,
                                        size: 18,
                                        color: AppColors.darkText,
                                      ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        label,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.start,
                                        style: AppTextStyles.caption(
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isImage ? 'عرض' : context.tr.chatAttachmentDownloadAction,
                                      textAlign: TextAlign.start,
                                      style: AppTextStyles.extraSmall(
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: message.isSent
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Text(message.time, style: AppTextStyles.extraSmall()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showImagePreview(BuildContext context, ChatAttachment attachment) {
  final token = sl<Storage>().getToken();
  final url = attachment.url ?? '';
  if (url.isEmpty) return;
  showDialog<void>(
    context: context,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.all(16),
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: InteractiveViewer(
                child: Image.network(
                  url,
                  fit: BoxFit.contain,
                  headers: {
                    if (token != null && token.isNotEmpty)
                      'Authorization': 'Bearer $token',
                    'Accept': '*/*',
                  },
                  errorBuilder: (_, __, ___) => Center(
                    child: Text(
                      'تعذر عرض الصورة',
                      style: AppTextStyles.body(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            PositionedDirectional(
              top: 8,
              end: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      );
    },
  );
}
