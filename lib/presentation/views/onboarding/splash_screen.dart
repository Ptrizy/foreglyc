import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        context.go(RoutePath.onboardingPage);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(gradient: ColorStyles.gradient1),
          ),

          Positioned(
            left: -156.w,
            right: -156.w,
            bottom: -200.h,
            child: SvgPicture.asset(
              'assets/foreglyc_splash.svg',
              width: 712.w,
              height: 732.h,
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ),
          ),
        ],
      ),
    );
  }
}
