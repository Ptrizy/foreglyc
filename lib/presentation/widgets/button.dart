import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';

class Buttons extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;
  final Color? bColor;
  final Color? tColor;
  final int? width;
  final int? height;
  final bool? isButtonSmall;

  const Buttons({
    super.key,
    required this.text,
    required this.onClicked,
    this.bColor,
    this.tColor,
    this.width,
    this.height,
    this.isButtonSmall,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = bColor ?? ColorStyles.primary500;
    Color textColor = tColor ?? ColorStyles.white;
    int widths = width ?? 345;
    int heights = height ?? 48;
    bool isSmall = isButtonSmall ?? false;

    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
          ),
          minimumSize: WidgetStateProperty.all<Size>(Size(widths.w, heights.h)),
        ),
        onPressed: onClicked,
        child: Text(
          text,
          style:
              isSmall
                  ? TextStyles.button2(
                    weight: FontWeightOption.semiBold,
                    color: textColor,
                  )
                  : TextStyles.button1(
                    weight: FontWeightOption.semiBold,
                    color: textColor,
                  ),
        ),
      ),
    );
  }
}
