import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/realtime/realtime_service.dart';
import 'package:masr_al_qsariya/core/storage/data/storage.dart';
import 'package:masr_al_qsariya/core/storage/workspace_id_storage.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/domain/usecases/delete_account_usecase.dart';
import 'package:masr_al_qsariya/features/onboarding/presentation/view/onboarding_view.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key, required this.scaffoldContext});

  /// Caller [BuildContext] (e.g. the screen) for toasts after this route pops.
  final BuildContext scaffoldContext;

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final _controller = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _clearLocalSession() async {
    await sl<Storage>().deleteToken();
    await sl<Storage>().deleteUser();
    await sl<Storage>().deleteSelectedRole();
    await sl<WorkspaceIdStorage>().delete();
    await sl<RealtimeService>().disconnect();
  }

  Future<void> _submit() async {
    final password = _controller.text.trim();
    if (password.isEmpty) {
      await appToast(
        context: context,
        type: ToastType.error,
        message: context.tr.errorFieldRequired,
      );
      return;
    }

    setState(() => _loading = true);
    final result = await sl<DeleteAccountUseCase>()(
      DeleteAccountParams(currentPassword: password),
    );
    if (!mounted) return;
    setState(() => _loading = false);

    await result.fold(
      (failure) async {
        await appToast(
          context: context,
          type: ToastType.error,
          message: failure.message,
        );
      },
      (_) async {
        Navigator.of(context).pop();
        await _clearLocalSession();
        final root = widget.scaffoldContext;
        if (root.mounted) {
          await appToast(
            context: root,
            type: ToastType.success,
            message: root.tr.accountSecurityAccountDeleted,
          );
        }
        sl<AppNavigator>().pushAndRemoveUntil(
          screen: const OnboardingView(initialPage: 3),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;
    // Explicit light-surface palette so text stays readable in dark app theme.
    const surface = AppColors.cardBg;
    const onSurface = AppColors.darkText;
    const secondary = AppColors.greyText;

    return PopScope(
      canPop: !_loading,
      child: AlertDialog(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          tr.accountSecurityDeleteAccount,
          style: AppTextStyles.heading2(color: onSurface).copyWith(fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.accountSecurityDeleteConfirm,
                style: AppTextStyles.body(color: secondary).copyWith(height: 1.45),
              ),
              const SizedBox(height: 16),
              Text(
                tr.accountSecurityDeletePasswordPrompt,
                style: AppTextStyles.body(color: onSurface),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _controller,
                obscureText: _obscure,
                enabled: !_loading,
                style: AppTextStyles.body(color: onSurface),
                cursorColor: AppColors.primaryDark,
                decoration: InputDecoration(
                  labelText: tr.accountSecurityCurrentPasswordLabel,
                  labelStyle: AppTextStyles.caption(color: secondary),
                  floatingLabelStyle:
                      AppTextStyles.caption(color: AppColors.primaryDark),
                  filled: true,
                  fillColor: AppColors.inputBg,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.primaryDark,
                      width: 1.5,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.border.withValues(alpha: 0.5),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off : Icons.visibility,
                      color: secondary,
                    ),
                    onPressed: _loading
                        ? null
                        : () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              if (_loading) ...[
                const SizedBox(height: 16),
                const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.primaryDark),
            onPressed: _loading ? null : () => Navigator.of(context).pop(),
            child: Text(tr.commonCancel, style: AppTextStyles.bodyMedium()),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            onPressed: _loading ? null : _submit,
            child: Text(
              tr.accountSecurityDeleteConfirmAction,
              style: AppTextStyles.bodyMedium(),
            ),
          ),
        ],
      ),
    );
  }
}
