import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:masr_al_qsariya/core/toast/app_toast.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/pending_invitation_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/role_options_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/widgets/auth_back_button.dart';
import 'package:masr_al_qsariya/features/nav_bar/presentation/view/main_nav_view.dart';

class VerificationView extends StatefulWidget {
  const VerificationView({super.key, this.email});

  final String? email;

  @override
  State<VerificationView> createState() => _VerificationViewState();
}

class _VerificationViewState extends State<VerificationView> {
  static const int _codeLength = 6;

  final List<TextEditingController> _controllers = List.generate(
    _codeLength,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    _codeLength,
    (_) => FocusNode(),
  );

  int _secondsRemaining = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    if (widget.email != null && widget.email!.trim().isNotEmpty) {
      context.read<AuthCubit>().setRegisteredEmail(widget.email!.trim());
    }
    _startTimer();
  }

  void _startTimer() {
    _secondsRemaining = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  String get _otpCode => _controllers.map((c) => c.text).join();

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name.substring(0, 2)}${'*' * (name.length - 2)}@$domain';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) =>
          previous.action != current.action ||
          previous.submitError != current.submitError ||
          previous.resendSuccess != current.resendSuccess,
      listener: (context, state) {
          if (state.submitError != null && state.submitError!.isNotEmpty) {
            appToast(
              context: context,
              type: ToastType.error,
              message: state.submitError!,
            );
            context.read<AuthCubit>().clearSubmitError();
          }

          if (state.resendSuccess) {
            _startTimer();
            appToast(
              context: context,
              type: ToastType.success,
              message: context.tr.authVerificationCodeSent,
            );
          }

          if (state.action == AuthAction.navigateToRoleOptions) {
            sl<AppNavigator>().pushAndRemoveUntil(
              screen: BlocProvider(
                create: (_) => sl<AuthCubit>(),
                child: const RoleOptionsView(),
              ),
            );
            context.read<AuthCubit>().clearAction();
          }

          if (state.action == AuthAction.navigateToPendingInvitation) {
            final pending = state.pendingInvitation;
            if (pending == null) return;
            sl<AppNavigator>().pushAndRemoveUntil(
              screen: PendingInvitationView(pendingInvitation: pending),
            );
            context.read<AuthCubit>().clearAction();
          }

          if (state.action == AuthAction.navigateToHome) {
            sl<AppNavigator>().pushAndRemoveUntil(screen: const MainNavView());
            context.read<AuthCubit>().clearAction();
          }
      },
      builder: (context, state) {
        final cubit = context.read<AuthCubit>();
          final maskedEmail = state.registeredEmail != null
              ? _maskEmail(state.registeredEmail!)
              : '';

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              AuthBackButton(
                                onTap: () => Navigator.pop(context),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    context.tr.authVerifyTitle,
                                    style: AppTextStyles.heading2(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 36),
                            ],
                          ),
                          const SizedBox(height: 32),
                          Text(
                            context.tr.authVerifyCodeHeading,
                            style: AppTextStyles.heading2(),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              style: AppTextStyles.caption(
                                color: AppColors.greyText,
                              ),
                              children: [
                                TextSpan(text: context.tr.authVerifySubtitle),
                                if (maskedEmail.isNotEmpty) ...[
                                  const TextSpan(text: ' '),
                                  TextSpan(
                                    text: maskedEmail,
                                    style: AppTextStyles.caption(
                                      color: AppColors.primaryDark,
                                    ).copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(_codeLength, (index) {
                                return SizedBox(
                                  width: 48,
                                  height: 52,
                                  child: TextFormField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    maxLength: 1,
                                    style: AppTextStyles.heading2(),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                      counterText: '',
                                      filled: true,
                                      fillColor: AppColors.inputBg,
                                      contentPadding: EdgeInsets.zero,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.border,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(
                                          color: AppColors.primary,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty &&
                                          index < _codeLength - 1) {
                                        _focusNodes[index + 1].requestFocus();
                                      } else if (value.isEmpty && index > 0) {
                                        _focusNodes[index - 1].requestFocus();
                                      }
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _secondsRemaining > 0
                              ? Row(
                                  children: [
                                    Text(
                                      context.tr.authDidntReceive,
                                      style: AppTextStyles.caption(
                                        color: AppColors.greyText,
                                      ),
                                    ),
                                    Text(
                                      '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                                      style: AppTextStyles.caption(
                                        color: AppColors.primaryDark,
                                      ).copyWith(fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: state.isResending
                                      ? null
                                      : cubit.resendVerificationCode,
                                  child: state.isResending
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : RichText(
                                          text: TextSpan(
                                            text: context.tr.authDidntReceive,
                                            style: AppTextStyles.caption(
                                              color: AppColors.greyText,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: context.tr.authResend,
                                                style:
                                                    AppTextStyles.caption(
                                                      color:
                                                          AppColors.primaryDark,
                                                    ).copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting
                            ? null
                            : () {
                                final code = _otpCode;
                                if (code.length == _codeLength) {
                                  cubit.verifyEmail(code);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.darkText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.darkText,
                                ),
                              )
                            : Text(
                                context.tr.authContinue.toUpperCase(),
                                style: AppTextStyles.button(
                                  color: AppColors.darkText,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          sl<AppNavigator>().pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkText,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: Text(context.tr.back),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
      },
    );
  }
}
