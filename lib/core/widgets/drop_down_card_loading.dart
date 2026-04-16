import 'package:masr_al_qsariya/core/widgets/app_shimmer.dart';
import 'package:masr_al_qsariya/core/widgets/shimmer_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoadingCardForDropDowns extends StatelessWidget {
  const LoadingCardForDropDowns({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(child: ShimmerShape(width: double.infinity, height: 50.h, radius: 15.r));
  }
}
