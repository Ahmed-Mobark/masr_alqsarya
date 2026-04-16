import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';
import 'package:masr_al_qsariya/core/widgets/app_text_field.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/login_view.dart';
import 'package:masr_al_qsariya/features/auth/presentation/view/verification_view.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _agreeTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    'Sign Up',
                    style: AppTextStyles.heading2(),
                  ),
                ),
                const SizedBox(height: 24),

                // First Name
                AppTextField(
                  label: 'First Name',
                  hint: 'John',
                  controller: _firstNameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                // Last Name
                AppTextField(
                  label: 'Last Name',
                  hint: 'Doe',
                  controller: _lastNameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 16),

                // Email
                AppTextField(
                  label: 'Email',
                  hint: 'example@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                // Phone
                AppTextField(
                  label: 'Phone Number',
                  hint: '+20 123 456 7890',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),

                // Password
                AppTextField(
                  label: 'Password',
                  hint: '********',
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
                const SizedBox(height: 16),

                // Confirm Password
                AppTextField(
                  label: 'Confirm Password',
                  hint: '********',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.greyText,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Terms & Conditions checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeTerms,
                        onChanged: (v) =>
                            setState(() => _agreeTerms = v ?? false),
                        activeColor: AppColors.primaryDark,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(color: AppColors.border),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Please agree to the Terms & Conditions to continue.',
                        style: AppTextStyles.tiny(color: AppColors.captionText),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // SIGN UP button
                _buildGoldButton(
                  text: 'SIGN UP',
                  onPressed: () {
                    sl<AppNavigator>().push(screen: const VerificationView());
                  },
                ),
                const SizedBox(height: 24),

                // Divider with "Or continue with"
                _buildDividerWithText('Or continue with'),
                const SizedBox(height: 20),

                // Social login buttons
                _buildSocialRow(),
                const SizedBox(height: 28),

                // Already have an account? LOGIN
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: AppTextStyles.tiny(color: AppColors.captionText),
                      children: [
                        TextSpan(
                          text: 'LOGIN',
                          style: AppTextStyles.tiny(color: AppColors.primaryDark)
                              .copyWith(fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              sl<AppNavigator>().pushReplacement(
                                screen: const LoginView(),
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
        _buildSocialCircle(
          color: AppColors.google,
          icon: Icons.g_mobiledata_rounded,
          onTap: () {},
        ),
        const SizedBox(width: 20),
        _buildSocialCircle(
          color: AppColors.apple,
          icon: Icons.apple,
          onTap: () {},
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
