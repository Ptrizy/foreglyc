import 'package:flutter/material.dart';
import 'package:foreglyc/core/routers/name.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/presentation/views/auth/email_verif_screen.dart';
import 'package:foreglyc/presentation/views/auth/forgot_pass_screen.dart';
import 'package:foreglyc/presentation/views/auth/forgot_pass_verif_screen.dart';
import 'package:foreglyc/presentation/views/auth/login_screen.dart';
import 'package:foreglyc/presentation/views/auth/new_pass_screen.dart';
import 'package:foreglyc/presentation/views/auth/signup_screen.dart';
import 'package:foreglyc/presentation/views/auth/success_screen.dart';
import 'package:foreglyc/presentation/views/main/account/account_screen.dart';
import 'package:foreglyc/presentation/views/main/dietary/dietary_screen.dart';
import 'package:foreglyc/presentation/views/main/home/home_screen.dart';
import 'package:foreglyc/presentation/views/main/main_view.dart';
import 'package:foreglyc/presentation/views/main/monitoring/monitoring_default_screen.dart';
import 'package:foreglyc/presentation/views/main/monitoring/monitoring_device_screen.dart';
import 'package:foreglyc/presentation/views/main/services/journey/journey_detail_screen.dart';
import 'package:foreglyc/presentation/views/main/services/journey/journey_screen.dart';
import 'package:foreglyc/presentation/views/onboarding/onboarding_screen.dart';
import 'package:foreglyc/presentation/views/onboarding/splash_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: RoutePath.splashPage,
  routes: [
    GoRoute(
      path: RoutePath.splashPage,
      name: RouteName.splashPage,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: RoutePath.onboardingPage,
      name: RouteName.onboardingPage,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: RoutePath.loginPage,
      name: RouteName.loginPage,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RoutePath.signupPage,
      name: RouteName.signupPage,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: RoutePath.mainPage,
      name: RouteName.mainPage,
      builder: (context, state) => const MainView(),
    ),
    GoRoute(
      path: RoutePath.emailVerifPage,
      name: RouteName.emailVerifPage,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return EmailVerifScreen(email: email);
      },
    ),
    GoRoute(
      path: RoutePath.successPage,
      name: RouteName.successPage,
      builder: (context, state) {
        final content = state.extra as Widget;
        return SuccessScreen(column: content);
      },
    ),
    GoRoute(
      path: RoutePath.forgotPassPage,
      name: RouteName.forgotPassPage,
      builder: (context, state) => const ForgotPassScreen(),
    ),
    GoRoute(
      path: RoutePath.forgotPassVerifPage,
      name: RouteName.forgotPassVerifPage,
      builder: (context, state) {
        final email = state.uri.queryParameters['email'] ?? '';
        return ForgotPassVerifScreen(email: email);
      },
    ),
    GoRoute(
      path: RoutePath.newPassPage,
      name: RouteName.newPassPage,
      builder: (context, state) => const NewPassScreen(),
    ),
    GoRoute(
      path: RoutePath.homePage,
      name: RouteName.homePage,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: RoutePath.dietaryPage,
      name: RouteName.dietaryPage,
      builder: (context, state) => const DietaryScreen(),
    ),
    GoRoute(
      path: RoutePath.monitoringPage,
      name: RouteName.monitoringPage,
      builder: (context, state) => const MonitoringDefaultScreen(),
    ),
    GoRoute(
      path: RoutePath.accountPage,
      name: RouteName.accountPage,
      builder: (context, state) => const AccountScreen(),
    ),
    GoRoute(
      path: RoutePath.monitoringDevicePage,
      name: RouteName.monitoringDevicePage,
      builder: (context, state) => const MonitoringDeviceScreen(),
    ),
    GoRoute(
      path: RoutePath.journeyDetailPage,
      name: RouteName.journeyDetailPage,
      builder: (context, state) => const JourneyDetailScreen(),
    ),
    GoRoute(
      path: RoutePath.journeyPage,
      name: RouteName.journeyPage,
      builder: (context, state) => const JourneyScreen(),
    ),
  ],
);
