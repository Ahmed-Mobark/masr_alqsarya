import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:masr_al_qsariya/core/extensions/localization.dart';
import 'package:masr_al_qsariya/core/injection/injection_container.dart';
import 'package:masr_al_qsariya/core/navigation/app_navigator.dart';
import 'package:masr_al_qsariya/core/theme/app_colors.dart';
import 'package:masr_al_qsariya/core/theme/app_text_styles.dart';

class PrivacySecurityStaticView extends StatelessWidget {
  const PrivacySecurityStaticView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
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
          context.tr.profileMenuPrivacySecurity,
          style: AppTextStyles.heading2(
            color: AppColors.darkText,
          ).copyWith(fontSize: 16.sp, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 24.h),
          child: Text(
            context.tr.profileTermsBody,
            style: AppTextStyles.body(
              color: AppColors.bodyText,
            ).copyWith(fontSize: 14.sp, height: 1.6),
          ),
        ),
      ),
    );
  }
}
