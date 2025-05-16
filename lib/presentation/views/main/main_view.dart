import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/views/main/account/account_screen.dart';
import 'package:foreglyc/presentation/views/main/dietary/dietary_screen.dart';
import 'package:foreglyc/presentation/views/main/home/home_screen.dart';
import 'package:foreglyc/presentation/views/main/monitoring/monitoring_default_screen.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late List<Widget> screens;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    screens = [
      const HomeScreen(),
      const DietaryScreen(),
      const MonitoringDefaultScreen(),
      const AccountScreen(),
    ];

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: screens[currentIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 66,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(71, 64, 66, 0.1),
                    blurRadius: 24,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                useLegacyColorScheme: false,
                type: BottomNavigationBarType.fixed,
                currentIndex: currentIndex,
                onTap: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  _controller.reset();
                  _controller.forward();
                },
                showUnselectedLabels: true,
                selectedLabelStyle: TextStyles.body3(
                  color: ColorStyles.primary500,
                  weight: FontWeightOption.semiBold,
                ),
                selectedItemColor: ColorStyles.primary500,
                unselectedLabelStyle: TextStyles.body3(
                  color: ColorStyles.neutral500,
                  weight: FontWeightOption.regular,
                ),
                unselectedItemColor: ColorStyles.neutral500,
                items: [
                  _buildAnimatedNavItem(
                    index: 0,
                    inactiveIcon: 'assets/icons/home_inactive.svg',
                    activeIcon: 'assets/icons/home_active.svg',
                    label: "Home",
                  ),
                  _buildAnimatedNavItem(
                    index: 1,
                    inactiveIcon: 'assets/icons/dietary_inactive.svg',
                    activeIcon: 'assets/icons/dietary_active.svg',
                    label: "Diatery",
                  ),
                  _buildAnimatedNavItem(
                    index: 2,
                    inactiveIcon: 'assets/icons/monitoring_inactive.svg',
                    activeIcon: 'assets/icons/monitoring_active.svg',
                    label: "Monitoring",
                  ),
                  _buildAnimatedNavItem(
                    index: 3,
                    inactiveIcon: 'assets/icons/account_inactive.svg',
                    activeIcon: 'assets/icons/account_active.svg',
                    label: "Account",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildAnimatedNavItem({
    required int index,
    required String inactiveIcon,
    required String activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(inactiveIcon),
      activeIcon: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            width: 60.w,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  width: 2.w * _animation.value,
                  color: ColorStyles.primary500,
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 4.h * _animation.value),
              child: SvgPicture.asset(activeIcon),
            ),
          );
        },
      ),
      label: label,
    );
  }
}
