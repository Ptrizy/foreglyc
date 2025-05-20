import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_bloc.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_event.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_state.dart';
import 'package:foreglyc/presentation/widgets/loading%20copy.dart';

class GlucoseTrackingPopup extends StatefulWidget {
  const GlucoseTrackingPopup({super.key});

  @override
  State<GlucoseTrackingPopup> createState() => _GlucoseTrackingPopupState();
}

class _GlucoseTrackingPopupState extends State<GlucoseTrackingPopup> {
  final TextEditingController _glucoseController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _glucoseController.dispose();
    super.dispose();
  }

  void _submitGlucoseReading(BuildContext context) {
    final text = _glucoseController.text.trim();
    if (text.isEmpty) return;

    try {
      final glucoseValue = int.parse(text);
      setState(() => _isSubmitting = true);

      context.read<MonitoringBloc>().add(
        CreateGlucometerMonitoringEvent(glucoseValue),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid whole number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<MonitoringBloc, MonitoringState>(
      listener: (context, state) {
        if (state is MonitoringGlucoseLoading) {
          Loading();
        }
        if (state is MonitoringError) {
          setState(() => _isSubmitting = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is MonitoringGlucoseCreated) {
          setState(() => _isSubmitting = false);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil tercatat!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Fore-Log',
                  style: TextStyles.heading2(weight: FontWeightOption.bold),
                ),
                SizedBox(height: 16.h),
                SvgPicture.asset(
                  'assets/fore_log_add.svg',
                  height: 200.h,
                  width: bottomInset > 0 ? 150.w : 200.w,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Please input the current blood glucose test result from your glucometer for accurate tracking.',
                  textAlign: TextAlign.center,
                  style: TextStyles.body1(),
                ),
                SizedBox(height: 24.h),
                TextField(
                  controller: _glucoseController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Enter result (mg/DL)',
                    hintStyle: TextStyles.body2(color: ColorStyles.neutral500),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: ColorStyles.neutral300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: ColorStyles.neutral300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: ColorStyles.primary500),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 20.h,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed:
                        _isSubmitting
                            ? null
                            : () => _submitGlucoseReading(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _isSubmitting
                              ? ColorStyles.primary300
                              : ColorStyles.primary500,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child:
                        _isSubmitting
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : Text(
                              'Submit',
                              style: TextStyles.body1(
                                color: Colors.white,
                                weight: FontWeightOption.semiBold,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
