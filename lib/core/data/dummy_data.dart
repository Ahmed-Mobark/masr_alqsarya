import 'package:flutter/material.dart';

class QuickActionItem {
  final String title;
  final IconData icon;
  final Color iconColor;

  const QuickActionItem({
    required this.title,
    required this.icon,
    required this.iconColor,
  });
}

class AwaitingItem {
  final String titleKey;
  final String subtitle;
  final String badgeKey;
  final IconData icon;

  const AwaitingItem({
    required this.titleKey,
    required this.subtitle,
    required this.badgeKey,
    required this.icon,
  });
}

class ActivityItem {
  final String titleKey;
  final String subtitle;
  final IconData icon;
  final String? actionKey;

  const ActivityItem({
    required this.titleKey,
    required this.subtitle,
    required this.icon,
    this.actionKey,
  });
}

class MessageItem {
  final String name;
  final String role;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final Color roleColor;
  final Color avatarRingColor;

  const MessageItem({
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
    required this.roleColor,
    required this.avatarRingColor,
  });
}

class NewsItem {
  final String title;
  final String body;
  final String imageUrl;
  final String source;
  final String date;

  const NewsItem({
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.source,
    required this.date,
  });
}

class CalendarEvent {
  final String id;
  final String title;
  final String titleAr;
  final String titleFr;
  final DateTime date;
  final String time;
  final Color color;
  final String type;
  final String? location;
  final String? notes;
  final String? status;
  final String? expenseAmount;
  final String? expenseCategory;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.date,
    required this.time,
    required this.color,
    required this.type,
    this.location,
    this.notes,
    this.status,
    this.expenseAmount,
    this.expenseCategory,
  });
}

enum ExpenseType { regular, support }

class ExpenseItem {
  final String childName;
  final String submittedBy;
  final String category;
  final String referenceNumber;
  final String paymentPeriod;
  final double amount;
  final ExpenseType type;
  final String? courtCase;

  const ExpenseItem({
    required this.childName,
    required this.submittedBy,
    required this.category,
    required this.referenceNumber,
    required this.paymentPeriod,
    required this.amount,
    required this.type,
    this.courtCase,
  });
}

abstract class DummyData {
  static const List<QuickActionItem> quickActions = [
    QuickActionItem(
      title: 'Schedule',
      icon: Icons.calendar_month_outlined,
      iconColor: Color(0xFF5B7FFF),
    ),
    QuickActionItem(
      title: 'Messages',
      icon: Icons.chat_bubble_outline,
      iconColor: Color(0xFF645A9E),
    ),
    QuickActionItem(
      title: 'Expense',
      icon: Icons.receipt_long_outlined,
      iconColor: Color(0xFFC93E27),
    ),
    QuickActionItem(
      title: 'News',
      icon: Icons.newspaper_outlined,
      iconColor: Color(0xFF1976D2),
    ),
    QuickActionItem(
      title: 'Profile',
      icon: Icons.person_outline,
      iconColor: Color(0xFF1FC16B),
    ),
    QuickActionItem(
      title: 'Settings',
      icon: Icons.settings_outlined,
      iconColor: Color(0xFF555555),
    ),
  ];

  static const List<AwaitingItem> awaitingItems = [
    AwaitingItem(
      titleKey: 'upcomingCall',
      subtitle: 'Father · Today, 4:00 PM',
      badgeKey: 'reminder',
      icon: Icons.phone_outlined,
    ),
  ];

  static const List<ActivityItem> recentActivity = [
    ActivityItem(
      titleKey: 'newEvent',
      subtitle: 'Lorem ipsum dolor sit amet consectetur. Amet ipsum nunc',
      icon: Icons.calendar_today_outlined,
    ),
    ActivityItem(
      titleKey: 'newSession',
      subtitle: 'Lorem ipsum dolor sit amet consectetur. Amet ipsum nunc',
      icon: Icons.videocam_outlined,
    ),
    ActivityItem(
      titleKey: 'pendingCost',
      subtitle: 'Lorem ipsum dolor sit amet consectetur. Amet ipsum nunc',
      icon: Icons.receipt_long_outlined,
      actionKey: 'review',
    ),
  ];

  static const List<MessageItem> messages = [
    MessageItem(
      name: 'Peter',
      role: 'Father',
      avatarUrl: '',
      lastMessage: 'Lorem ipsum dolor sit amet consectetur. Mi ullamcorper egestas feugiat amet montes',
      time: '19/5/2025',
      unreadCount: 2,
      isOnline: false,
      roleColor: Color(0xFF5B7FFF),
      avatarRingColor: Color(0xFF5B7FFF),
    ),
    MessageItem(
      name: 'Grace',
      role: 'Mother',
      avatarUrl: '',
      lastMessage: 'Lorem ipsum dolor sit amet consectetur. Mi ullamcorper egestas feugiat amet montes',
      time: '19/5/2025',
      unreadCount: 2,
      isOnline: false,
      roleColor: Color(0xFFE91E8C),
      avatarRingColor: Color(0xFFE91E8C),
    ),
    MessageItem(
      name: 'Andres',
      role: 'Children',
      avatarUrl: '',
      lastMessage: 'Lorem ipsum dolor sit amet consectetur. Mi ullamcorper egestas feugiat amet montes',
      time: '19/5/2025',
      unreadCount: 2,
      isOnline: false,
      roleColor: Color(0xFF1FC16B),
      avatarRingColor: Color(0xFF1FC16B),
    ),
    MessageItem(
      name: 'Chad Ernser',
      role: 'Lawyer',
      avatarUrl: '',
      lastMessage: 'Lorem ipsum dolor sit amet consectetur. Mi ullamcorper egestas feugiat amet montes',
      time: '19/5/2025',
      unreadCount: 2,
      isOnline: false,
      roleColor: Color(0xFFFEDB65),
      avatarRingColor: Color(0xFFFEDB65),
    ),
  ];

  static const List<NewsItem> newsFeed = [
    NewsItem(
      title: 'New school term dates announced',
      body: 'The education ministry published the updated calendar for the new term.',
      imageUrl: 'https://picsum.photos/seed/news1/800/400',
      source: 'Local News',
      date: 'Apr 12',
    ),
    NewsItem(
      title: 'Family support resources',
      body: 'A curated list of resources for co-parenting and family coordination.',
      imageUrl: 'https://picsum.photos/seed/news2/800/400',
      source: 'Community',
      date: 'Apr 09',
    ),
  ];

  static const List<ExpenseItem> expenses = [
    ExpenseItem(
      childName: 'Andres',
      submittedBy: 'Leslie Pfeffer',
      category: 'Education',
      referenceNumber: 'EXP-2025-001',
      paymentPeriod: 'Apr 2025',
      amount: 1500.00,
      type: ExpenseType.regular,
    ),
    ExpenseItem(
      childName: 'Andres',
      submittedBy: 'Peter Parker',
      category: 'Healthcare',
      referenceNumber: 'EXP-2025-002',
      paymentPeriod: 'Apr 2025',
      amount: 850.00,
      type: ExpenseType.regular,
    ),
    ExpenseItem(
      childName: 'Andres',
      submittedBy: 'Leslie Pfeffer',
      category: 'Court Case #1234',
      referenceNumber: 'SUP-2025-001',
      paymentPeriod: 'Mar 2025',
      amount: 3000.00,
      type: ExpenseType.support,
      courtCase: '#1234',
    ),
    ExpenseItem(
      childName: 'Andres',
      submittedBy: 'Peter Parker',
      category: 'Court Case #5678',
      referenceNumber: 'SUP-2025-002',
      paymentPeriod: 'Apr 2025',
      amount: 3000.00,
      type: ExpenseType.support,
      courtCase: '#5678',
    ),
  ];
}

