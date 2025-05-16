import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/views/main/monitoring/glucometer/monitoring_setting_screen.dart';

class MethodScreen extends StatelessWidget {
  const MethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: AppBar(
        backgroundColor: ColorStyles.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorStyles.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Method',
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

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Glucometer', style: TextStyles.heading1()),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorStyles.primary100,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'Invasive CGM',
                          style: TextStyles.body2(
                            color: ColorStyles.primary700,
                            weight: FontWeightOption.semiBold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.asset(
                      'assets/glucometer_method.png',
                      height: 180.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Text('How the method works:', style: TextStyles.heading3()),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 1,
                    text:
                        'Perform blood sugar testing using a glucometer at crucial times to determine your blood sugar level status.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 2,
                    text:
                        'Self-record the results in the Glucare application by pressing the \'add\' button.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 3,
                    text:
                        'Enter the test result data according to the format provided by the application.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 4,
                    text:
                        'The data will be processed and displayed on a monitoring graph that you can view on the application\'s homepage.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 5,
                    text:
                        'You will receive a complication risk warning if extreme changes in blood sugar level status are detected compared to previous test results.',
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            // Choose Method Button
            Padding(
              padding: EdgeInsets.all(16.r),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonitoringSettingsScreen(),
                    ),
                  );
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
                    'Choose Method',
                    style: TextStyles.button1(color: ColorStyles.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({required int number, required String text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$number.',
          style: TextStyles.body1(weight: FontWeightOption.semiBold),
        ),
        SizedBox(width: 8.w),
        Expanded(child: Text(text, style: TextStyles.body1())),
      ],
    );
  }
}
