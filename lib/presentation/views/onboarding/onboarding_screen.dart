import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/presentation/widgets/page_indicator.dart';
import 'package:go_router/go_router.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      imagePath: 'assets/ob_1.svg',
      title: 'Predict Your Glucose, Control Your Life.',
      description:
          'Manage diabetes smarter with ForeGlyc. Get the fastest glucose predictions, personalized meal plans, and real-time monitoring, all in one app.',
    ),
    OnboardingPage(
      imagePath: 'assets/ob_2.svg',
      title: 'Smart Glucose Monitoring and Insightful Analysis',
      description:
          'Connect your glucometer or CGM for instant glucose insights. Track trends and understand your patterns with easy-to-read reports.',
    ),
    OnboardingPage(
      imagePath: 'assets/ob_3.svg',
      title: 'Meal Plans for Glucose Control and Dietary Plan',
      description:
          'Upload meal photos for automatic nutrition analysis. Get custom meal plans to help you achieve your dietary goals, and healthy eating.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: ColorStyles.gradient1),
        child: SafeArea(
          child: Stack(
            children: [
              if (_currentPage != _pages.length - 1)
                Positioned(
                  top: 12.h,
                  right: 16.w,
                  child: TextButton(
                    onPressed: () {
                      _pageController.jumpToPage(_pages.length - 1);
                    },
                    child: Text(
                      'Lewati',
                      style: TextStyles.button1(
                        weight: FontWeightOption.semiBold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(height: 64.h),
                      SvgPicture.asset(
                        _pages[index].imagePath,
                        width: 240.w,
                        height: 240.h,
                      ),
                      SizedBox(height: 32.h),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.w,
                            vertical: 32.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24.r),
                              topRight: Radius.circular(24.r),
                            ),
                          ),
                          child: Column(
                            children: [
                              PageIndicator(
                                currentIndex: _currentPage,
                                length: _pages.length,
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                _pages[index].title,
                                textAlign: TextAlign.center,
                                style: TextStyles.heading1(
                                  weight: FontWeightOption.bold,
                                  color: ColorStyles.black,
                                  fontSize: 28,
                                ).copyWith(height: 1.2.h),
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                _pages[index].description,
                                textAlign: TextAlign.center,
                                style: TextStyles.body1(
                                  weight: FontWeightOption.regular,
                                  color: Color(0xFF71717A),
                                ).copyWith(height: 1.5.h),
                              ),
                              const Spacer(),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    if (_currentPage < _pages.length - 1) {
                                      _pageController.nextPage(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    } else {
                                      context.go(RoutePath.loginPage);
                                    }
                                  },
                                  child: Container(
                                    width: 56.w,
                                    height: 56.h,
                                    decoration: BoxDecoration(
                                      color: ColorStyles.primary500,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        'assets/icons/caret_right.svg',
                                        width: 24.w,
                                        height: 24.h,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32.h),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class OnboardingPage {
  final String imagePath;
  final String title;
  final String description;

  OnboardingPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}
