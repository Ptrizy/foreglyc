import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/blocs/monitoring_preferences/monitoring_preferences_bloc.dart';

class MonitoringSettingsInfoScreen extends StatefulWidget {
  const MonitoringSettingsInfoScreen({super.key});

  @override
  State<MonitoringSettingsInfoScreen> createState() =>
      _MonitoringSettingsInfoScreenState();
}

class _MonitoringSettingsInfoScreenState
    extends State<MonitoringSettingsInfoScreen> {
  // Slider values
  double _hypoChronicValue = 0.5; // 50-80 range
  double _hypoAcuteValue = 0.5; // 30-50 range
  double _hyperChronicValue = 0.5; // 170-299 range
  double _hyperAcuteValue = 0.5; // 300-500 range

  // Checkbox value
  bool _sendNotifications = false;

  // Calculate actual values based on slider positions
  int getHypoChronicValue() {
    return (50 + (_hypoChronicValue * 30)).round(); // 50-80 range
  }

  int getHypoAcuteValue() {
    return (30 + (_hypoAcuteValue * 20)).round(); // 30-50 range
  }

  int getHyperChronicValue() {
    return (170 + (_hyperChronicValue * 129)).round(); // 170-299 range
  }

  int getHyperAcuteValue() {
    return (300 + (_hyperAcuteValue * 200)).round(); // 300-500 range
  }

  void _submitForm() {
    print('Hypo Chronic: ${getHypoChronicValue()}');
    print('Hypo Acute: ${getHypoAcuteValue()}');
    print('Hyper Chronic: ${getHyperChronicValue()}');
    print('Hyper Acute: ${getHyperAcuteValue()}');
    print('Send Notifications: $_sendNotifications');

    context.read<MonitoringPreferenceBloc>().add(
      CreateCgmPreferenceEvent(
        hypoglycemiaAccuteThreshold: getHypoAcuteValue().toDouble(),
        hypoglycemiaChronicThreshold: getHypoChronicValue().toDouble(),
        hyperglycemiaAccuteThreshold: getHyperAcuteValue().toDouble(),
        hyperglycemiaChronicThreshold: getHyperChronicValue().toDouble(),
        sendNotification: _sendNotifications,
      ),
    );

    // Kembali ke halaman utama
    Navigator.popUntil(
      context,
      (route) => route.isFirst || route.settings.name == 'monitoringPage',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MonitoringPreferenceBloc, MonitoringPreferenceState>(
      listener: (context, state) {
        if (state is MonitoringPreferenceError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if (state is GlucometerPreferenceCreated) {
          print('Preference created successfully: ${state.response}');
        }
      },
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: AppBar(
          backgroundColor: ColorStyles.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorStyles.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Monitoring Settings',
            style: TextStyles.heading2(),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(color: ColorStyles.neutral300),
              SizedBox(height: 16.h),

              // Information Request Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorStyles.primary100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Information Request',
                        style: TextStyles.heading3(
                          color: ColorStyles.primary700,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Answer the questions below to configure the device according to your needs.',
                        style: TextStyles.body2(color: ColorStyles.primary700),
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorStyles.primary300),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.amber,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Why are these settings needed?',
                                    style: TextStyles.body1(
                                      color: ColorStyles.primary500,
                                      weight: FontWeightOption.semiBold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Configure when you want to receive complication risk warnings',
                                    style: TextStyles.body2(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Complication Risk Alerts',
                  style: TextStyles.heading3(),
                ),
              ),

              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorStyles.neutral300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hypoglycemia Alerts :',
                        style: TextStyles.body1(
                          fontSize: 20,
                          weight: FontWeightOption.semiBold,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      RichText(
                        text: TextSpan(
                          text: 'Chronic ',
                          style: TextStyles.body2(
                            weight: FontWeightOption.semiBold,
                          ),
                          children: [
                            TextSpan(
                              text: '80 - 50 mg/DL',
                              style: TextStyles.body3(color: Color(0xFF52525B)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Value indicator
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorStyles.primary500,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${getHypoChronicValue()} mg/DL',
                            style: TextStyles.body3(color: ColorStyles.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4.h,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 10.r,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 20.r,
                          ),
                          activeTrackColor: ColorStyles.primary500,
                          inactiveTrackColor: ColorStyles.neutral300,
                          thumbColor: ColorStyles.primary500,
                          overlayColor: ColorStyles.primary500.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _hypoChronicValue,
                          onChanged: (value) {
                            setState(() {
                              _hypoChronicValue = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('50 mg/DL', style: TextStyles.body3()),
                          Text('80 mg/DL', style: TextStyles.body3()),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      RichText(
                        text: TextSpan(
                          text: 'Acute ',
                          style: TextStyles.body2(
                            weight: FontWeightOption.semiBold,
                          ),
                          children: [
                            TextSpan(
                              text: '50 - <30 mg/DL',
                              style: TextStyles.body3(color: Color(0xFF52525B)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Value indicator
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorStyles.primary500,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${getHypoAcuteValue()} mg/DL',
                            style: TextStyles.body3(color: ColorStyles.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4.h,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 10.r,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 20.r,
                          ),
                          activeTrackColor: ColorStyles.primary500,
                          inactiveTrackColor: ColorStyles.neutral300,
                          thumbColor: ColorStyles.primary500,
                          overlayColor: ColorStyles.primary500.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _hypoAcuteValue,
                          onChanged: (value) {
                            setState(() {
                              _hypoAcuteValue = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('<30 mg/DL', style: TextStyles.body3()),
                          Text('50 mg/DL', style: TextStyles.body3()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Hyperglycemia Alerts
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorStyles.neutral300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hyperglycemia Alerts :',
                        style: TextStyles.body1(
                          weight: FontWeightOption.semiBold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      RichText(
                        text: TextSpan(
                          text: 'Chronic ',
                          style: TextStyles.body2(
                            weight: FontWeightOption.semiBold,
                          ),
                          children: [
                            TextSpan(
                              text: '170-299 mg/DL',
                              style: TextStyles.body3(color: Color(0xFF52525B)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Value indicator
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorStyles.primary500,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${getHyperChronicValue()} mg/DL',
                            style: TextStyles.body3(color: ColorStyles.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4.h,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 10.r,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 20.r,
                          ),
                          activeTrackColor: ColorStyles.primary500,
                          inactiveTrackColor: ColorStyles.neutral300,
                          thumbColor: ColorStyles.primary500,
                          overlayColor: ColorStyles.primary500.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _hyperChronicValue,
                          onChanged: (value) {
                            setState(() {
                              _hyperChronicValue = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('170 mg/DL', style: TextStyles.body3()),
                          Text('299 mg/DL', style: TextStyles.body3()),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // Acute Hyperglycemia
                      RichText(
                        text: TextSpan(
                          text: 'Acute ',
                          style: TextStyles.body2(
                            weight: FontWeightOption.semiBold,
                          ),
                          children: [
                            TextSpan(
                              text: '300-500 mg/DL',
                              style: TextStyles.body3(color: Color(0xFF52525B)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Value indicator
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorStyles.primary500,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            '${getHyperAcuteValue()} mg/DL',
                            style: TextStyles.body3(color: ColorStyles.white),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      SliderTheme(
                        data: SliderThemeData(
                          trackHeight: 4.h,
                          thumbShape: RoundSliderThumbShape(
                            enabledThumbRadius: 10.r,
                          ),
                          overlayShape: RoundSliderOverlayShape(
                            overlayRadius: 20.r,
                          ),
                          activeTrackColor: ColorStyles.primary500,
                          inactiveTrackColor: ColorStyles.neutral300,
                          thumbColor: ColorStyles.primary500,
                          overlayColor: ColorStyles.primary500.withOpacity(0.2),
                        ),
                        child: Slider(
                          value: _hyperAcuteValue,
                          onChanged: (value) {
                            setState(() {
                              _hyperAcuteValue = value;
                            });
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('300 mg/DL', style: TextStyles.body3()),
                          Text('500 mg/DL', style: TextStyles.body3()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Drastic Spike or Drop
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'What do you want to do if there is a drastic spike or drop?',
                  style: TextStyles.body1(weight: FontWeightOption.semiBold),
                ),
              ),

              SizedBox(height: 16.h),

              // Notification Option
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorStyles.neutral300),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Send notifications to connected user smartphones for severe status',
                          style: TextStyles.body2(),
                        ),
                      ),
                      SizedBox(
                        width: 24.w,
                        height: 24.w,
                        child: Checkbox(
                          value: _sendNotifications,
                          onChanged: (newValue) {
                            setState(() {
                              _sendNotifications = newValue ?? false;
                            });
                          },
                          activeColor: ColorStyles.primary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          side: BorderSide(
                            color: ColorStyles.neutral400,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              // Notification Types
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Container(
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: ColorStyles.primary100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'There are several notification types',
                        style: TextStyles.body1(
                          weight: FontWeightOption.semiBold,
                          color: ColorStyles.primary700,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Moderate Alert
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: ColorStyles.primary500,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Moderate Alert',
                                    style: TextStyles.body1(
                                      color: ColorStyles.primary500,
                                      weight: FontWeightOption.semiBold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Phone vibrates briefly, priority notification appears repeatedly every 20mg/DL increase/decrease in blood sugar',
                                    style: TextStyles.body2(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.notifications_active_outlined,
                              color: ColorStyles.primary500,
                              size: 24.sp,
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Severe Alert',
                                    style: TextStyles.body1(
                                      color: ColorStyles.primary500,
                                      weight: FontWeightOption.semiBold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Phone vibrates longer, notification appears repeatedly every 10mg/DL increase/decrease in blood sugar',
                                    style: TextStyles.body2(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.all(16.r),
                child: GestureDetector(
                  onTap: () {
                    _submitForm();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: ColorStyles.primary500,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Submit',
                      style: TextStyles.button1(color: ColorStyles.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
