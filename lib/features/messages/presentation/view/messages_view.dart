import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/messages/domain/entities/chat_thread.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/messages_cubit.dart';
import 'package:masr_al_qsariya/features/messages/presentation/cubit/messages_state.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/chat_detail_page.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  int _selectedTab = 0;

  List<ChatThread> _filtered(List<ChatThread> threads) {
    if (_selectedTab == 1) {
      return threads.where((m) => m.unreadCount > 0).toList();
    }
    return threads;
  }

  String _errorLabel(String? raw, BuildContext context) {
    if (raw == '__workspace_missing__') {
      return context.tr.messagesWorkspaceMissing;
    }
    return raw ?? context.tr.messagesLoadError;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: Text(context.tr.messagesTitle, style: AppTextStyles.navTitle()),
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: AppColors.background,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 12),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Iconsax.search_normal,
                      size: 18, color: AppColors.greyText),
                  const SizedBox(width: 8),
                  Text(
                    context.tr.messagesSearch,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: AppColors.background,
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Row(
              children: [
                _TabButton(
                  label: context.tr.messagesAll,
                  isSelected: _selectedTab == 0,
                  onTap: () => setState(() => _selectedTab = 0),
                ),
                const SizedBox(width: 24),
                _TabButton(
                  label: context.tr.messagesUnread,
                  isSelected: _selectedTab == 1,
                  onTap: () => setState(() => _selectedTab = 1),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    context.tr.messagesMarkAllRead,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<MessagesCubit, MessagesState>(
              builder: (context, state) {
                if (state.status == MessagesStatus.loading &&
                    state.threads.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                if (state.status == MessagesStatus.failure) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorLabel(state.errorMessage, context),
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body(color: AppColors.greyText),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () =>
                                context.read<MessagesCubit>().loadThreads(),
                            child: Text(context.tr.messagesRetry),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final list = _filtered(state.threads);
                if (list.isEmpty) {
                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () =>
                        context.read<MessagesCubit>().loadThreads(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                        Text(
                          context.tr.messagesEmptyTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.heading2(),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            context.tr.messagesEmptySubtitle,
                            textAlign: TextAlign.center,
                            style:
                                AppTextStyles.caption(color: AppColors.greyText),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: () =>
                      context.read<MessagesCubit>().loadThreads(),
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 80,
                      endIndent: 16,
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                    itemBuilder: (context, index) {
                      return _MessageTile(message: list[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.button(
              color: isSelected ? AppColors.primaryDark : AppColors.greyText,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 2,
            width: 40,
            color: isSelected ? AppColors.primaryDark : AppColors.transparent,
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final ChatThread message;
  const _MessageTile({required this.message});

  String _localizedRole(BuildContext context, String raw) {
    switch (raw) {
      case 'owner':
        return context.tr.messagesRoleOwner;
      case 'co_partner':
        return context.tr.messagesRoleCoPartner;
      case 'child':
        return context.tr.messagesRoleChild;
      default:
        return raw;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = message.unreadCount > 0
        ? AppColors.primaryDark
        : AppColors.border;
    final roleColor =
        message.roleLabel.isNotEmpty ? AppColors.primaryDark : AppColors.greyText;

    return InkWell(
      onTap: () {
        sl<AppNavigator>().push(
          screen: ChatDetailPage(
            chatId: message.id,
            name: message.displayName,
            avatarUrl: message.avatarUrl,
          ),
        );
      },
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ringColor,
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ringColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Iconsax.user,
                    size: 22,
                    color: ringColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          message.displayName,
                          style: AppTextStyles.button(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (message.roleLabel.isNotEmpty) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '( ${_localizedRole(context, message.roleLabel)} )',
                            style: AppTextStyles.button(
                              color: roleColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.lastPreview.isEmpty
                        ? context.tr.messagesNoPreview
                        : message.lastPreview,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.timeLabel,
                  style: AppTextStyles.small(color: AppColors.greyText),
                ),
                if (message.unreadCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: roleColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${message.unreadCount}',
                        style: AppTextStyles.tiny(color: AppColors.white),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
