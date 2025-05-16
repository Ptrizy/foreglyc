import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/views/main/monitoring/cgm/monitoring_settings_info_screen.dart';

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
                      Text('CGM', style: TextStyles.heading1()),
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
                          'Manually Invasive CGM',
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
                      'assets/cgm_method.png',
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
                        'Insert the CGM sensor under the skin, usually on the arm or abdomen, to continuously monitor glucose.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 2,
                    text:
                        'The sensor automatically measures glucose levels every few minutes and sends the data to a device, such as a smartphone or dedicated monitor.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 3,
                    text:
                        'Glucose data is displayed in real-time as numbers and graphs in the application.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 4,
                    text:
                        'The device provides automatic alerts if glucose levels are too high or too low.',
                  ),

                  SizedBox(height: 16.h),

                  _buildStep(
                    number: 5,
                    text:
                        'Data is stored in the application and can be used for long-term monitoring and analysis.',
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            Padding(
              padding: EdgeInsets.all(16.r),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonitoringSettingsInfoScreen(),
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
