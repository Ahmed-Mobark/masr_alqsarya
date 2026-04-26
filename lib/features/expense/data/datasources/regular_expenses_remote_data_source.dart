import 'package:dio/dio.dart';
import 'package:masr_al_qsariya/core/config/app_end_points.dart';
import 'package:masr_al_qsariya/core/network/network_service/api_basehelper.dart';
import 'package:masr_al_qsariya/features/expense/data/models/regular_expense_model.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_regular_expense_usecase.dart';

abstract class RegularExpensesRemoteDataSource {
  Future<List<RegularExpenseModel>> getRegularExpenses({
    required int workspaceId,
  });

  Future<RegularExpenseModel> getRegularExpenseDetails({
    required int workspaceId,
    required int expenseId,
  });

  Future<RegularExpenseModel> addRegularExpense({
    required int workspaceId,
    required AddRegularExpenseParams params,
  });
}

class RegularExpensesRemoteDataSourceImpl implements RegularExpensesRemoteDataSource {
  const RegularExpensesRemoteDataSourceImpl(this._api);
  final ApiBaseHelper _api;

  @override
  Future<List<RegularExpenseModel>> getRegularExpenses({
    required int workspaceId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceRegularExpenses(workspaceId),
    );

    final data = response['data'];
    if (data is! List) return const [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(RegularExpenseModel.fromJson)
        .toList();
  }

  @override
  Future<RegularExpenseModel> getRegularExpenseDetails({
    required int workspaceId,
    required int expenseId,
  }) async {
    final response = await _api.get<Map<String, dynamic>>(
      url: AppEndpoints.workspaceRegularExpenseDetails(workspaceId, expenseId),
    );
    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid expense details response');
    }
    return RegularExpenseModel.fromJson(data);
  }

  @override
  Future<RegularExpenseModel> addRegularExpense({
    required int workspaceId,
    required AddRegularExpenseParams params,
  }) async {
    final form = FormData.fromMap({
      'child_workspace_member_id': params.childWorkspaceMemberId.toString(),
      'payer_id': params.payerId,
      'payer_name': params.payerName,
      'payee_id': params.payeeId,
      'payee_name': params.payeeName,
      'currency': params.currency,
      'amount': params.amount,
      'title': params.title,
      'category_id': params.categoryId.toString(),
      'date': params.date,
      'note': params.note,
      'is_paid': params.isPaid ? '1' : '0',
      if (params.attachment != null) 'attachment': params.attachment,
    });

    final response = await _api.post<Map<String, dynamic>>(
      url: AppEndpoints.workspaceRegularExpenses(workspaceId),
      formData: form,
    );

    final data = response['data'];
    if (data is! Map<String, dynamic>) {
      // Some APIs return only success message; fallback to empty model.
      return const RegularExpenseModel(
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

    return RegularExpenseModel.fromJson(data);
  }
}

