import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// ── Quick Action Item ─────────────────────────────────────────────────
class QuickActionItem {
  final String title;
  final String titleAr;
  final String titleFr;
  final IconData icon;
  final Color iconColor;

  const QuickActionItem({
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.icon,
    this.iconColor = const Color(0xFFFBBC05),
  });
}

// ── Activity Item ─────────────────────────────────────────────────────
class ActivityItem {
  final String id;
  final String title;
  final String titleAr;
  final String titleFr;
  final String subtitle;
  final String subtitleAr;
  final String subtitleFr;
  final String time;
  final IconData icon;
  final Color iconBgColor;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.subtitle,
    required this.subtitleAr,
    required this.subtitleFr,
    required this.time,
    required this.icon,
    this.iconBgColor = const Color(0xFFFEDB65),
  });
}

// ── Awaiting Response Item ────────────────────────────────────────────
class AwaitingItem {
  final String id;
  final String title;
  final String titleAr;
  final String titleFr;
  final String from;
  final String status;
  final String statusAr;
  final String statusFr;
  final String time;

  const AwaitingItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.from,
    required this.status,
    required this.statusAr,
    required this.statusFr,
    required this.time,
  });
}

// ── Message Item ──────────────────────────────────────────────────────
class MessageItem {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const MessageItem({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

// ── Expense Item ──────────────────────────────────────────────────────
class ExpenseItem {
  final String id;
  final String title;
  final String titleAr;
  final String titleFr;
  final String category;
  final double amount;
  final String date;
  final String paidBy;
  final IconData icon;

  const ExpenseItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.category,
    required this.amount,
    required this.date,
    required this.paidBy,
    required this.icon,
  });
}

// ── News Item ─────────────────────────────────────────────────────────
class NewsItem {
  final String id;
  final String title;
  final String titleAr;
  final String titleFr;
  final String body;
  final String bodyAr;
  final String bodyFr;
  final String imageUrl;
  final String date;
  final String source;

  const NewsItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.titleFr,
    required this.body,
    required this.bodyAr,
    required this.bodyFr,
    required this.imageUrl,
    required this.date,
    required this.source,
  });
}

// ── Calendar Event ────────────────────────────────────────────────────
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

// ══════════════════════════════════════════════════════════════════════
// DUMMY DATA
// ══════════════════════════════════════════════════════════════════════

class DummyData {
  DummyData._();

  // ── Quick Actions ───────────────────────────────────────────────────
  static const List<QuickActionItem> quickActions = [
    QuickActionItem(
      title: 'Schedule',
      titleAr: 'الجدول',
      titleFr: 'Calendrier',
      icon: Iconsax.calendar,
    ),
    QuickActionItem(
      title: 'Expense',
      titleAr: 'المصاريف',
      titleFr: 'Dépenses',
      icon: Iconsax.wallet_3,
    ),
    QuickActionItem(
      title: 'Documents',
      titleAr: 'المستندات',
      titleFr: 'Documents',
      icon: Iconsax.document,
    ),
    QuickActionItem(
      title: 'Messages',
      titleAr: 'الرسائل',
      titleFr: 'Messages',
      icon: Iconsax.message,
    ),
    QuickActionItem(
      title: 'Sessions',
      titleAr: 'الجلسات',
      titleFr: 'Séances',
      icon: Iconsax.video,
    ),
    QuickActionItem(
      title: 'News',
      titleAr: 'الأخبار',
      titleFr: 'Actualités',
      icon: Iconsax.note,
    ),
  ];

  // ── Awaiting Response ───────────────────────────────────────────────
  static const List<AwaitingItem> awaitingItems = [
    AwaitingItem(
      id: '1',
      title: 'Schedule Change Request',
      titleAr: 'طلب تغيير الجدول',
      titleFr: 'Demande de changement',
      from: 'Co-parent',
      status: 'Pending',
      statusAr: 'قيد الانتظار',
      statusFr: 'En attente',
      time: '2h ago',
    ),
    AwaitingItem(
      id: '2',
      title: 'Expense Approval',
      titleAr: 'موافقة على المصاريف',
      titleFr: 'Approbation de dépense',
      from: 'Co-parent',
      status: 'Pending',
      statusAr: 'قيد الانتظار',
      statusFr: 'En attente',
      time: '5h ago',
    ),
  ];

  // ── Recent Activity ─────────────────────────────────────────────────
  static const List<ActivityItem> recentActivity = [
    ActivityItem(
      id: '1',
      title: 'Schedule Updated',
      titleAr: 'تم تحديث الجدول',
      titleFr: 'Calendrier mis à jour',
      subtitle: 'Weekend swap confirmed for March 15',
      subtitleAr: 'تم تأكيد تبادل عطلة نهاية الأسبوع في 15 مارس',
      subtitleFr: 'Échange de week-end confirmé pour le 15 mars',
      time: '1h ago',
      icon: Iconsax.calendar_tick,
    ),
    ActivityItem(
      id: '2',
      title: 'New Document Shared',
      titleAr: 'مستند جديد تمت مشاركته',
      titleFr: 'Nouveau document partagé',
      subtitle: 'Medical report uploaded',
      subtitleAr: 'تم تحميل التقرير الطبي',
      subtitleFr: 'Rapport médical téléchargé',
      time: '3h ago',
      icon: Iconsax.document_upload,
    ),
    ActivityItem(
      id: '3',
      title: 'Expense Added',
      titleAr: 'تمت إضافة مصروف',
      titleFr: 'Dépense ajoutée',
      subtitle: 'School supplies - \$45.00',
      subtitleAr: 'مستلزمات مدرسية - 45.00\$',
      subtitleFr: 'Fournitures scolaires - 45,00\$',
      time: '5h ago',
      icon: Iconsax.wallet_add,
    ),
    ActivityItem(
      id: '4',
      title: 'Message Received',
      titleAr: 'تم استلام رسالة',
      titleFr: 'Message reçu',
      subtitle: 'Regarding pickup time tomorrow',
      subtitleAr: 'بخصوص موعد الاستلام غداً',
      subtitleFr: 'Concernant l\'heure de prise en charge demain',
      time: '8h ago',
      icon: Iconsax.message_text,
    ),
  ];

  // ── Messages ────────────────────────────────────────────────────────
  static const List<MessageItem> messages = [
    MessageItem(
      id: '1',
      name: 'Sarah Johnson',
      avatarUrl: 'https://picsum.photos/100/100?random=20',
      lastMessage: 'Can we discuss the pickup time?',
      time: '2m ago',
      unreadCount: 2,
      isOnline: true,
    ),
    MessageItem(
      id: '2',
      name: 'Dr. Williams',
      avatarUrl: 'https://picsum.photos/100/100?random=21',
      lastMessage: 'Session notes are ready',
      time: '1h ago',
      unreadCount: 1,
    ),
    MessageItem(
      id: '3',
      name: 'Family Mediator',
      avatarUrl: 'https://picsum.photos/100/100?random=22',
      lastMessage: 'Next session is scheduled',
      time: '3h ago',
    ),
    MessageItem(
      id: '4',
      name: 'School Admin',
      avatarUrl: 'https://picsum.photos/100/100?random=23',
      lastMessage: 'Report card is available',
      time: 'Yesterday',
    ),
  ];

  // ── Expenses ────────────────────────────────────────────────────────
  static const List<ExpenseItem> expenses = [
    ExpenseItem(
      id: '1',
      title: 'School Tuition',
      titleAr: 'الرسوم الدراسية',
      titleFr: 'Frais de scolarité',
      category: 'Education',
      amount: 1500.00,
      date: '2026-03-01',
      paidBy: 'Parent A',
      icon: Iconsax.teacher,
    ),
    ExpenseItem(
      id: '2',
      title: 'Medical Checkup',
      titleAr: 'فحص طبي',
      titleFr: 'Bilan médical',
      category: 'Healthcare',
      amount: 250.00,
      date: '2026-03-05',
      paidBy: 'Parent B',
      icon: Iconsax.health,
    ),
    ExpenseItem(
      id: '3',
      title: 'After School Activities',
      titleAr: 'أنشطة بعد المدرسة',
      titleFr: 'Activités parascolaires',
      category: 'Activities',
      amount: 120.00,
      date: '2026-03-10',
      paidBy: 'Parent A',
      icon: Iconsax.activity,
    ),
    ExpenseItem(
      id: '4',
      title: 'Clothing',
      titleAr: 'ملابس',
      titleFr: 'Vêtements',
      category: 'Essentials',
      amount: 85.00,
      date: '2026-03-12',
      paidBy: 'Parent B',
      icon: Iconsax.shopping_bag,
    ),
  ];

  // ── News Feed ───────────────────────────────────────────────────────
  static const List<NewsItem> newsFeed = [
    NewsItem(
      id: '1',
      title: 'Co-Parenting Communication Tips',
      titleAr: 'نصائح للتواصل بين الوالدين',
      titleFr: 'Conseils de communication co-parentale',
      body: 'Effective communication is key to successful co-parenting. Here are some tips to help you navigate conversations with your co-parent.',
      bodyAr: 'التواصل الفعال هو مفتاح النجاح في تربية الأطفال المشتركة. إليك بعض النصائح لمساعدتك في التعامل مع محادثات شريكك.',
      bodyFr: 'Une communication efficace est la clé d\'une coparentalité réussie. Voici quelques conseils pour vous aider à naviguer dans les conversations avec votre coparent.',
      imageUrl: 'https://picsum.photos/400/200?random=30',
      date: '2026-04-10',
      source: 'Family Wellness',
    ),
    NewsItem(
      id: '2',
      title: 'Managing Shared Expenses Effectively',
      titleAr: 'إدارة المصاريف المشتركة بفعالية',
      titleFr: 'Gérer efficacement les dépenses partagées',
      body: 'Learn how to track and split expenses fairly between co-parents, from medical bills to extracurricular activities.',
      bodyAr: 'تعلم كيفية تتبع وتقسيم المصاريف بعدالة بين الوالدين، من الفواتير الطبية إلى الأنشطة اللامنهجية.',
      bodyFr: 'Apprenez à suivre et à répartir équitablement les dépenses entre coparents, des factures médicales aux activités parascolaires.',
      imageUrl: 'https://picsum.photos/400/200?random=31',
      date: '2026-04-08',
      source: 'Finance Today',
    ),
    NewsItem(
      id: '3',
      title: 'Children and Schedule Transitions',
      titleAr: 'الأطفال والانتقالات في الجدول',
      titleFr: 'Les enfants et les transitions d\'horaire',
      body: 'How to help your children adjust smoothly when transitioning between two homes and different schedules.',
      bodyAr: 'كيف تساعد أطفالك على التكيف بسلاسة عند الانتقال بين منزلين وجداول مختلفة.',
      bodyFr: 'Comment aider vos enfants à s\'adapter en douceur lors de la transition entre deux foyers et différents horaires.',
      imageUrl: 'https://picsum.photos/400/200?random=32',
      date: '2026-04-05',
      source: 'Parenting Guide',
    ),
  ];
}
