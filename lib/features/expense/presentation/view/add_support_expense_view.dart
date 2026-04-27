import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/expense/domain/usecases/add_support_expense_usecase.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/add_support_expense_cubit.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_dashed_card.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_field_container.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_labeled_field.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_required_label.dart';
import 'package:masr_al_qsariya/features/expense/presentation/widgets/add_expense_segment_option.dart';

class AddSupportExpenseView extends StatefulWidget {
  const AddSupportExpenseView({super.key});

  @override
  State<AddSupportExpenseView> createState() => _AddSupportExpenseViewState();
}

class _AddSupportExpenseViewState extends State<AddSupportExpenseView> {
  final ImagePicker _imagePicker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  bool _alreadyPaid = true;

  final _payerNameController = TextEditingController();
  final _payerIdController = TextEditingController();
  final _payeeNameController = TextEditingController();
  final _payeeIdController = TextEditingController();
  final _currencyController = TextEditingController(text: 'EGP');
  final _amountController = TextEditingController();
  final _expenseTitleController = TextEditingController();
  final _notesController = TextEditingController();

  String? _proofFileName;
  String? _proofFilePath;

  String _failureMessage({required String fallback, dynamic failure}) {
    if (failure == null) return fallback;

    final errors = failure.errors;
    if (errors is Map && errors.isNotEmpty) {
      final msgs = <String>[];
      for (final v in errors.values) {
        if (v is List) {
          msgs.addAll(v.map((e) => e.toString()));
        } else if (v != null) {
          msgs.add(v.toString());
        }
      }
      final text = msgs.where((e) => e.trim().isNotEmpty).join('\n');
      if (text.isNotEmpty) return text;
    }

    final message = failure.message?.toString();
    return (message == null || message.trim().isEmpty) ? fallback : message;
  }

  String? _validateNationalIdLike(String? val) {
    final v = (val ?? '').trim();
    if (v.isEmpty) return context.tr.errorFieldRequired;
    final ok = RegExp(r'^\d{14}$').hasMatch(v);
    return ok ? null : context.tr.errorInvalidNationalId;
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryDark,
              onPrimary: AppColors.darkText,
              surface: AppColors.background,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickProofOfPurchase() async {
    try {
      final action = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
        ),
        builder: (context) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: 16.w,
                end: 16.w,
                top: 10.h,
                bottom: 14.h,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  SizedBox(height: 14.h),
                  ListTile(
                    contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: 6.w,
                    ),
                    minLeadingWidth: 24.w,
                    horizontalTitleGap: 14.w,
                    leading: Icon(Iconsax.gallery, color: AppColors.darkText),
                    title: Text(
                      context.tr.addExpensePickFromGallery,
                      style: AppTextStyles.bodyMedium(),
                    ),
                    onTap: () => Navigator.pop(context, 'gallery'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: 6.w,
                    ),
                    minLeadingWidth: 24.w,
                    horizontalTitleGap: 14.w,
                    leading: Icon(Iconsax.camera, color: AppColors.darkText),
                    title: Text(
                      context.tr.addExpenseTakePhoto,
                      style: AppTextStyles.bodyMedium(),
                    ),
                    onTap: () => Navigator.pop(context, 'camera'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsetsDirectional.symmetric(
                      horizontal: 6.w,
                    ),
                    minLeadingWidth: 24.w,
                    horizontalTitleGap: 14.w,
                    leading: Icon(Iconsax.document_upload, color: AppColors.darkText),
                    title: Text(
                      context.tr.addExpensePickFile,
                      style: AppTextStyles.bodyMedium(),
                    ),
                    onTap: () => Navigator.pop(context, 'file'),
                  ),
                ],
              ),
            ),
          );
        },
      );

      if (!mounted) return;
      if (action == null) return;

      const maxBytes = 5 * 1024 * 1024;
      final messenger = ScaffoldMessenger.of(context);
      final tooLargeText = context.tr.addExpenseProofTooLarge;

      if (action == 'gallery' || action == 'camera') {
        final XFile? file = await _imagePicker.pickImage(
          source: action == 'camera' ? ImageSource.camera : ImageSource.gallery,
          imageQuality: 90,
        );
        if (!mounted) return;
        if (file == null) return;

        final len = await file.length();
        if (len > maxBytes) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                tooLargeText,
                style: AppTextStyles.bodyMedium(color: AppColors.white),
              ),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }

        setState(() {
          _proofFileName = file.name;
          _proofFilePath = file.path;
        });
        return;
      }

      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
        withData: false,
      );
      if (!mounted) return;
      if (result == null || result.files.isEmpty) return;
      final picked = result.files.first;
      if (picked.size > maxBytes) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              tooLargeText,
              style: AppTextStyles.bodyMedium(color: AppColors.white),
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      setState(() {
        _proofFileName = picked.name;
        _proofFilePath = picked.path;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            context.tr.addExpenseProofPickFailed,
            style: AppTextStyles.bodyMedium(color: AppColors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _payerNameController.dispose();
    _payerIdController.dispose();
    _payeeNameController.dispose();
    _payeeIdController.dispose();
    _currencyController.dispose();
    _amountController.dispose();
    _expenseTitleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.caption(color: AppColors.captionText)
          .copyWith(fontSize: 12.sp),
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      isCollapsed: true,
      contentPadding: EdgeInsetsDirectional.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AddSupportExpenseCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.sp,
              color: AppColors.darkText,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.tr.addExpenseTitle,
            style: AppTextStyles.navTitle().copyWith(fontSize: 16.sp),
          ),
          centerTitle: true,
        ),
        body: BlocListener<AddSupportExpenseCubit, AddSupportExpenseState>(
          listener: (context, state) {
            if (state.status == AddSupportExpenseStatus.success) {
              Navigator.pop(context, true);
            }
            if (state.status == AddSupportExpenseStatus.failure) {
              final msg = _failureMessage(
                fallback: context.tr.commonError,
                failure: state.failure,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(msg, maxLines: 10),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 6),
                ),
              );
            }
          },
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.only(
              start: 20.w,
              end: 20.w,
              top: 14.h,
              bottom: 24.h,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AddExpenseLabeledField(
                          label: context.tr.addExpensePayerName,
                          controller: _payerNameController,
                          hint: context.tr.addExpenseFieldHint,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AddExpenseLabeledField(
                          label: context.tr.addExpensePayerId,
                          controller: _payerIdController,
                          hint: context.tr.addExpenseFieldHint,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(14),
                          ],
                          validator: _validateNationalIdLike,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14.h),
                  Row(
                    children: [
                      Expanded(
                        child: AddExpenseLabeledField(
                          label: context.tr.addExpensePayeeName,
                          controller: _payeeNameController,
                          hint: context.tr.addExpenseFieldHint,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AddExpenseLabeledField(
                          label: context.tr.addExpensePayeeId,
                          controller: _payeeIdController,
                          hint: context.tr.addExpenseFieldHint,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(14),
                          ],
                          validator: _validateNationalIdLike,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseCurrencyLabel),
                  SizedBox(height: 10.h),
                  AddExpenseFieldContainer(
                    child: TextFormField(
                      controller: _currencyController,
                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                      decoration: _inputDecoration(context.tr.addExpenseFieldHint),
                      validator: (val) => (val == null || val.isEmpty)
                          ? context.tr.addExpenseCurrencyRequired
                          : null,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseAmountLabel),
                  SizedBox(height: 10.h),
                  AddExpenseFieldContainer(
                    child: TextFormField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                      decoration: _inputDecoration('0.00'),
                      validator: (val) => (val == null || val.isEmpty)
                          ? context.tr.addExpenseAmountRequired
                          : null,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseExpenseTitleLabel),
                  SizedBox(height: 10.h),
                  AddExpenseFieldContainer(
                    child: TextFormField(
                      controller: _expenseTitleController,
                      textAlignVertical: TextAlignVertical.center,
                      style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                      decoration: _inputDecoration(context.tr.addExpenseFieldHint),
                      validator: (val) => (val == null || val.isEmpty)
                          ? context.tr.addExpenseTitleRequired
                          : null,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseDatePlaceholder),
                  SizedBox(height: 10.h),
                  InkWell(
                    onTap: _pickDate,
                    borderRadius: BorderRadius.circular(14.r),
                    child: AddExpenseFieldContainer(
                      child: Row(
                        children: [
                          Icon(Iconsax.calendar_1, size: 18.sp, color: AppColors.greyText),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? context.tr.addExpenseDatePlaceholder
                                  : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              style: AppTextStyles.bodyMedium().copyWith(
                                fontSize: 12.sp,
                                color: AppColors.greyText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseNotesOptional),
                  SizedBox(height: 10.h),
                  AddExpenseFieldContainer(
                    child: TextFormField(
                      controller: _notesController,
                      maxLines: 3,
                      style: AppTextStyles.bodyMedium().copyWith(fontSize: 12.sp),
                      decoration: _inputDecoration(context.tr.addExpenseNotesHint),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseAlreadyPaidQuestion),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: AddExpenseSegmentOption(
                          label: context.tr.addExpenseYesIPaidIt,
                          selected: _alreadyPaid,
                          onTap: () => setState(() => _alreadyPaid = true),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AddExpenseSegmentOption(
                          label: context.tr.addExpenseNotPaidYet,
                          selected: !_alreadyPaid,
                          onTap: () => setState(() => _alreadyPaid = false),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 18.h),
                  AddExpenseRequiredLabel(text: context.tr.addExpenseProofOfPurchaseLabel),
                  SizedBox(height: 12.h),
                  InkWell(
                    borderRadius: BorderRadius.circular(18.r),
                    onTap: _pickProofOfPurchase,
                    child: AddExpenseDashedCard(
                      child: Column(
                        children: [
                          Container(
                            width: 46.w,
                            height: 46.w,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Iconsax.cloud_add,
                              size: 22.sp,
                              color: AppColors.yellow,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            _proofFileName ?? context.tr.addExpenseUploadReceiptOrInvoice,
                            style: AppTextStyles.bodyMedium().copyWith(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.darkText,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 18.h),
                  BlocBuilder<AddSupportExpenseCubit, AddSupportExpenseState>(
                    builder: (context, state) {
                      final loading =
                          state.status == AddSupportExpenseStatus.loading;
                      return SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () async {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }

                                  final workspaceId =
                                      sl<WorkspaceIdStorage>().get();
                                  if (workspaceId == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Workspace not found'),
                                      ),
                                    );
                                    return;
                                  }

                                  final date = _selectedDate;
                                  final formattedDate = date == null
                                      ? DateFormat('yyyy-MM-dd')
                                          .format(DateTime.now())
                                      : DateFormat('yyyy-MM-dd').format(date);

                                  final attachment = (_proofFilePath != null)
                                      ? await MultipartFile.fromFile(
                                          _proofFilePath!,
                                          filename: _proofFileName,
                                        )
                                      : null;

                                  if (!context.mounted) return;

                                  final params = AddSupportExpenseParams(
                                    payerId: _payerIdController.text.trim(),
                                    payerName: _payerNameController.text.trim(),
                                    payeeId: _payeeIdController.text.trim(),
                                    payeeName: _payeeNameController.text.trim(),
                                    currency: _currencyController.text.trim(),
                                    amount: _amountController.text.trim(),
                                    title: _expenseTitleController.text.trim(),
                                    categoryId: null,
                                    date: formattedDate,
                                    note: _notesController.text.trim().isEmpty
                                        ? null
                                        : _notesController.text.trim(),
                                    isPaid: _alreadyPaid,
                                    attachment: attachment,
                                  );

                                  context.read<AddSupportExpenseCubit>().submit(
                                        workspaceId: workspaceId,
                                        params: params,
                                      );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.darkText,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999.r),
                            ),
                          ),
                          child: Text(
                            context.tr.addExpenseSubmitExpense.toUpperCase(),
                            style: AppTextStyles.button().copyWith(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

