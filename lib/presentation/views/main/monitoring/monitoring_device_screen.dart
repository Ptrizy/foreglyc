import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/datasources/local/home_preference.dart';
import 'package:foreglyc/presentation/blocs/profile/profile_bloc.dart';
import 'package:foreglyc/presentation/views/main/monitoring/cgm/monitoring_screen.dart'
    as cgmMonitor;
import 'package:foreglyc/presentation/views/main/monitoring/glucometer/monitoring_screen.dart'
    as glucoMonitor;
import 'package:foreglyc/presentation/views/main/monitoring/glucometer/method_screen.dart'
    as gluco;
import 'package:foreglyc/presentation/views/main/monitoring/cgm/method_screen.dart'
    as cgm;
import 'package:foreglyc/presentation/widgets/button.dart';
import 'package:go_router/go_router.dart';

class MonitoringDeviceScreen extends StatelessWidget {
  const MonitoringDeviceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(72.h),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 32.h),
            child: Row(
              children: [
                IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/arrow-left.svg',
                    width: 24.w,
                    height: 24.h,
                  ),
                  onPressed: () => context.go(RoutePath.mainPage),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Device',
                      style: TextStyles.heading4(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 48.w),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<ProfileBloc, Map<String, String?>>(
        builder: (context, profileData) {
          final isCGMConnected = profileData[HomePreferences.cgmKey] == 'true';
          final isGlucoConnected =
              profileData[HomePreferences.glucoKey] == 'true';

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDeviceSection(
                  context: context,
                  title: 'CGM',
                  subtitle: 'Minimally Invasive CGM',
                  description:
                      'Smart device for screening heart, liver, and eye conditions to detect complication symptoms.',
                  iconPath: 'assets/cgm_device.png',
                  isConnected: isCGMConnected,
                  connectedPage:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => cgmMonitor.MonitoringScreen(),
                        ),
                      ),
                  notConnectedPage:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => cgm.MethodScreen()),
                      ),
                ),
                SizedBox(height: 24.h),
                _buildDeviceSection(
                  context: context,
                  title: 'Glucometer',
                  subtitle: 'Invasive CGM',
                  description:
                      'A device for regularly testing blood sugar and manually entering the results for recording.',
                  iconPath: 'assets/glucometer_device.png',
                  isConnected: isGlucoConnected,
                  connectedPage:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => glucoMonitor.MonitoringScreen(),
                        ),
                      ),
                  notConnectedPage:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => gluco.MethodScreen(),
                        ),
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDeviceSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String description,
    required String iconPath,
    required bool isConnected,
    required VoidCallback connectedPage,
    required VoidCallback notConnectedPage,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: Color(0xFFFAFAFA),
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        border: Border.all(
          width: 1.w,
          color: isConnected ? ColorStyles.primary500 : ColorStyles.neutral200,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF27272A).withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              iconPath,
              width: 80.w,
              height: 164.h,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyles.heading4(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                    if (isConnected) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorStyles.success500,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'Connected',
                          style: TextStyles.body3(
                            color: ColorStyles.white,
                            weight: FontWeightOption.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 8.h),
                Container(
                  decoration: BoxDecoration(
                    color: ColorStyles.primary100,
                    borderRadius: BorderRadius.all(Radius.circular(100.r)),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  child: Text(
                    subtitle,
                    style: TextStyles.body3(
                      color: ColorStyles.primary500,
                      weight: FontWeightOption.semiBold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  description,
                  style: TextStyles.body3(color: ColorStyles.neutral500),
                ),
                SizedBox(height: 12.h),
                SizedBox(
                  width: double.infinity,
                  child: Buttons(
                    text: isConnected ? 'Start' : 'Add',
                    height: 36,
                    onClicked: isConnected ? connectedPage : notConnectedPage,
                    bColor:
                        isConnected
                            ? ColorStyles.success500
                            : ColorStyles.primary500,
                    tColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
