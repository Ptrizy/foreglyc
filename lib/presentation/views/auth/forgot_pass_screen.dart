import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/widgets/button.dart';
import 'package:foreglyc/presentation/widgets/text_fields.dart';
import 'package:go_router/go_router.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  TextEditingController emailController = TextEditingController();
  bool isButtonEnabled = false;
  String? emailError;

  @override
  void initState() {
    emailController.addListener(_checkFields);
    super.initState();
  }

  @override
  void dispose() {
    emailController.removeListener(_checkFields);

    emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return email.length >= 5 && email.contains('@');
  }

  void _checkFields() {
    setState(() {
      isButtonEnabled = emailController.text.isNotEmpty;
    });
  }

  void _validateAndSubmit() {
    final email = emailController.text.trim();

    if (!_isValidEmail(email)) {
      setState(() {
        emailError = 'Email must be at least 5 characters and contain @';
      });
      return;
    }
    setState(() {
      emailError = null;
    });

    context.go('${RoutePath.forgotPassVerifPage}?email=$email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 66.h, left: 16.w, right: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => context.go(RoutePath.loginPage),
                child: UnconstrainedBox(
                  child: SvgPicture.asset('assets/icons/arrow-left.svg'),
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                height: 328.h,
                width: double.infinity,
                child: SvgPicture.asset('assets/forgot-pass.svg'),
              ),
              SizedBox(height: 16.h),
              Text('Forgot Password?', style: TextStyles.heading2()),
              SizedBox(height: 4.h),
              Text(
                'Enter the email address you used when you joined and we’ll send you OTP code',
                style: TextStyles.body2(
                  weight: FontWeightOption.regular,
                  color: Color(0xFF71717A),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: CustomTextField(
                  controller: emailController,
                  type: CustomTextFieldType.input,
                  hintText: 'Email Address',
                ),
              ),
              Buttons(
                text: 'Send',
                onClicked: isButtonEnabled ? _validateAndSubmit : () {},
                bColor:
                    isButtonEnabled
                        ? ColorStyles.primary500
                        : ColorStyles.neutral300,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
