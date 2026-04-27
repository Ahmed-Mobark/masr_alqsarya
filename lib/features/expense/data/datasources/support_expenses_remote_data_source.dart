import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/features/expense/data/models/support_expense_model.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_support_expense_usecase.dart';

abstract class SupportExpensesRemoteDataSource {
  Future<List<SupportExpenseModel>> getSupportExpenses({
    required int workspaceId,
  });

  Future<SupportExpenseModel> getSupportExpenseDetails({
    required int workspaceId,
    required int expenseId,
  });

  Future<SupportExpenseModel> addSupportExpense({
    required int workspaceId,
    required AddSupportExpenseParams params,
  });
}

class SupportExpensesRemoteDataSourceImpl
    implements SupportExpensesRemoteDataSource {
  const SupportExpensesRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  @override
  Future<List<SupportExpenseModel>> getSupportExpenses({
    required int workspaceId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceSupportExpenses(workspaceId),
    );

    final data = response['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(SupportExpenseModel.fromJson)
        .toList();
  }

  @override
  Future<SupportExpenseModel> getSupportExpenseDetails({
    required int workspaceId,
    required int expenseId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceSupportExpenseDetails(workspaceId, expenseId),
    );
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid support expense details response');
    }
    return SupportExpenseModel.fromJson(data);
  }

  @override
  Future<SupportExpenseModel> addSupportExpense({
    required int workspaceId,
    required AddSupportExpenseParams params,
  }) async {
    final form = FormData.fromMap({
      'payer_id': params.payerId,
      'payer_name': params.payerName,
      'payee_id': params.payeeId,
      'payee_name': params.payeeName,
      'currency': params.currency,
      'amount': params.amount,
      'title': params.title,
      if (params.categoryId != null) 'category_id': params.categoryId.toString(),
      'date': params.date,
      'note': params.note,
      'is_paid': params.isPaid ? '1' : '0',
      if (params.attachment != null) 'attachment': params.attachment,
    });

    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceSupportExpenses(workspaceId),
      formData: form,
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      return const SupportExpenseModel(
        id: 0,
        childWorkspaceMemberId: null,
        childName: null,
        payerId: '',
        payerName: '',
        payeeId: '',
        payeeName: '',
        currency: '',
        amount: 0,
        title: '',
        categoryId: 0,
        categoryName: null,
        date: '',
        note: null,
        isPaid: false,
        referenceNumber: null,
        receiptUrl: null,
        createdAt: null,
        attachmentUrl: null,
        attachmentName: null,
      );
    }

    return SupportExpenseModel.fromJson(data);
  }
}

