import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/widgets/button.dart';
import 'package:foreglyc/presentation/widgets/text_fields.dart';
import 'package:go_router/go_router.dart';

class NewPassScreen extends StatefulWidget {
  const NewPassScreen({super.key});

  @override
  State<NewPassScreen> createState() => _NewPassScreenState();
}

class _NewPassScreenState extends State<NewPassScreen> {
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmationController =
      TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    passwordController.addListener(_checkFields);
    passwordConfirmationController.addListener(_checkFields);
    super.initState();
  }

  @override
  void dispose() {
    passwordController.removeListener(_checkFields);
    passwordConfirmationController.removeListener(_checkFields);

    passwordController.dispose();
    passwordConfirmationController.removeListener(_checkFields);
    super.dispose();
  }

  void _checkFields() {
    setState(() {
      isButtonEnabled =
          passwordController.text.isNotEmpty &&
          passwordConfirmationController.text.isNotEmpty;
    });
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
              UnconstrainedBox(
                child: SvgPicture.asset('assets/icons/caret-left.svg'),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 224.56.h,
                child: SvgPicture.asset('assets/illustrations/new-pass.svg'),
              ),
              SizedBox(height: 48.h),
              Text('Buat Kata Sandi Baru', style: TextStyles.heading2()),
              SizedBox(height: 4.h),
              Text(
                'Silahkan masukkan kata sandi baru Anda',
                style: TextStyles.body2(weight: FontWeightOption.regular),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: passwordController,
                      type: CustomTextFieldType.inputPasswordAndHint,
                      obscure: true,
                      hintText: 'Kata Sandi',
                    ),
                    SizedBox(height: 16.h),
                    CustomTextField(
                      controller: passwordConfirmationController,
                      type: CustomTextFieldType.inputPasswordAndHint,
                      obscure: true,
                      hintText: 'Konfirmasi Kata Sandi',
                    ),
                  ],
                ),
              ),
              Buttons(
                text: 'Simpan',
                onClicked:
                    isButtonEnabled
                        ? () {
                          context.go(
                            RoutePath.successPage,
                            extra: const SuccessChangeNewPassContent(),
                          );
                        }
                        : () {},
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

class SuccessChangeNewPassContent extends StatelessWidget {
  const SuccessChangeNewPassContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Password Changed Successfully',
          style: TextStyles.heading2(color: ColorStyles.white),
        ),
        SizedBox(height: 4.h),
        Text(
          'Your password has been changed. Please log in using your new password. ',
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
