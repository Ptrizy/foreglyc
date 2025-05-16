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
import 'package:foreglyc/presentation/widgets/text_fields.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    nameController.addListener(_checkFields);
    emailController.addListener(_checkFields);
    passwordController.addListener(_checkFields);
    passwordConfirmationController.addListener(_checkFields);
    super.initState();
  }

  @override
  void dispose() {
    nameController.removeListener(_checkFields);
    emailController.removeListener(_checkFields);
    passwordController.removeListener(_checkFields);
    passwordConfirmationController.removeListener(_checkFields);

    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    passwordConfirmationController.dispose();
    super.dispose();
  }

  void _checkFields() {
    setState(() {
      isButtonEnabled =
          nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          passwordConfirmationController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = emailController.text.trim();
    return Scaffold(
      backgroundColor: ColorStyles.white,
      body: BlocListener<AuthBloc, AuthState>(
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
          } else if (state is AuthRegistered) {
            Navigator.pop(context);
            context.go('${RoutePath.emailVerifPage}?email=$email');
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 106.h, left: 16.h, right: 16.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    width: 284.w,
                    height: 64.h,
                    child: SvgPicture.asset('assets/foreglyc_logo_auth.svg'),
                  ),
                ),
                SizedBox(height: 64.h),
                Text('Create an account', style: TextStyles.heading2()),
                SizedBox(height: 4.h),
                Text(
                  'Register your account to access all in-app features',
                  style: TextStyles.body2(
                    weight: FontWeightOption.regular,
                    color: ColorStyles.neutral600,
                  ),
                ),
                SizedBox(height: 24.h),
                CustomTextField(
                  controller: nameController,
                  type: CustomTextFieldType.input,
                  hintText: 'Full Name',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: emailController,
                  type: CustomTextFieldType.input,
                  hintText: 'Email Address',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: passwordController,
                  type: CustomTextFieldType.inputPasswordAndHint,
                  obscure: true,
                  hintText: 'Password',
                ),
                SizedBox(height: 16.h),
                CustomTextField(
                  controller: passwordConfirmationController,
                  type: CustomTextFieldType.inputPasswordAndHint,
                  obscure: true,
                  hintText: 'Confirm Password',
                ),
                SizedBox(height: 16.h),
                RichText(
                  text: TextSpan(
                    text: 'By registering, you agree to ForeGlyc ',
                    style: TextStyles.body3(
                      weight: FontWeightOption.regular,
                      color: ColorStyles.neutral600,
                    ),
                    children: [
                      TextSpan(
                        text: 'Terms of Service ',
                        style: GoogleFonts.workSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorStyles.primary500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextSpan(
                        text: 'and ',
                        style: TextStyles.body3(
                          weight: FontWeightOption.regular,
                          color: ColorStyles.neutral600,
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: GoogleFonts.workSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorStyles.primary500,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Buttons(
                  text: 'Create Account',
                  onClicked:
                      isButtonEnabled
                          ? () {
                            context.read<AuthBloc>().add(
                              SignupEvent(
                                name: nameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                confirmPassword:
                                    passwordConfirmationController.text,
                              ),
                            );
                          }
                          : () {},
                  bColor:
                      isButtonEnabled
                          ? ColorStyles.primary500
                          : ColorStyles.neutral300,
                ),
                SizedBox(height: 24.h),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(RoutePath.loginPage),
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyles.body2(
                          weight: FontWeightOption.regular,
                          color: ColorStyles.neutral600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
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
