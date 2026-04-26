import 'package:masr_al_qsariya/features/expense/domain/entities/regular_expense.dart';

class RegularExpenseModel {
  final int id;
  final int? childWorkspaceMemberId;
  final String? childName;
  final String payerId;
  final String payerName;
  final String payeeId;
  final String payeeName;
  final String currency;
  final double amount;
  final String title;
  final int categoryId;
  final String? categoryName;
  final String date;
  final String? note;
  final bool isPaid;
  final String? referenceNumber;
  final String? receiptUrl;
  final String? createdAt;
  final String? attachmentUrl;
  final String? attachmentName;

  const RegularExpenseModel({
    required this.id,
    required this.childWorkspaceMemberId,
    required this.childName,
    required this.payerId,
    required this.payerName,
    required this.payeeId,
    required this.payeeName,
    required this.currency,
    required this.amount,
    required this.title,
    required this.categoryId,
    required this.categoryName,
    required this.date,
    required this.note,
    required this.isPaid,
    required this.referenceNumber,
    required this.receiptUrl,
    required this.createdAt,
    required this.attachmentUrl,
    required this.attachmentName,
  });

  factory RegularExpenseModel.fromJson(Map<String, dynamic> json) {
    final rawAmount = json['amount'];
    final parsedAmount = rawAmount is num
        ? rawAmount.toDouble()
        : double.tryParse('$rawAmount') ??
            0.0;

    final rawIsPaid = json['is_paid'];
    final isPaid = rawIsPaid is bool
        ? rawIsPaid
        : (rawIsPaid is num ? rawIsPaid == 1 : ('$rawIsPaid' == '1'));

    return RegularExpenseModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      childWorkspaceMemberId: (json['child_workspace_member_id'] as num?)?.toInt(),
      childName: (json['child'] is Map<String, dynamic>)
          ? (json['child']['display_name'] ?? '').toString()
          : json['child_name']?.toString(),
      payerId: (json['payer_id'] ?? '').toString(),
      payerName: (json['payer_name'] ?? '').toString(),
      payeeId: (json['payee_id'] ?? '').toString(),
      payeeName: (json['payee_name'] ?? '').toString(),
      currency: (json['currency'] ?? '').toString(),
      amount: parsedAmount,
      title: (json['title'] ?? '').toString(),
      categoryId: (json['category_id'] as num?)?.toInt() ?? 0,
      categoryName: json['category_name']?.toString(),
      date: (json['date'] ?? '').toString(),
      note: json['note']?.toString(),
      isPaid: isPaid,
      referenceNumber: json['reference_number']?.toString(),
      receiptUrl: json['receipt_url']?.toString(),
      createdAt: json['created_at']?.toString(),
      attachmentUrl: json['attachment_url']?.toString() ?? json['attachment']?.toString(),
      attachmentName: json['attachment_name']?.toString(),
    );
  }

  RegularExpenseEntity toEntity() => RegularExpenseEntity(
        id: id,
        childWorkspaceMemberId: childWorkspaceMemberId,
        childName: childName,
        payerId: payerId,
        payerName: payerName,
        payeeId: payeeId,
        payeeName: payeeName,
        currency: currency,
        amount: amount,
        title: title,
        categoryId: categoryId,
        categoryName: categoryName,
        date: date,
        note: note,
        isPaid: isPaid,
        referenceNumber: referenceNumber,
        receiptUrl: receiptUrl,
        createdAt: createdAt,
        attachmentUrl: attachmentUrl,
        attachmentName: attachmentName,
      );
}

