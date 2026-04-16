import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/config/app_colors.dart';
import 'package:masr_al_qsariya/core/config/styles/styles.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/widgets/app_text_field.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/sign_up_view.dart';
import 'package:masr_al_qsariya/features/home/presentation/view/home_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  int _selectedTab = 0; // 0 = Email, 1 = Phone Number

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColorLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back arrow
                _buildBackArrow(context),
                const SizedBox(height: 24),

                // Title
                Center(
                  child: Text(
                    context.tr.authLoginTitle,
                    style: AppTextStyles.heading2(),
                  ),
                ),
                const SizedBox(height: 24),

                // Tab selector: Email / Phone Number
                _buildTabSelector(),
                const SizedBox(height: 20),

                // Email or Phone field
                if (_selectedTab == 0)
                  AppTextField(
                    label: context.tr.authEmailLabel,
                    hint: context.tr.authEmailHint,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  )
                else
                  AppTextField(
                    label: context.tr.authPhoneLabel,
                    hint: context.tr.authPhoneHint,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),
                const SizedBox(height: 16),

                // Password field
                AppTextField(
                  label: context.tr.authPasswordLabel,
                  hint: context.tr.authPasswordHint,
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.greyText,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot Password?
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navigate to forgot password
                    },
                    child: Text(
                      context.tr.authForgotPassword,
                      style: AppTextStyles.caption(color: AppColors.primaryDark),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // LOG IN button
                _buildGoldButton(
                  text: context.tr.authLoginButton,
                  onPressed: () {
                    sl<AppNavigator>().pushAndRemoveUntil(
                      screen: const HomeView(),
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Divider with "Or continue with"
                _buildDividerWithText(context.tr.authOrContinueWith),
                const SizedBox(height: 20),

                // Social login buttons
                _buildSocialRow(),
                const SizedBox(height: 28),

                // Don't have an account? Sign Up
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: context.tr.authDontHaveAccountPrefix,
                      style: AppTextStyles.tiny(color: AppColors.captionText),
                      children: [
                        TextSpan(
                          text: context.tr.authSignUp,
                          style: AppTextStyles.tiny(color: AppColors.primaryDark)
                              .copyWith(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              sl<AppNavigator>().push(
                                screen: const SignUpView(),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      width: 343,
      height: 45,
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab(context.tr.authEmailTab, 0),
          _buildTab(context.tr.authPhoneTab, 1),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTextStyles.bodyMedium(
              color: isSelected ? AppColors.darkText : AppColors.greyText,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoldButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 343,
      height: 44,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          text,
          style: AppTextStyles.button(color: AppColors.darkText),
        ),
      ),
    );
  }

  Widget _buildDividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: AppTextStyles.caption(color: AppColors.greyText),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google
        _buildSocialCircle(
          color: AppColors.google,
          icon: Icons.g_mobiledata_rounded,
          onTap: () {
            // TODO: Google sign in
          },
        ),
        const SizedBox(width: 20),
        // Apple
        _buildSocialCircle(
          color: AppColors.apple,
          icon: Icons.apple,
          onTap: () {
            // TODO: Apple sign in
          },
        ),
      ],
    );
  }

  Widget _buildSocialCircle({
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, color: AppColors.white, size: 24),
      ),
    );
  }
}

Widget _buildBackArrow(BuildContext context) {
  return GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 16,
        color: AppColors.primaryDark,
      ),
    ),
  );
}
