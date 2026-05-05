import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_cubit.dart';
import 'package:masr_al_qsariya/features/sessions/presentation/cubit/session_library_filters.dart';

Widget _pillDropdown(Widget child) {
  return Material(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12.r),
    child: Padding(
      padding: EdgeInsetsDirectional.fromSTEB(12.w, 0, 8.w, 0),
      child: DropdownButtonHideUnderline(child: child),
    ),
  );
}

/// Bottom sheet aligned with `GET session-library` query params.
void showSessionsLibraryFilterSheet(BuildContext context) {
  final cubit = context.read<SessionLibraryCubit>();
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: AppColors.scaffoldBg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (sheetContext) => BlocProvider.value(
      value: cubit,
      child: const _SessionsLibraryFilterSheetBody(),
    ),
  );
}

class _SessionsLibraryFilterSheetBody extends StatefulWidget {
  const _SessionsLibraryFilterSheetBody();

  @override
  State<_SessionsLibraryFilterSheetBody> createState() =>
      _SessionsLibraryFilterSheetBodyState();
}

class _SessionsLibraryFilterSheetBodyState
    extends State<_SessionsLibraryFilterSheetBody> {
  static const _perPageChoices = [10, 15, 20, 25, 30];

  late SessionLibraryFilters _draft;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<SessionLibraryCubit>();
    var f = cubit.state.filters;
    if (f.sortDirection != 'asc' && f.sortDirection != 'desc') {
      f = SessionLibraryFilters(
        expertPersonaId: f.expertPersonaId,
        sortDirection: 'desc',
        perPage: f.perPage,
      );
    }
    if (!_perPageChoices.contains(f.perPage)) {
      f = SessionLibraryFilters(
        expertPersonaId: f.expertPersonaId,
        sortDirection: f.sortDirection,
        perPage: 15,
      );
    }
    if (f.expertPersonaId != null &&
        !cubit.state.expertFilterChoices.containsKey(f.expertPersonaId!)) {
      f = SessionLibraryFilters(
        expertPersonaId: null,
        sortDirection: f.sortDirection,
        perPage: f.perPage,
      );
    }
    _draft = f;
  }

  void _setDraft(SessionLibraryFilters next) {
    setState(() => _draft = next);
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final experts = context.watch<SessionLibraryCubit>().state.expertFilterChoices;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          20.w,
          12.h,
          20.w,
          16.h + bottomInset,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.greyText.withValues(alpha: 0.35),
                borderRadius: BorderRadius.circular(999.r),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            tr.sessionsLibraryFilterSheetTitle,
            style: AppTextStyles.heading2(color: AppColors.darkText).copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            tr.sessionsLibraryFilterSortLabel,
            style: AppTextStyles.smallMedium(color: AppColors.darkText)
                .copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          SegmentedButton<String>(
            segments: [
              ButtonSegment<String>(
                value: 'desc',
                label: Text(tr.sessionsLibraryFilterSortDesc),
              ),
              ButtonSegment<String>(
                value: 'asc',
                label: Text(tr.sessionsLibraryFilterSortAsc),
              ),
            ],
            selected: {_draft.sortDirection},
            onSelectionChanged: (next) {
              if (next.isEmpty) return;
              _setDraft(
                SessionLibraryFilters(
                  expertPersonaId: _draft.expertPersonaId,
                  sortDirection: next.first,
                  perPage: _draft.perPage,
                ),
              );
            },
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.darkText;
                }
                return AppColors.greyText;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary;
                }
                return AppColors.white;
              }),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            tr.sessionsLibraryFilterExpertLabel,
            style: AppTextStyles.smallMedium(color: AppColors.darkText)
                .copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          _pillDropdown(
            DropdownButton<int?>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(12.r),
              value: _draft.expertPersonaId,
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text(tr.sessionsLibraryFilterExpertAll),
                ),
                ...experts.entries.map(
                  (e) => DropdownMenuItem<int?>(
                    value: e.key,
                    child: Text(e.value, overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
              onChanged: (v) => _setDraft(
                SessionLibraryFilters(
                  expertPersonaId: v,
                  sortDirection: _draft.sortDirection,
                  perPage: _draft.perPage,
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            tr.sessionsLibraryFilterPerPageLabel,
            style: AppTextStyles.smallMedium(color: AppColors.darkText)
                .copyWith(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 8.h),
          _pillDropdown(
            DropdownButton<int>(
              isExpanded: true,
              borderRadius: BorderRadius.circular(12.r),
              value: _perPageChoices.contains(_draft.perPage)
                  ? _draft.perPage
                  : 15,
              items: _perPageChoices
                  .map(
                    (n) => DropdownMenuItem<int>(
                      value: n,
                      child: Text('$n'),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v == null) return;
                _setDraft(
                  SessionLibraryFilters(
                    expertPersonaId: _draft.expertPersonaId,
                    sortDirection: _draft.sortDirection,
                    perPage: v,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 28.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.read<SessionLibraryCubit>().resetFilterSheet();
                    Navigator.of(context).pop();
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkText,
                    side: BorderSide(color: AppColors.greyText.withValues(alpha: 0.4)),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(tr.sessionsLibraryFilterReset),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    context.read<SessionLibraryCubit>().applyFilterSheet(
                          filters: _draft,
                        );
                    Navigator.of(context).pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.darkText,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(tr.sessionsLibraryFilterApply),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }
}
