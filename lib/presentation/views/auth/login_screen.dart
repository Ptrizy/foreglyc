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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkFields);
    passwordController.addListener(_checkFields);
  }

  @override
  void dispose() {
    emailController.removeListener(_checkFields);
    passwordController.removeListener(_checkFields);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _checkFields() {
    setState(() {
      isButtonEnabled =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ),
          );
        } else if (state is AuthVerified || state is AuthSignedIn) {
          Navigator.pop(context);
          context.go(RoutePath.mainPage);
        }
      },
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        body: SingleChildScrollView(
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
                Text('Welcome 👋', style: TextStyles.heading2()),
                SizedBox(height: 4.h),
                Text(
                  'Sign in to your account to continue',
                  style: TextStyles.body2(
                    weight: FontWeightOption.regular,
                    color: ColorStyles.neutral600,
                  ),
                ),

                SizedBox(height: 24.h),
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
                SizedBox(height: 8.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => context.go(RoutePath.forgotPassPage),
                    child: Text(
                      'Forgot Password?',
                      style: TextStyles.button2(color: ColorStyles.primary500),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Buttons(
                  text: 'Sign In',
                  onClicked:
                      isButtonEnabled
                          ? () => context.read<AuthBloc>().add(
                            SigninEvent(
                              email: emailController.text,
                              password: passwordController.text,
                            ),
                          )
                          : () {},
                  bColor:
                      isButtonEnabled
                          ? ColorStyles.primary500
                          : ColorStyles.neutral300,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Row(
                    children: [
                      Expanded(child: Divider(height: 1.h)),
                      SizedBox(width: 16.w),
                      Text(
                        'or sign in with email',
                        style: TextStyles.body2(
                          weight: FontWeightOption.regular,
                          color: ColorStyles.neutral500,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(child: Divider(height: 1.h)),
                    ],
                  ),
                ),
                LoginWithGoogleButton(),
                SizedBox(height: 24.h),
                Center(
                  child: GestureDetector(
                    onTap: () => context.go(RoutePath.signupPage),
                    child: RichText(
                      text: TextSpan(
                        text: 'Don’t have an account? ',
                        style: TextStyles.body2(
                          weight: FontWeightOption.regular,
                          color: ColorStyles.neutral600,
                        ),
                        children: [
                          TextSpan(
                            text: 'Register',
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

class LoginWithGoogleButton extends StatelessWidget {
  const LoginWithGoogleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          side: BorderSide(width: 1.5.w, color: ColorStyles.neutral300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24.w,
              height: 24.h,
              child: SvgPicture.asset('assets/icons/google.svg'),
            ),
            SizedBox(width: 8.w),
            Text(
              'Sign in with Google',
              style: TextStyles.body1(
                weight: FontWeightOption.semiBold,
                color: ColorStyles.neutral600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
