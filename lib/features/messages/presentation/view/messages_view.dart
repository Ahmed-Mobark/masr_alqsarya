import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/data/dummy_data.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/messages/presentation/view/chat_view.dart';

class MessagesView extends StatefulWidget {
  const MessagesView({super.key});

  @override
  State<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends State<MessagesView> {
  int _selectedTab = 0;

  List<MessageItem> get _filteredMessages {
    if (_selectedTab == 1) {
      return DummyData.messages.where((m) => m.unreadCount > 0).toList();
    }
    return DummyData.messages;
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
          // Search bar
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
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
                  Text(context.tr.messagesSearch,
                      style:
                          AppTextStyles.caption(color: AppColors.greyText)),
                ],
              ),
            ),
          ),

          // Tabs: All | Unread | Mark all as read
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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

          // Messages list
          Expanded(
            child: Container(
              color: AppColors.background,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _filteredMessages.length,
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  indent: 80,
                  endIndent: 16,
                  color: AppColors.border.withValues(alpha: 0.5),
                ),
                itemBuilder: (context, index) {
                  final msg = _filteredMessages[index];
                  return _MessageTile(message: msg);
                },
              ),
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
  final MessageItem message;
  const _MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        sl<AppNavigator>().push(
          screen: ChatView(
            name: message.name,
            avatarUrl: message.avatarUrl,
          ),
        );
      },
      child: Container(
        color: AppColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar with colored ring
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: message.avatarRingColor,
                  width: 2.5,
                ),
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: message.avatarRingColor.withValues(alpha: 0.1),
                  ),
                  child: Icon(
                    Iconsax.user,
                    size: 22,
                    color: message.avatarRingColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Name + role + message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(message.name, style: AppTextStyles.button()),
                      const SizedBox(width: 4),
                      Text(
                        '( ${message.role} )',
                        style: AppTextStyles.button(
                          color: message.roleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message.lastMessage,
                    style: AppTextStyles.caption(color: AppColors.greyText),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Date + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(message.time,
                    style: AppTextStyles.small(color: AppColors.greyText)),
                if (message.unreadCount > 0) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: message.roleColor,
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
