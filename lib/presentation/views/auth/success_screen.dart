import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/color.dart';

class SuccessScreen extends StatelessWidget {
  final Widget column;
  const SuccessScreen({super.key, required this.column});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: ColorStyles.gradient1),
        child: Padding(
          padding: EdgeInsets.only(top: 216.h, left: 24.w, right: 24.w),
          child: Column(
            children: [
              UnconstrainedBox(child: SvgPicture.asset('assets/success.svg')),
              SizedBox(height: 48.h),
              column,
            ],
          ),
        ),
      ),
    );
  }
}
