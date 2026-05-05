import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/config/app_icons.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_attachment.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/chat_detail_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/chat_detail_state.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/conversation_insights_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/conversation_insights_view.dart';

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

  void _scrollToBottom({bool animated = true}) {
    if (!_scrollController.hasClients) return;
    final target = _scrollController.position.maxScrollExtent;
    if (animated) {
      _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(target);
    }
  }

  void _scrollToBottomAfterFrame({bool animated = true}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToBottom(animated: animated);
    });
  }

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
          ((prev.toneWarning != curr.toneWarning ||
                  prev.toneSuggestedAlternative !=
                      curr.toneSuggestedAlternative) &&
              curr.toneWarning != null &&
              curr.toneSuggestedAlternative != null) ||
          (prev.sendError != curr.sendError && curr.sendError != null) ||
          (prev.isSending && !curr.isSending && curr.sendError == null) ||
          (prev.attachmentFeedback != curr.attachmentFeedback &&
              curr.attachmentFeedback != null),
      listener: (context, state) {
        if (state.toneWarning != null &&
            state.toneSuggestedAlternative != null) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => _ToneAssistantSheet(
              warning: state.toneWarning!,
              suggestedAlternative: state.toneSuggestedAlternative!,
              onRephrase: (_) {
                Navigator.pop(context);
                context.read<ChatDetailCubit>().sendToneSuggestedMessage();
              },
              onClose: () {
                Navigator.pop(context);
                context
                    .read<ChatDetailCubit>()
                    .sendOriginalAfterToneSuggestionDismiss();
              },
            ),
          );
          return;
        }
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
          if (state.sendError == '__blocked__') {
            showDialog<void>(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(context.tr.chatBlockedAlertTitle),
                content: Text(
                  '${state.moderationBlockReason ?? context.tr.chatBlockedDefaultReason}\n'
                  '${context.tr.chatBlockedWarningCount(state.warningCount)}',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(context.tr.chatBlockedOk),
                  ),
                ],
              ),
            );
          } else {
            final msg = state.sendError == '__workspace_missing__'
                ? context.tr.messagesWorkspaceMissing
                : state.sendError!;
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(msg)));
          }
          context.read<ChatDetailCubit>().clearSendError();
          return;
        }
        _messageController.clear();
        _scrollToBottomAfterFrame();
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
            actions: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 4),
                child: _TopActionIconButton(
                  iconPath: AppIcons.chatInsights,
                  onTap: () {
                    final workspaceId = sl<WorkspaceIdStorage>().get();
                    if (workspaceId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.tr.messagesWorkspaceMissing)),
                      );
                      return;
                    }
                    sl<AppNavigator>().push(
                      screen: BlocProvider(
                        create: (_) => sl<ConversationInsightsCubit>()
                          ..load(
                            workspaceId: workspaceId,
                            chatId: widget.chatId,
                          ),
                        child: const ConversationInsightsView(),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 12),
                child: _TopActionIconButton(
                  iconPath: AppIcons.chatPolicy,
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => const _ConversationPolicySheet(),
                    );
                  },
                ),
              ),
            ],
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
                child: BlocConsumer<ChatDetailCubit, ChatDetailState>(
                  listenWhen: (prev, curr) =>
                      prev.messages.length != curr.messages.length,
                  listener: (context, state) {
                    // Ensure the newest message is visible.
                    _scrollToBottomAfterFrame();
                  },
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
                      start: 16.w,
                      end: 16.w,
                      top: 10.h,
                      bottom: MediaQuery.of(context).padding.bottom + 10.h,
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
                            margin: EdgeInsetsDirectional.only(
                              start: 6.w,
                              end: 6.w,
                              bottom: 8.h,
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
                                color: AppColors.darkText.withValues(
                                  alpha: 0.06,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: 34,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          state.pendingAttachmentNames.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 8),
                                      itemBuilder: (context, i) {
                                        final name =
                                            state.pendingAttachmentNames[i];
                                        return Container(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                start: 10,
                                                end: 6,
                                                top: 6,
                                                bottom: 6,
                                              ),
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(
                                              999,
                                            ),
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
                                                constraints:
                                                    const BoxConstraints(
                                                      maxWidth: 170,
                                                    ),
                                                child: Text(
                                                  name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                                                          .read<
                                                            ChatDetailCubit
                                                          >()
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    minimumSize: const Size(0, 34),
                                  ),
                                  child: Text(
                                    context.tr.chatClearAttachments,
                                    style: AppTextStyles.caption(
                                      color: AppColors.greyText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsetsDirectional.fromSTEB(
                            14.w,
                            8.h,
                            8.w,
                            8.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(28.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _messageController,
                                  readOnly: state.isSending,
                                  minLines: 1,
                                  maxLines: 5,
                                  textAlign: TextAlign.start,
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    isCollapsed: false,
                                    hintText: context.tr.chatTypeMessageHint,
                                    hintStyle: AppTextStyles.caption(
                                      color: AppColors.captionText,
                                    ).copyWith(fontSize: 14.sp),
                                    border: InputBorder.none,
                                    contentPadding:
                                        EdgeInsetsDirectional.fromSTEB(
                                      4.w,
                                      10.h,
                                      8.w,
                                      10.h,
                                    ),
                                  ),
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.greyText,
                                  ).copyWith(fontSize: 15.sp),
                                  onSubmitted: state.isSending
                                      ? null
                                      : (_) => _submitMessage(context),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              _ChatInputCircleButton(
                                isLoading: state.isSending,
                                icon: Iconsax.send_2,
                                onPressed: state.isSending
                                    ? null
                                    : () => _submitMessage(context),
                              ),
                              SizedBox(width: 8.w),
                              _ChatInputCircleButton(
                                icon: Iconsax.paperclip,
                                onPressed: state.isSending
                                    ? null
                                    : () =>
                                        _showChatAttachmentOptions(context),
                              ),
                            ],
                          ),
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

  void _showChatAttachmentOptions(BuildContext context) {
    final tr = context.tr;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 4.h),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  tr.chatAttachMenuTitle,
                  style: AppTextStyles.heading2(color: AppColors.darkText)
                      .copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Iconsax.gallery, color: AppColors.darkText),
              title: Text(
                tr.chatAttachFromGallery,
                style: AppTextStyles.body(color: AppColors.darkText),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                if (!context.mounted) return;
                context.read<ChatDetailCubit>().pickMedia();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.document, color: AppColors.darkText),
              title: Text(
                tr.chatAttachFromFiles,
                style: AppTextStyles.body(color: AppColors.darkText),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                if (!context.mounted) return;
                context.read<ChatDetailCubit>().pickFiles();
              },
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}

class _ChatInputCircleButton extends StatelessWidget {
  const _ChatInputCircleButton({
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        customBorder: const CircleBorder(),
        child: Ink(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 22.w,
                    height: 22.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.white,
                    ),
                  )
                : Icon(
                    icon,
                    color: AppColors.white,
                    size: 22.sp,
                  ),
          ),
        ),
      ),
    );
  }
}

class _ToneAssistantSheet extends StatelessWidget {
  const _ToneAssistantSheet({
    required this.warning,
    required this.suggestedAlternative,
    required this.onRephrase,
    required this.onClose,
  });

  final String warning;
  final String suggestedAlternative;
  final void Function(String suggested) onRephrase;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: padding),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2E0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFE07A00),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr.chatToneAssistantTitle,
                      style: AppTextStyles.heading2(),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, color: AppColors.greyText),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '"$warning"',
                style: AppTextStyles.body().copyWith(
                  color: const Color(0xFFE07A00),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                context.tr.chatToneSuggestedAlternative,
                style: AppTextStyles.body().copyWith(
                  color: AppColors.greyText,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7EA),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFFD9A6)),
                ),
                child: Text(
                  suggestedAlternative,
                  style: AppTextStyles.body().copyWith(
                    color: AppColors.darkText,
                    height: 1.35,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54D),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => onRephrase(suggestedAlternative),
                  child: Text(
                    context.tr.chatToneRephraseMessage,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkText,
                    side: BorderSide(
                      color: AppColors.darkText.withValues(alpha: 0.12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: onClose,
                  child: Text(
                    context.tr.chatToneSendAsIs,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopActionIconButton extends StatelessWidget {
  const _TopActionIconButton({required this.iconPath, required this.onTap});

  final String iconPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.35)),
          color: AppColors.background,
        ),
        child: Center(
          child: AppIcons.icon(icon: iconPath, size: 30.w),
        ),
      ),
    );
  }
}

class _ConversationPolicySheet extends StatelessWidget {
  const _ConversationPolicySheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadiusDirectional.only(
            topStart: Radius.circular(28),
            topEnd: Radius.circular(28),
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(
            start: 20,
            end: 20,
            top: 24,
            bottom: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.18),
                    ),
                    child: Center(
                      child: AppIcons.icon(
                        icon: AppIcons.chatPolicy,
                        size: 30.w,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      context.tr.chatPolicyTitle,
                      style: AppTextStyles.heading2(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _PolicyItem(
                icon: Icons.delete_outline_rounded,
                title: context.tr.chatPolicyDeletionTitle,
                description: context.tr.chatPolicyDeletionDescription,
              ),
              const SizedBox(height: 16),
              _PolicyItem(
                icon: Icons.history_rounded,
                title: context.tr.chatPolicyHistoryTitle,
                description: context.tr.chatPolicyHistoryDescription,
              ),
              const SizedBox(height: 16),
              _PolicyItem(
                icon: Icons.gavel_rounded,
                title: context.tr.chatPolicyLegalTitle,
                description: context.tr.chatPolicyLegalDescription,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    context.tr.chatPolicyAcknowledge,
                    style: AppTextStyles.button().copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  const _PolicyItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium().copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTextStyles.caption(color: AppColors.greyText),
              ),
            ],
          ),
        ),
      ],
    );
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
                    if (message.isFlagged)
                      Container(
                        margin: const EdgeInsetsDirectional.only(bottom: 8),
                        padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE8E7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              size: 14,
                              color: Color(0xFFD43C38),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              context.tr.chatFlaggedMessage,
                              style: AppTextStyles.extraSmall(
                                color: const Color(0xFFD43C38),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                        final isImage = (a.mimeType ?? '')
                            .toLowerCase()
                            .startsWith('image/');
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
                                        isImage
                                            ? Iconsax.image
                                            : Iconsax.document,
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
                                      isImage
                                          ? context.tr.chatAttachmentViewAction
                                          : context
                                                .tr
                                                .chatAttachmentDownloadAction,
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
                  errorBuilder: (context, __, ___) => Center(
                    child: Text(
                      context.tr.chatImagePreviewFailed,
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
