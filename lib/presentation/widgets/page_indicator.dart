import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int length;

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          width: currentIndex == index ? 24.w : 16.w,
          height: 8.h,
          decoration: BoxDecoration(
            color:
                currentIndex == index
                    ? ColorStyles.primary500
                    : ColorStyles.neutral300,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
      ),
    );
  }
}
