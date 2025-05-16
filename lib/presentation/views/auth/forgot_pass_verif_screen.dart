import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/widgets/button.dart';
import 'package:foreglyc/presentation/widgets/otp.dart';
import 'package:go_router/go_router.dart';

class ForgotPassVerifScreen extends StatefulWidget {
  final String email;

  const ForgotPassVerifScreen({super.key, required this.email});

  @override
  State<ForgotPassVerifScreen> createState() => _ForgotPassVerifScreenState();
}

class _ForgotPassVerifScreenState extends State<ForgotPassVerifScreen> {
  String _otp = '';
  bool _isOtpComplete = false;

  void _updateOtp(String newOtp) {
    setState(() {
      _otp = newOtp;
      _isOtpComplete = newOtp.length == 4;
    });
    debugPrint('OTP NYA ADALAH: $_otp');
  }

  String _getObfuscatedEmail() {
    final emailParts = widget.email.split('@');
    if (emailParts.length != 2) return widget.email;

    final username = emailParts[0];
    final domain = emailParts[1];

    if (username.length <= 2) return widget.email;

    final firstChar = username[0];
    final lastChar = username[username.length - 1];
    final stars = '*' * (username.length - 2);

    return '$firstChar$stars$lastChar@$domain';
  }

  @override
  Widget build(BuildContext context) {
    final obfuscatedEmail = _getObfuscatedEmail();

    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 66.h, left: 16.w, right: 16.w),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => context.go(RoutePath.forgotPassPage),
                  child: UnconstrainedBox(
                    child: SvgPicture.asset('assets/icons/arrow-left.svg'),
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 328.h,
                child: SvgPicture.asset('assets/otp-forgot-pass.svg'),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Enter the OTP code', style: TextStyles.heading2()),
              ),
              SizedBox(height: 4.h),
              RichText(
                text: TextSpan(
                  text: 'Enter the OTP code that we sent to the email ',
                  style: TextStyles.body2(
                    weight: FontWeightOption.regular,
                    color: ColorStyles.neutral600,
                  ),
                  children: [
                    TextSpan(
                      text: obfuscatedEmail,
                      style: TextStyles.body2(
                        color: ColorStyles.neutral700,
                        weight: FontWeightOption.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Otp(length: 4, onCompleted: _updateOtp),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Buttons(
                  text: 'Verification',
                  onClicked: () {
                    if (_isOtpComplete) {
                      context.go(RoutePath.newPassPage);
                      debugPrint('Verifikasi OTP: $_otp');
                    }
                  },
                  bColor:
                      _isOtpComplete
                          ? ColorStyles.primary500
                          : ColorStyles.neutral400,
                ),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't receive the code? ",
                      style: TextStyles.body2(
                        weight: FontWeightOption.regular,
                        color: ColorStyles.neutral600,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend Code',
                          style: TextStyles.body2(
                            color: ColorStyles.primary500,
                            weight: FontWeightOption.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
