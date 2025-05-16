import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/blocs/monitoring_preferences/monitoring_preferences_bloc.dart';
import 'package:foreglyc/presentation/views/main/monitoring/glucometer/monitoring_settings_info_screen.dart';

class MonitoringSettingsScreen extends StatefulWidget {
  const MonitoringSettingsScreen({super.key});

  @override
  State<MonitoringSettingsScreen> createState() =>
      _MonitoringSettingsScreenState();
}

class _MonitoringSettingsScreenState extends State<MonitoringSettingsScreen> {
  final TextEditingController _wakeUpStartController = TextEditingController();
  final TextEditingController _wakeUpEndController = TextEditingController();
  final TextEditingController _sleepStartController = TextEditingController();
  final TextEditingController _sleepEndController = TextEditingController();

  final Map<String, bool> _activityDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  @override
  void initState() {
    super.initState();
    _wakeUpStartController.text = '';
    _wakeUpEndController.text = '';
    _sleepStartController.text = '';
    _sleepEndController.text = '';
  }

  @override
  void dispose() {
    _wakeUpStartController.dispose();
    _wakeUpEndController.dispose();
    _sleepStartController.dispose();
    _sleepEndController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validate time fields
    if (_wakeUpStartController.text.isEmpty ||
        _wakeUpEndController.text.isEmpty ||
        _sleepStartController.text.isEmpty ||
        _sleepEndController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua waktu terlebih dahulu')),
      );
      return;
    }

    // Validate time format (should be HH:mm)
    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
    if (!timeRegex.hasMatch(_wakeUpStartController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Format waktu bangun mulai tidak valid')),
      );
      return;
    }
    final selectedDays =
        _activityDays.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    // If all valid, proceed
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => BlocProvider.value(
              value: BlocProvider.of<MonitoringPreferenceBloc>(context),
              child: MonitoringSettingsInfoScreen(
                wakeUpStartTime: _wakeUpStartController.text,
                wakeUpEndTime: _wakeUpEndController.text,
                sleepStartTime: _sleepStartController.text,
                sleepEndTime: _sleepEndController.text,
                physicalActivityDays: selectedDays,
              ),
            ),
      ),
    );
  }

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
                      'Notification',
                      style: TextStyles.heading3(color: ColorStyles.primary700),
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
                                  'Reminders to perform blood sugar tests will appear as notifications at the schedule you have chosen.',
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
                      '2 Hours After Meals',
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'This test is conducted to determine how well your body responds to food',
                      style: TextStyles.body2(color: ColorStyles.neutral600),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Wake Up Time
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
                      'What Time Do You Wake Up?',
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'This reminder appears after your wake-up time to determine your baseline blood sugar level, unaffected by food.',
                      style: TextStyles.body2(color: ColorStyles.neutral600),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: TimeInputField(
                            controller: _wakeUpStartController,
                            hint: 'Mulai',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('-'),
                        ),
                        Expanded(
                          child: TimeInputField(
                            controller: _wakeUpEndController,
                            hint: 'Selesai',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Physical Activity
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
                      'When Do You Do Physical Activity?',
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'This reminder appears before and after physical activity, such as exercise, to manage the necessary intake for recovery.',
                      style: TextStyles.body2(color: ColorStyles.neutral600),
                    ),
                    SizedBox(height: 16.h),

                    // Days of the week checkboxes
                    ..._activityDays.entries.map(
                      (entry) => _buildDayCheckbox(entry.key, entry.value),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Sleep Time
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
                      'When Do You Go to Sleep?',
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'This reminder appears before your bedtime to prevent the risk of hypoglycemia during sleep.',
                      style: TextStyles.body2(color: ColorStyles.neutral600),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: TimeInputField(
                            controller: _sleepStartController,
                            hint: 'Mulai',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text('-'),
                        ),
                        Expanded(
                          child: TimeInputField(
                            controller: _sleepEndController,
                            hint: 'Selesai',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32.h),

            // Submit Button
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
    );
  }

  Widget _buildDayCheckbox(String day, bool value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: TextStyles.body1()),
          SizedBox(
            width: 24.w,
            height: 24.w,
            child: Checkbox(
              value: value,
              onChanged: (newValue) {
                setState(() {
                  _activityDays[day] = newValue ?? false;
                });
              },
              activeColor: ColorStyles.primary500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.r),
              ),
              side: BorderSide(color: ColorStyles.neutral400, width: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;

  const TimeInputField({
    required this.controller,
    required this.hint,
    super.key,
  });

  @override
  State<TimeInputField> createState() => _TimeInputFieldState();
}

class _TimeInputFieldState extends State<TimeInputField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center, // Untuk alignment horizontal
        textAlignVertical: TextAlignVertical.center, // Untuk alignment vertikal
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(4),
          _TimeInputFormatter(),
        ],
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: TextStyles.body1(
            color: ColorStyles.primary500,
            weight: FontWeightOption.semiBold,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          isDense: true,
          alignLabelWithHint: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.primary500),
            borderRadius: BorderRadius.circular(8.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.primary500),
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.primary500, width: 2),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        style: TextStyles.body1(
          color: ColorStyles.primary500,
          weight: FontWeightOption.semiBold,
        ),
      ),
    );
  }
}

class _TimeInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handle deletion
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    }

    final newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    // If empty, return as is
    if (newText.isEmpty) return newValue;

    // Handle first digit (0-2)
    if (newText.length == 1) {
      final firstDigit = int.parse(newText[0]);
      if (firstDigit > 2) {
        // If first digit is 3-9, automatically add 0 prefix
        return TextEditingValue(
          text: '0$newText:',
          selection: const TextSelection.collapsed(offset: 3),
        );
      }
      return newValue;
    }

    // Handle second digit (based on first digit)
    if (newText.length == 2) {
      final firstDigit = int.parse(newText[0]);
      final secondDigit = int.parse(newText[1]);

      if (firstDigit == 2 && secondDigit > 3) {
        // 24, 25, etc. becomes 23
        return TextEditingValue(
          text: '23:',
          selection: const TextSelection.collapsed(offset: 3),
        );
      }
      // Add colon after 2 digits
      return TextEditingValue(
        text: '$newText:',
        selection: const TextSelection.collapsed(offset: 3),
      );
    }

    // Handle minutes (third digit, 0-5)
    if (newText.length == 3) {
      final minuteDigit = int.parse(newText[2]);
      if (minuteDigit > 5) {
        return TextEditingValue(
          text: '${newText.substring(0, 2)}:0',
          selection: const TextSelection.collapsed(offset: 4),
        );
      }
      return TextEditingValue(
        text: '${newText.substring(0, 2)}:${newText[2]}',
        selection: const TextSelection.collapsed(offset: 4),
      );
    }

    // Handle fourth digit (0-9)
    if (newText.length == 4) {
      return TextEditingValue(
        text: '${newText.substring(0, 2)}:${newText.substring(2)}',
        selection: const TextSelection.collapsed(offset: 5),
      );
    }

    return newValue;
  }
}
