import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class _ChatMessage {
  final String text;
  final bool isSent;
  final String time;

  const _ChatMessage({
    required this.text,
    required this.isSent,
    required this.time,
  });
}

class ChatView extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const ChatView({
    super.key,
    required this.name,
    required this.avatarUrl,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      text: 'Hi, can we discuss the pickup time for tomorrow?',
      isSent: false,
      time: '10:30 AM',
    ),
    _ChatMessage(
      text: 'Sure, what time works for you?',
      isSent: true,
      time: '10:32 AM',
    ),
    _ChatMessage(
      text: 'I was thinking around 3:30 PM after school.',
      isSent: false,
      time: '10:33 AM',
    ),
    _ChatMessage(
      text: 'That works for me. I\'ll be there at 3:30.',
      isSent: true,
      time: '10:35 AM',
    ),
    _ChatMessage(
      text: 'Great, thank you! Also, don\'t forget the doctor appointment on Friday.',
      isSent: false,
      time: '10:36 AM',
    ),
    _ChatMessage(
      text: 'Yes, I have it in the calendar. I\'ll take care of it.',
      isSent: true,
      time: '10:38 AM',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left, color: AppColors.darkText),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            ClipOval(
              child: CachedNetworkImage(
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
                  child: const Icon(Iconsax.user, size: 18, color: AppColors.greyText),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.name, style: AppTextStyles.heading2()),
          ],
        ),
      ),
      body: Column(
        children: [
          // Chat bubbles
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatBubble(message: msg);
              },
            ),
          ),

          // Message input bar
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 8,
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
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.inputBg,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: context.tr.chatTypeMessageHint,
                        hintStyle: AppTextStyles.caption(color: AppColors.greyText),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      style: AppTextStyles.bodyMedium(),
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
                  child: IconButton(
                    onPressed: () {
                      // TODO: Send message
                      _messageController.clear();
                    },
                    icon: const Icon(Iconsax.send_1, size: 20, color: AppColors.darkText),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final _ChatMessage message;
  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: message.isSent ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              message.isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
              child: Text(
                message.text,
                style: AppTextStyles.body(color: AppColors.darkText),
              ),
            ),
            const SizedBox(height: 4),
            Text(message.time, style: AppTextStyles.extraSmall()),
          ],
        ),
      ),
    );
  }
}
