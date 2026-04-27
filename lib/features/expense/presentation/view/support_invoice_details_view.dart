import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/expense/presentation/cubit/support_expense_details_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportInvoiceDetailsView extends StatelessWidget {
  final int workspaceId;
  final int expenseId;

  const SupportInvoiceDetailsView({
    super.key,
    required this.workspaceId,
    required this.expenseId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupportExpenseDetailsCubit>()
        ..load(workspaceId: workspaceId, expenseId: expenseId),
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
            onPressed: () => sl<AppNavigator>().pop(),
          ),
          title: Text(
            context.tr.invoiceTitle,
            style: AppTextStyles.heading2().copyWith(fontSize: 18.sp),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 20.w),
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primary, width: 1.w),
                ),
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.document_text,
                  size: 18.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<SupportExpenseDetailsCubit, SupportExpenseDetailsState>(
          builder: (context, state) {
            if (state.status == SupportExpenseDetailsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == SupportExpenseDetailsStatus.failure) {
              return Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 20.w),
                  child: Text(
                    state.failure?.message ?? context.tr.commonError,
                    style: AppTextStyles.bodyMedium(color: AppColors.greyText),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final expense = state.item;
            if (expense == null) return const SizedBox.shrink();

            final subtitle =
                '${expense.title} - ${context.tr.expenseSubmittedBy}: ${expense.payerName} - ${context.tr.expenseSubmittedTo}: ${expense.payeeName}';
            final currency = currencyDisplay(
              locale: Localizations.localeOf(context),
              currencyCode: expense.currency,
            );
            final hasNote = (expense.note ?? '').trim().isNotEmpty;

            return SingleChildScrollView(
              padding: EdgeInsetsDirectional.only(
                start: 20.w,
                end: 20.w,
                bottom: 24.h,
              ),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    '$currency ${expense.amount.toStringAsFixed(2)}',
                    style: AppTextStyles.heading1(color: AppColors.darkText)
                        .copyWith(fontSize: 26.sp),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption(color: AppColors.greyText)
                        .copyWith(fontSize: 12.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    '${context.tr.invoiceNumberPrefix}${expense.referenceNumber ?? expense.id}',
                    style: AppTextStyles.caption(color: AppColors.captionText)
                        .copyWith(fontSize: 11.sp),
                  ),
                  SizedBox(height: 18.h),
                  _SectionCard(
                    title: context.tr.invoiceExpenseInformation,
                    child: Column(
                      children: [
                        _LabeledValueRow(
                          label: context.tr.invoiceCategory,
                          value: expense.categoryName ??
                              expense.categoryId.toString(),
                        ),
                        SizedBox(height: 14.h),
                        _LabeledValueRow(
                          label: context.tr.invoiceDateOfService,
                          value: expense.date,
                        ),
                        if (hasNote) ...[
                          SizedBox(height: 16.h),
                          Divider(height: 1.h, color: AppColors.border),
                          SizedBox(height: 14.h),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              context.tr.invoiceDescription,
                              style: AppTextStyles.bodyMedium().copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkText,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Text(
                              expense.note!,
                              style:
                                  AppTextStyles.caption(color: AppColors.greyText)
                                      .copyWith(fontSize: 12.sp, height: 1.35),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _SectionCard(
                    title: context.tr.invoicePaymentDetails,
                    backgroundColor: AppColors.purpleColorLight,
                    borderColor: AppColors.transparent,
                    child: Column(
                      children: [
                        _LabeledValueRow(
                          label: context.tr.invoiceReferenceNumber,
                          value:
                              expense.referenceNumber ?? expense.id.toString(),
                        ),
                        SizedBox(height: 12.h),
                        _LabeledValueRow(
                          label: context.tr.invoicePaidOn,
                          value: expense.date,
                        ),
                        SizedBox(height: 12.h),
                        _LabeledValueRow(
                          label: context.tr.invoicePaymentMethod,
                          value: '-',
                        ),
                        SizedBox(height: 12.h),
                        _LabeledValueRow(
                          label: context.tr.invoiceVerifiedBy,
                          value: '-',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _SectionCard(
                    title: context.tr.invoiceAttachments,
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 14.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.inputBg,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Iconsax.document,
                              size: 18.sp,
                              color: AppColors.greyText,
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: InkWell(
                                onTap: (expense.receiptUrl == null ||
                                        expense.receiptUrl!.isEmpty)
                                    ? null
                                    : () async {
                                        final uri =
                                            Uri.tryParse(expense.receiptUrl!);
                                        if (uri == null) return;
                                        await launchUrl(
                                          uri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      },
                                child: Text(
                                  expense.receiptUrl == null ||
                                          expense.receiptUrl!.isEmpty
                                      ? '-'
                                      : (expense.attachmentName ??
                                          uriLastSegment(expense.receiptUrl!)),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium(
                                    color: AppColors.greyText,
                                  ).copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    decoration: (expense.receiptUrl == null ||
                                            expense.receiptUrl!.isEmpty)
                                        ? null
                                        : TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

String uriLastSegment(String url) {
  final uri = Uri.tryParse(url);
  if (uri == null) return url;
  final seg = uri.pathSegments;
  if (seg.isEmpty) return url;
  return seg.last;
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;

  const _SectionCard({
    required this.title,
    required this.child,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(18.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.background,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: borderColor ?? AppColors.border, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium().copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.darkText,
            ),
          ),
          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }
}

class _LabeledValueRow extends StatelessWidget {
  final String label;
  final String value;

  const _LabeledValueRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption(color: AppColors.greyText)
                .copyWith(fontSize: 12.sp),
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          value,
          style: AppTextStyles.bodyMedium().copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.darkText,
          ),
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}

String currencyDisplay({required Locale locale, required String currencyCode}) {
  final code = currencyCode.toUpperCase().trim();
  final isArabic = locale.languageCode == 'ar';

  if (isArabic) {
    switch (code) {
      case 'EGP':
        return 'ج.م';
    }
  }

  return code;
}

