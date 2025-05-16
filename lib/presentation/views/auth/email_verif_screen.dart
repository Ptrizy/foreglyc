import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/blocs/auth/auth_bloc.dart';
import 'package:foreglyc/presentation/widgets/button.dart';
import 'package:foreglyc/presentation/widgets/loading.dart';
import 'package:foreglyc/presentation/widgets/otp.dart';
import 'package:go_router/go_router.dart';

class EmailVerifScreen extends StatefulWidget {
  final String email;
  const EmailVerifScreen({super.key, required this.email});

  @override
  State<EmailVerifScreen> createState() => _EmailVerifScreenState();
}

class _EmailVerifScreenState extends State<EmailVerifScreen> {
  String _otp = '';
  bool _isOtpComplete = false;

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

  void _updateOtp(String newOtp) {
    setState(() {
      _otp = newOtp;
      _isOtpComplete = newOtp.length == 4;
    });
    debugPrint('OTP NYA ADALAH: $_otp');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Loading();
            },
          );
        } else if (state is AuthError) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is AuthVerified) {
          Navigator.pop(context);
          context.go(
            RoutePath.successPage,
            extra: const SuccessEmailVerifContent(),
          );
        }
      },
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 66.h, left: 16.w, right: 16.w),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.go(RoutePath.signupPage),
                    child: UnconstrainedBox(
                      child: SvgPicture.asset('assets/icons/arrow-left.svg'),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 218.15.h,
                  child: SvgPicture.asset('assets/email_verif.svg'),
                ),
                SizedBox(height: 48.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email Verification',
                    style: TextStyles.heading2(),
                  ),
                ),
                SizedBox(height: 4.h),
                RichText(
                  text: TextSpan(
                    text:
                        'Enter the verification code that we sent to the email ',
                    style: TextStyles.body2(
                      weight: FontWeightOption.regular,
                      color: ColorStyles.neutral600,
                    ),
                    children: [
                      TextSpan(
                        text: _getObfuscatedEmail(),
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
                        context.read<AuthBloc>().add(VerifyUser(code: _otp));
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
                        text: 'Didn\'t receive the code? ',
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
      ),
    );
  }
}

class SuccessEmailVerifContent extends StatelessWidget {
  const SuccessEmailVerifContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Verification Successful',
          style: TextStyles.heading2(color: ColorStyles.white),
        ),
        SizedBox(height: 4.h),
        Text(
          'Congratulations, your email has been successfully validated.',
          style: TextStyles.body2(
            color: ColorStyles.white,
            weight: FontWeightOption.regular,
          ),
        ),
        SizedBox(height: 48.h),
        Buttons(
          text: 'Sign In',
          onClicked: () {
            context.go(RoutePath.loginPage);
          },
          bColor: ColorStyles.white,
          tColor: ColorStyles.primary500,
        ),
      ],
    );
  }
}
