import 'package:equatable/equatable.dart';

class SupportExpenseEntity extends Equatable {
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

  const SupportExpenseEntity({
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

  @override
  List<Object?> get props => [
        id,
        childWorkspaceMemberId,
        childName,
        payerId,
        payerName,
        payeeId,
        payeeName,
        currency,
        amount,
        title,
        categoryId,
        categoryName,
        date,
        note,
        isPaid,
        referenceNumber,
        receiptUrl,
        createdAt,
        attachmentUrl,
        attachmentName,
      ];
}

