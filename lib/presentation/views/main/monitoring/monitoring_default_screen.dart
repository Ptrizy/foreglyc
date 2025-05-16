import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/routers/path.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/datasources/local/home_preference.dart';
import 'package:foreglyc/presentation/blocs/profile/profile_bloc.dart';
import 'package:foreglyc/presentation/widgets/button.dart';
import 'package:go_router/go_router.dart';

class MonitoringDefaultScreen extends StatelessWidget {
  const MonitoringDefaultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(gradient: ColorStyles.gradient1),
          ),
          Positioned(
            top: 56.h,
            left: 16.w,
            bottom: 0,
            right: 16.w,
            child: BlocBuilder<ProfileBloc, Map<String, String?>>(
              builder: (context, profileData) {
                final isCGMConnected =
                    profileData[HomePreferences.cgmKey] == 'true';
                final isGlucoConnected =
                    profileData[HomePreferences.glucoKey] == 'true';
                final hasConnectedDevice = isCGMConnected || isGlucoConnected;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Monitoring',
                      style: TextStyles.heading3(color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 50.h),
                      child: SvgPicture.asset(
                        hasConnectedDevice
                            ? 'assets/monitoring_def_placeholder.svg'
                            : 'assets/monitoring_def_placeholder.svg',
                        width: 280.w,
                        height: 278.h,
                      ),
                    ),
                    Text(
                      hasConnectedDevice
                          ? 'Device Connected'
                          : 'No Device Connected',
                      style: TextStyles.heading2(color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h, bottom: 32.h),
                      child: Text(
                        hasConnectedDevice
                            ? 'Your monitoring device is ready to use.'
                            : 'Please connect your device to enable in-depth monitoring and access more granular data.',
                        style: TextStyles.body1(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Buttons(
                      text:
                          hasConnectedDevice
                              ? 'Start Monitoring'
                              : 'Add Device',
                      bColor: Colors.white,
                      tColor: ColorStyles.primary500,
                      onClicked: () {
                        context.go(RoutePath.monitoringDevicePage);
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
