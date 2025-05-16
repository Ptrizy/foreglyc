import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';

enum CustomTextFieldType {
  inputPassword,
  inputAndHint,
  input,
  inputSearch,
  inputPasswordAndHint,
  inputAndIcon,
  inputWithIconAndHint,
  inputAndSuffix,
  inputWithSuffixAndHint,
}

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final CustomTextFieldType type;
  final String hintText;
  final bool obscure;
  final TextInputType keyboardType;
  final Color? backgroundColor;
  final double? width;
  final String? suffixText;
  final String? suffixIcon;
  final String openedEyeIcon;
  final String closedEyeIcon;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.type,
    required this.hintText,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.backgroundColor,
    this.width,
    this.suffixText,
    this.suffixIcon,
    this.closedEyeIcon = 'assets/icons/eye-line-slash.svg',
    this.openedEyeIcon = 'assets/icons/eye-line.svg',
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscure = true;
  Color textColor = const Color(0xFF000000);
  bool isFocused = false;

  @override
  void initState() {
    super.initState();
    isObscure = widget.obscure;
    widget.controller.addListener(_updateTextfieldWhenFilled);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateTextfieldWhenFilled);
    super.dispose();
  }

  void _updateTextfieldWhenFilled() {
    setState(() {
      textColor =
          widget.controller.text.isEmpty
              ? ColorStyles.neutral600
              : ColorStyles.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color bgColor = widget.backgroundColor ?? Colors.transparent;
    double widths = widget.width ?? double.infinity;
    return Container(
      height: 48.h,
      width: widths,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            isFocused = hasFocus;
          });
        },
        child: TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscure && isObscure,
          decoration: _getDecoration(),
          style: TextStyles.body1(
            weight: FontWeightOption.regular,
            color: Color(0xFF71717A),
          ),
        ),
      ),
    );
  }

  InputDecoration _getDecoration() {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: ColorStyles.neutral300, width: 1.w),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.r),
      borderSide: BorderSide(color: ColorStyles.primary500, width: 1.w),
    );

    final padding = EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h);

    final hintStyle = TextStyles.body2(
      color: ColorStyles.neutral600,
      weight: FontWeightOption.regular,
    );

    final labelStyle = TextStyles.body2(
      color: isFocused ? ColorStyles.primary500 : ColorStyles.neutral600,
      weight: FontWeightOption.regular,
    );

    final suffixIcon =
        widget.obscure
            ? InkWell(
              onTap: () {
                setState(() {
                  isObscure = !isObscure;
                });
              },
              child: UnconstrainedBox(
                child: SvgPicture.asset(
                  isObscure ? widget.closedEyeIcon : widget.openedEyeIcon,
                ),
              ),
            )
            : (widget.suffixIcon != null
                ? InkWell(
                  onTap: () {},
                  child: UnconstrainedBox(
                    child: SvgPicture.asset(widget.suffixIcon!),
                  ),
                )
                : null);

    Widget? suffixTextWidget =
        widget.suffixText != null
            ? Text(
              widget.suffixText!,
              style: TextStyles.body1(
                color: ColorStyles.neutral300,
                weight: FontWeightOption.regular,
              ),
            )
            : null;

    switch (widget.type) {
      case CustomTextFieldType.inputPassword:
        return InputDecoration(
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputAndHint:
        return InputDecoration(
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.input:
        return InputDecoration(
          focusColor: ColorStyles.primary500,
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputSearch:
        return InputDecoration(
          hintText: widget.hintText,
          hintStyle: hintStyle,
          prefixIcon: UnconstrainedBox(
            child: SvgPicture.asset('assets/icons/search.svg'),
          ),
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputPasswordAndHint:
        return InputDecoration(
          fillColor: ColorStyles.primary500,
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputAndIcon:
        return InputDecoration(
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputWithIconAndHint:
        return InputDecoration(
          labelText: widget.hintText,
          hintText: widget.hintText,
          labelStyle: labelStyle,
          hintStyle: hintStyle,
          suffixIcon: suffixIcon,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputAndSuffix:
        return InputDecoration(
          labelText: widget.hintText,
          labelStyle: labelStyle,
          suffix: suffixTextWidget,
          suffixStyle: TextStyles.body1(
            color: ColorStyles.neutral300,
            weight: FontWeightOption.regular,
          ),
          hintText: widget.hintText,
          hintStyle: hintStyle,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
      case CustomTextFieldType.inputWithSuffixAndHint:
        return InputDecoration(
          labelText: widget.hintText,
          labelStyle: labelStyle,
          suffix: suffixTextWidget,
          suffixStyle: TextStyles.body1(
            color: ColorStyles.neutral300,
            weight: FontWeightOption.regular,
          ),
          hintText: widget.hintText,
          hintStyle: hintStyle,
          border: border,
          focusedBorder: focusedBorder,
          contentPadding: padding,
        );
    }
  }
}
