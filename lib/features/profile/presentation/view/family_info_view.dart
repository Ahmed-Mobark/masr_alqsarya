import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/core/utils/validator.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/get_workspace_usecase.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/manage_family_invitation_usecase.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_field.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_phone_number_field.dart';
import 'package:masr_al_qsariya/features/family_workspace/domain/entities/family_workspace_member.dart';
import 'package:masr_al_qsariya/features/family_workspace/presentation/cubit/family_workspace_members_cubit.dart';
import 'package:masr_al_qsariya/features/profile/presentation/view/invite_professional_view.dart';

class FamilyInfoView extends StatelessWidget {
  const FamilyInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthCubit>()),
        BlocProvider(create: (_) => sl<FamilyWorkspaceMembersCubit>()),
      ],
      child: const _FamilyInfoBody(),
    );
  }
}

class _FamilyInfoBody extends StatefulWidget {
  const _FamilyInfoBody();

  @override
  State<_FamilyInfoBody> createState() => _FamilyInfoBodyState();
}

class _FamilyInfoBodyState extends State<_FamilyInfoBody> {
  String _workspaceStatusKey = 'pending';
  bool _lawyerInviteBusy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  Future<void> _bootstrap() async {
    final wid = sl<WorkspaceIdStorage>().get();
    if (!mounted) return;
    if (wid != null) {
      context.read<FamilyWorkspaceMembersCubit>().load(
        workspaceId: wid,
        role: null,
      );
    }

    final ws = await sl<GetWorkspaceUseCase>()();
    if (!mounted) return;
    ws.fold((_) {}, (w) {
      final raw =
          w.data?['status']?.toString() ??
          w.data?['workspace_status']?.toString() ??
          'pending';
      setState(() => _workspaceStatusKey = raw.trim().toLowerCase());
    });
  }

  Future<void> _reloadMembers() async {
    final wid = sl<WorkspaceIdStorage>().get();
    if (wid != null && mounted) {
      await context.read<FamilyWorkspaceMembersCubit>().load(
        workspaceId: wid,
        role: null,
      );
    }
  }

  String _statusDisplayText() {
    final tr = context.tr;
    switch (_workspaceStatusKey) {
      case 'active':
        return tr.familyInfoStatusActive;
      case 'approved':
        return tr.familyInfoStatusApproved;
      default:
        return tr.familyInfoStatusPending;
    }
  }

  List<FamilyWorkspaceMemberEntity> _owners(
    List<FamilyWorkspaceMemberEntity> items,
  ) {
    final list = items.where((e) => e.isOwnerRole).toList()
      ..sort((a, b) {
        final c = a.fullName.compareTo(b.fullName);
        if (c != 0) return c;
        return a.id.compareTo(b.id);
      });
    return list;
  }

  List<FamilyWorkspaceMemberEntity> _coPartners(
    List<FamilyWorkspaceMemberEntity> items,
  ) {
    final list = items.where((e) => e.isCoPartnerRole).toList()
      ..sort((a, b) {
        final c = a.fullName.compareTo(b.fullName);
        if (c != 0) return c;
        return a.id.compareTo(b.id);
      });
    return list;
  }

  List<FamilyWorkspaceMemberEntity> _children(
    List<FamilyWorkspaceMemberEntity> items,
  ) {
    final list = items.where((e) => e.isChild).toList()
      ..sort((a, b) {
        final c = a.fullName.compareTo(b.fullName);
        if (c != 0) return c;
        return a.id.compareTo(b.id);
      });
    return list;
  }

  List<FamilyWorkspaceMemberEntity> _professionals(
    List<FamilyWorkspaceMemberEntity> items,
  ) {
    final list = items.where((e) => e.isProfessionalRole).toList()
      ..sort((a, b) {
        final c = a.fullName.compareTo(b.fullName);
        if (c != 0) return c;
        return a.id.compareTo(b.id);
      });
    return list;
  }

  String _val(BuildContext context, String? v) {
    final s = v?.trim();
    if (s == null || s.isEmpty) return context.tr.familyInfoEmptyValue;
    return s;
  }

  String _formatBirthForDisplay(BuildContext context, String? raw) {
    final s = raw?.trim();
    if (s == null || s.isEmpty) return context.tr.familyInfoEmptyValue;
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMd(locale).format(dt.toLocal());
    }
    return s;
  }

  String _invitationStatusLabel(BuildContext context, String? raw) {
    final tr = context.tr;
    switch ((raw ?? '').toLowerCase()) {
      case 'pending':
      case 'sent':
      case 'invited':
      case 'waiting':
        return tr.familyInfoInvitationPending;
      case 'accepted':
        return tr.familyInfoInvitationAccepted;
      case 'cancelled':
      case 'canceled':
        return tr.familyInfoInvitationCancelled;
      case 'expired':
        return tr.familyInfoInvitationExpired;
      case 'declined':
      case 'rejected':
        return tr.familyInfoInvitationDeclined;
      default:
        final t = raw?.trim();
        if (t == null || t.isEmpty) return tr.familyInfoEmptyValue;
        return t;
    }
  }

  void _openInviteProfessionalScreen() {
    sl<AppNavigator>().push(
      screen: InviteProfessionalView(
        onSuccess: () {
          if (mounted) _reloadMembers();
        },
      ),
    );
  }

  Future<void> _resendLawyerInvite(FamilyWorkspaceMemberEntity lawyer) async {
    final id = lawyer.invitationId;
    final email = lawyer.email?.trim() ?? '';
    if (id == null || email.isEmpty) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.familyInfoLawyerEmailMissing,
      );
      return;
    }
    if (sl<WorkspaceIdStorage>().get() == null) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.familyInfoNoWorkspace,
      );
      return;
    }
    setState(() => _lawyerInviteBusy = true);
    final result = await sl<ResendFamilyInvitationUseCase>()(
      ResendFamilyInvitationParams(invitationId: id, email: email),
    );
    if (!mounted) return;
    setState(() => _lawyerInviteBusy = false);
    await result.fold<Future<void>>(
      (f) async =>
          appToast(context: context, type: ToastType.error, message: f.message),
      (_) async {
        await appToast(
          context: context,
          type: ToastType.success,
          message: context.tr.familyInfoResendInvitationSuccess,
        );
        await _reloadMembers();
      },
    );
  }

  Future<void> _cancelLawyerInvite(FamilyWorkspaceMemberEntity lawyer) async {
    final id = lawyer.invitationId;
    final email = lawyer.email?.trim() ?? '';
    if (id == null || email.isEmpty) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.familyInfoLawyerEmailMissing,
      );
      return;
    }
    if (sl<WorkspaceIdStorage>().get() == null) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.familyInfoNoWorkspace,
      );
      return;
    }
    setState(() => _lawyerInviteBusy = true);
    final result = await sl<CancelFamilyInvitationUseCase>()(
      CancelFamilyInvitationParams(invitationId: id, email: email),
    );
    if (!mounted) return;
    setState(() => _lawyerInviteBusy = false);
    await result.fold<Future<void>>(
      (f) async =>
          appToast(context: context, type: ToastType.error, message: f.message),
      (_) async {
        await appToast(
          context: context,
          type: ToastType.success,
          message: context.tr.familyInfoCancelInvitationSuccess,
        );
        await _reloadMembers();
      },
    );
  }

  Widget _buildProfessionalsSection(
    BuildContext context,
    List<FamilyWorkspaceMemberEntity> professionals,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        _buildSectionHeader(
          context,
          title: context.tr.familyInfoSectionProfessional,
        ),
        SizedBox(height: 14.h),
        if (professionals.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < professionals.length; i++) ...[
                if (i > 0) ...[
                  SizedBox(height: 16.h),
                  Divider(
                    height: 1,
                    color: AppColors.border.withValues(alpha: 0.65),
                  ),
                  SizedBox(height: 12.h),
                ],
                _buildSingleProfessionalBlock(context, professionals[i]),
              ],
            ],
          ),
        SizedBox(height: professionals.isNotEmpty ? 16.h : 0),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _lawyerInviteBusy ? null : _openInviteProfessionalScreen,
            icon: Icon(
              Icons.person_add_alt_1_outlined,
              size: 20.sp,
              color: AppColors.primaryDark,
            ),
            label: Text(
              context.tr.familyInfoAddSomeoneFamilySpace,
              style: AppTextStyles.bodyMedium(color: AppColors.primaryDark),
              textAlign: TextAlign.center,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryDark,
              side: const BorderSide(color: AppColors.primaryDark),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSingleProfessionalBlock(
    BuildContext context,
    FamilyWorkspaceMemberEntity member,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        if (member.canManageLawyerInvitation) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _lawyerInviteBusy
                      ? null
                      : () => _resendLawyerInvite(member),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    side: const BorderSide(color: AppColors.primaryDark),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(context.tr.familyInfoResendInvitation),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: _lawyerInviteBusy
                      ? null
                      : () => _cancelLawyerInvite(member),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(
                      color: AppColors.error.withValues(alpha: 0.55),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(context.tr.familyInfoCancelInvitation),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
        _buildMemberRows(context, member),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final wid = sl<WorkspaceIdStorage>().get();

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (p, c) => p.action != c.action,
          listener: (context, state) {
            if (state.submitError != null && state.submitError!.isNotEmpty) {
              appToast(
                context: context,
                type: ToastType.error,
                message: state.submitError!,
              );
              context.read<AuthCubit>().clearSubmitError();
            }
            if (state.action == AuthAction.childAdded) {
              appToast(
                context: context,
                type: ToastType.success,
                message: context.tr.familyChildAddedSuccess,
              );
              context.read<AuthCubit>().clearAction();
              _reloadMembers();
            }
          },
        ),
        BlocListener<FamilyWorkspaceMembersCubit, FamilyWorkspaceMembersState>(
          listenWhen: (p, c) =>
              p.failure != c.failure &&
              c.failure != null &&
              c.status == FamilyWorkspaceMembersStatus.failure,
          listener: (context, state) {
            final msg = state.failure?.message;
            if (msg != null && msg.isNotEmpty) {
              appToast(context: context, type: ToastType.error, message: msg);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            context.tr.familyInfoTitle,
            style: AppTextStyles.heading2(color: AppColors.darkText),
          ),
          centerTitle: true,
        ),
        body: wid == null
            ? Center(
                child: Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 24.w),
                  child: Text(
                    context.tr.familyInfoNoWorkspace,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.body(color: AppColors.greyText),
                  ),
                ),
              )
            : BlocBuilder<
                FamilyWorkspaceMembersCubit,
                FamilyWorkspaceMembersState
              >(
                builder: (context, mState) {
                  if (mState.status == FamilyWorkspaceMembersStatus.loading &&
                      mState.items.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryDark,
                      ),
                    );
                  }

                  if (mState.status == FamilyWorkspaceMembersStatus.failure &&
                      mState.items.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            mState.failure?.message ??
                                context.tr.familyInfoRetry,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.body(
                              color: AppColors.greyText,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          TextButton(
                            onPressed: _reloadMembers,
                            child: Text(context.tr.familyInfoRetry),
                          ),
                        ],
                      ),
                    );
                  }

                  final items = mState.items;
                  final owners = _owners(items);
                  final coPartners = _coPartners(items);
                  final children = _children(items);
                  final professionals = _professionals(items);

                  return RefreshIndicator(
                    color: AppColors.primaryDark,
                    onRefresh: _reloadMembers,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsetsDirectional.fromSTEB(
                        20.w,
                        8.h,
                        20.w,
                        32.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildStatusRow(context),
                          SizedBox(height: 20.h),
                          const Divider(height: 1, color: AppColors.border),
                          SizedBox(height: 20.h),
                          if (owners.isNotEmpty) ...[
                            _buildSectionHeader(
                              context,
                              title: context.tr.familyInfoSectionOwner,
                            ),
                            _buildMemberRowsList(context, owners),
                            SizedBox(height: 16.h),
                            const Divider(height: 1, color: AppColors.border),
                            SizedBox(height: 16.h),
                          ],
                          if (coPartners.isNotEmpty) ...[
                            _buildSectionHeader(
                              context,
                              title: context.tr.familyInfoSectionCoParent,
                            ),
                            _buildMemberRowsList(context, coPartners),
                            SizedBox(height: 16.h),
                            const Divider(height: 1, color: AppColors.border),
                            SizedBox(height: 16.h),
                          ],
                          _buildSectionHeader(
                            context,
                            title: context.tr.familyInfoSectionChild,
                          ),
                          _buildMemberRowsList(context, children),
                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => _showAddChildSheet(
                                context,
                                context.read<AuthCubit>(),
                              ),
                              icon: Icon(
                                Icons.add,
                                size: 20.sp,
                                color: AppColors.primaryDark,
                              ),
                              label: Text(
                                context.tr.familyAddChild,
                                style: AppTextStyles.bodyMedium(
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primaryDark,
                                side: const BorderSide(
                                  color: AppColors.primaryDark,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          const Divider(height: 1, color: AppColors.border),
                          _buildProfessionalsSection(context, professionals),
                          if (mState.status ==
                                  FamilyWorkspaceMembersStatus.loading &&
                              mState.items.isNotEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 16.h),
                              child: const Center(
                                child: SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context) {
    final active = _workspaceStatusKey == 'active';
    final approved = _workspaceStatusKey == 'approved';
    final accent = active || approved ? AppColors.success : AppColors.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          context.tr.familyInfoStatusLabel,
          style: AppTextStyles.body(color: AppColors.greyText),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              active
                  ? Icons.check_circle_outline_rounded
                  : Icons.hourglass_empty_rounded,
              size: 18.sp,
              color: accent,
            ),
            SizedBox(width: 6.w),
            Text(
              _statusDisplayText(),
              style: AppTextStyles.bodyMedium(color: accent),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, {required String title}) {
    return Text(
      title,
      style: AppTextStyles.heading2(
        color: AppColors.darkText,
      ).copyWith(fontSize: 17.sp),
    );
  }

  Widget _buildMemberRowsList(
    BuildContext context,
    List<FamilyWorkspaceMemberEntity> members,
  ) {
    if (members.isEmpty) {
      return _buildMemberRows(context, null);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < members.length; i++) ...[
          if (i > 0) ...[
            SizedBox(height: 16.h),
            Divider(height: 1, color: AppColors.border.withValues(alpha: 0.65)),
            SizedBox(height: 12.h),
          ],
          _buildMemberRows(context, members[i]),
        ],
      ],
    );
  }

  Widget _buildMemberRows(
    BuildContext context,
    FamilyWorkspaceMemberEntity? m,
  ) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        _infoRow(
          context,
          label: context.tr.familyInfoFieldName,
          value: _val(context, m?.fullName),
        ),
        SizedBox(height: 12.h),
        _infoRow(
          context,
          label: context.tr.familyInfoFieldEmail,
          value: _val(context, m?.email),
        ),
        SizedBox(height: 12.h),
        _infoRow(
          context,
          label: context.tr.familyInfoFieldPhone,
          value: _val(context, m?.phone),
        ),
        SizedBox(height: 12.h),
        _infoRow(
          context,
          label: context.tr.familyInfoFieldBirthDate,
          value: _formatBirthForDisplay(context, m?.birthDate),
        ),
        if (m != null) ...[
          _memberStatusRow(context, m),
        ],
      ],
    );
  }

  /// Workspace `status` (preferred) or nested invitation status for display.
  Widget _memberStatusRow(BuildContext context, FamilyWorkspaceMemberEntity m) {
    final raw = m.memberStatus?.trim().isNotEmpty == true
        ? m.memberStatus
        : m.invitationStatus;
    if (raw == null || raw.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        SizedBox(height: 12.h),
        _infoRow(
          context,
          label: context.tr.familyInfoMemberStatusLabel,
          value: _invitationStatusLabel(context, raw),
        ),
      ],
    );
  }

  Widget _infoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: AppTextStyles.body(color: AppColors.darkText),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          flex: 3,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: AppTextStyles.body(color: AppColors.greyText),
          ),
        ),
      ],
    );
  }

  void _showAddChildSheet(BuildContext context, AuthCubit cubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: cubit,
          child: BlocConsumer<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.action != current.action ||
                previous.submitError != current.submitError,
            listener: (ctx, st) {
              if (st.submitError != null && st.submitError!.isNotEmpty) {
                appToast(
                  context: ctx,
                  type: ToastType.error,
                  message: st.submitError!,
                );
                cubit.clearSubmitError();
              }
              if (st.action == AuthAction.childAdded) {
                cubit.clearAction();
                Navigator.pop(ctx);
              }
            },
            builder: (ctx, st) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Form(
                    key: cubit.addChildFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          context.tr.familyAddChild,
                          style: AppTextStyles.heading2(),
                        ),
                        SizedBox(height: 20.h),
                        _buildField(
                          label: context.tr.familyChildDisplayNameLabel,
                          hint: context.tr.familyChildDisplayNameHint,
                          controller: cubit.childDisplayNameController,
                          validator: (v) => Validator.defaultValidator(v),
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildFirstNameLabel,
                          hint: context.tr.familyChildFirstNameHint,
                          controller: cubit.childFirstNameController,
                          validator: (v) => cubit.validateName(v),
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildLastNameLabel,
                          hint: context.tr.familyChildLastNameHint,
                          controller: cubit.childLastNameController,
                          validator: (v) => cubit.validateName(v),
                        ),
                        SizedBox(height: 14.h),
                        _buildField(
                          label: context.tr.familyChildEmailLabel,
                          hint: context.tr.familyChildEmailHint,
                          controller: cubit.childEmailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) => cubit.validateEmail(v),
                        ),
                        SizedBox(height: 14.h),
                        BlocBuilder<AuthCubit, AuthState>(
                          buildWhen: (p, c) =>
                              p.childDialCode != c.childDialCode,
                          builder: (ctx, st) {
                            return AuthField(
                              label: context.tr.familyChildPhoneLabel,
                              child: AuthPhoneNumberField(
                                controller: cubit.childPhoneController,
                                hint: context.tr.familyChildPhoneHint,
                                validator: (v) => cubit.validatePhone(v),
                                selectedDialCode: st.childDialCode,
                                onDialCodeChanged: cubit.setChildDialCode,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 14.h),
                        _buildDateField(
                          context: ctx,
                          label: context.tr.familyChildDateOfBirthLabel,
                          hint: context.tr.familyChildDateOfBirthHint,
                          controller: cubit.childDateOfBirthController,
                          validator: (v) => Validator.dateOfBirth(v),
                        ),
                        SizedBox(height: 24.h),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: st.isSubmitting
                                ? null
                                : cubit.submitAddChild,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: AppColors.darkText,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: st.isSubmitting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.darkText,
                                    ),
                                  )
                                : Text(
                                    context.tr.commonAdd,
                                    style: AppTextStyles.button(
                                      color: AppColors.darkText,
                                    ),
                                  ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildField({
    required String label,
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption(color: AppColors.darkText)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.body(),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.body(color: AppColors.greyText),
            filled: true,
            fillColor: AppColors.inputBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required String label,
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.caption(color: AppColors.darkText)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () async {
            final now = DateTime.now();
            final picked = await showDatePicker(
              context: context,
              initialDate: now.subtract(const Duration(days: 365 * 5)),
              firstDate: DateTime(1900),
              lastDate: now,
            );
            if (picked != null) {
              controller.text =
                  '${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}';
            }
          },
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: validator,
              style: AppTextStyles.body(),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: AppTextStyles.body(color: AppColors.greyText),
                filled: true,
                fillColor: AppColors.inputBg,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: AppColors.primaryDark,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
