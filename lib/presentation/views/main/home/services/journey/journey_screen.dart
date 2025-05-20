import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:go_router/go_router.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 32.h),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow-left.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Journey',
                      style: TextStyles.heading4(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Journey Overview',
                style: TextStyles.heading2(weight: FontWeightOption.bold),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Text(
                    'Latest Update',
                    style: TextStyles.body2(color: ColorStyles.neutral700),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    '16 May 2025',
                    style: TextStyles.body2(weight: FontWeightOption.semiBold),
                  ),
                  SizedBox(width: 8.w),
                  SvgPicture.asset(
                    'assets/icons/ArrowCounterClockwise.svg',
                    width: 16.w,
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              Text(
                'You have consistently followed the dietary plan. The nutritionist has reviewed your daily menu on the dietary page, and your blood sugar has decreased by 100 mg/dL, returning to the normal range.',
                style: TextStyles.body2(color: ColorStyles.neutral700),
              ),
              SizedBox(height: 32.h),

              Text(
                'Dietary Plan Recap',
                style: TextStyles.heading4(weight: FontWeightOption.semiBold),
              ),
              SizedBox(height: 16.h),

              _buildMonthItem(
                context,
                'April 2025',
                Icons.icecream_outlined,
                onTap: () => context.push(RoutePath.journeyDetailPage),
              ),
              SizedBox(height: 16.h),

              _buildMonthItem(context, 'March 2025', Icons.access_alarm),
              SizedBox(height: 16.h),

              _buildMonthItem(
                context,
                'February 2025',
                Icons.flutter_dash_outlined,
              ),
              SizedBox(height: 16.h),

              _buildMonthItem(context, 'January 2025', Icons.star_outline),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthItem(
    BuildContext context,
    String month,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorStyles.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF27272A).withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(8.w),
          child: Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: Color(0xFFD1E3FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: Color(0xFF0C3B80), size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  month,
                  style: TextStyles.body2(weight: FontWeightOption.semiBold),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: ColorStyles.primary500,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
