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
  final String title;
  final String from;
  final String status;
  final String time;

  const AwaitingItem({
    required this.title,
    required this.from,
    required this.status,
    required this.time,
  });
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color iconBgColor;

  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.iconBgColor,
  });
}

class MessageItem {
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const MessageItem({
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
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

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.date,
    required this.time,
    required this.color,
    required this.type,
  });
}

class ExpenseItem {
  final String title;
  final String category;
  final String date;
  final double amount;
  final String paidBy;
  final IconData icon;

  const ExpenseItem({
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    required this.paidBy,
    required this.icon,
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
      title: 'Change pickup time?',
      from: 'Alex',
      status: 'Pending',
      time: '2h ago',
    ),
    AwaitingItem(
      title: 'Approve school trip',
      from: 'School Admin',
      status: 'Action',
      time: 'Yesterday',
    ),
  ];

  static const List<ActivityItem> recentActivity = [
    ActivityItem(
      title: 'Expense added',
      subtitle: 'Groceries • \$62.75',
      time: 'Today',
      icon: Icons.shopping_bag_outlined,
      iconBgColor: Color(0xFFFEDB65),
    ),
    ActivityItem(
      title: 'New message',
      subtitle: 'Pickup time confirmed',
      time: 'Yesterday',
      icon: Icons.chat_bubble_outline,
      iconBgColor: Color(0xFF5B7FFF),
    ),
    ActivityItem(
      title: 'Schedule updated',
      subtitle: 'Doctor appointment added',
      time: '2 days',
      icon: Icons.calendar_month_outlined,
      iconBgColor: Color(0xFFD00416),
    ),
  ];

  static const List<MessageItem> messages = [
    MessageItem(
      name: 'Alex',
      avatarUrl: 'https://i.pravatar.cc/150?img=3',
      lastMessage: 'See you at 3:30 PM.',
      time: '10:38 AM',
      unreadCount: 0,
      isOnline: true,
    ),
    MessageItem(
      name: 'School Admin',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      lastMessage: 'Please confirm the trip form.',
      time: 'Yesterday',
      unreadCount: 2,
      isOnline: false,
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
      title: 'School Fees',
      category: 'Education',
      date: 'Apr 02',
      amount: 150.00,
      paidBy: 'Parent A',
      icon: Icons.school_outlined,
    ),
    ExpenseItem(
      title: 'Doctor Visit',
      category: 'Healthcare',
      date: 'Apr 06',
      amount: 85.50,
      paidBy: 'Parent B',
      icon: Icons.local_hospital_outlined,
    ),
    ExpenseItem(
      title: 'Sports Class',
      category: 'Activities',
      date: 'Apr 10',
      amount: 45.00,
      paidBy: 'Parent A',
      icon: Icons.sports_soccer,
    ),
    ExpenseItem(
      title: 'Groceries',
      category: 'Essentials',
      date: 'Apr 12',
      amount: 62.75,
      paidBy: 'Parent B',
      icon: Icons.shopping_bag_outlined,
    ),
  ];
}

