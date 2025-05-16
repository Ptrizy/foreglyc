import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:google_fonts/google_fonts.dart';

enum FontWeightOption { regular, semiBold, bold }

extension FontWeightOptionExtension on FontWeightOption {
  FontWeight get weight {
    switch (this) {
      case FontWeightOption.regular:
        return FontWeight.w400;
      case FontWeightOption.semiBold:
        return FontWeight.w600;
      case FontWeightOption.bold:
        return FontWeight.w700;
    }
  }
}

class TextStyles {
  static TextStyle _getStyle(
    double fontSize,
    FontWeightOption weightOption, {
    Color color = ColorStyles.black,
    double? customFontSize,
  }) {
    return GoogleFonts.workSans(
      fontSize: (customFontSize ?? fontSize).sp,
      fontWeight: weightOption.weight,
      color: color,
    );
  }

  static TextStyle heading1({
    FontWeightOption weight = FontWeightOption.bold,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(32, weight, color: color, customFontSize: fontSize);

  static TextStyle heading2({
    FontWeightOption weight = FontWeightOption.bold,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(24, weight, color: color, customFontSize: fontSize);

  static TextStyle heading3({
    FontWeightOption weight = FontWeightOption.bold,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(20, weight, color: color, customFontSize: fontSize);

  static TextStyle heading4({
    FontWeightOption weight = FontWeightOption.bold,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(18, weight, color: color, customFontSize: fontSize);

  static TextStyle body1({
    FontWeightOption weight = FontWeightOption.regular,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(16, weight, color: color, customFontSize: fontSize);

  static TextStyle body2({
    FontWeightOption weight = FontWeightOption.regular,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(14, weight, color: color, customFontSize: fontSize);

  static TextStyle body3({
    FontWeightOption weight = FontWeightOption.regular,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(12, weight, color: color, customFontSize: fontSize);

  static TextStyle button1({
    FontWeightOption weight = FontWeightOption.semiBold,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(16, weight, color: color, customFontSize: fontSize);

  static TextStyle button2({
    FontWeightOption weight = FontWeightOption.semiBold,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(14, weight, color: color, customFontSize: fontSize);

  static TextStyle caption({
    FontWeightOption weight = FontWeightOption.regular,
    Color color = ColorStyles.black,
    double? fontSize,
  }) => _getStyle(12, weight, color: color, customFontSize: fontSize);
}
