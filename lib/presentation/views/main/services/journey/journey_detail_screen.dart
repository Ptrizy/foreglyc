import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class JourneyDetailScreen extends StatefulWidget {
  const JourneyDetailScreen({super.key});

  @override
  State<JourneyDetailScreen> createState() => _JourneyDetailScreenState();
}

class _JourneyDetailScreenState extends State<JourneyDetailScreen> {
  late DateTime _currentMonth;
  late DateTime _selectedDate;
  late List<List<DateTime>> _calendarDays;

  // Map to store color codes for different dates
  final Map<DateTime, Color> _dateColors = {};

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(2025, 4); // April 2025
    _selectedDate = DateTime(2025, 4, 21); // Selected date: April 21, 2025
    _calendarDays = _generateCalendarDays();
    _setupDateColors();
  }

  void _setupDateColors() {
    // Setting up colors for demonstration
    // Green for most days (success)
    // final daysInMonth = DateTime(2025, 5, 0).day;

    // Add color for previous month visible days
    for (int i = 27; i <= 31; i++) {
      _dateColors[DateTime(2025, 3, i)] = ColorStyles.success200;
    }

    // Green for most days
    for (int i = 1; i <= 20; i++) {
      if (i == 13 || i == 14) {
        _dateColors[DateTime(2025, 4, i)] = ColorStyles.info200; // Yellow days
      } else {
        _dateColors[DateTime(2025, 4, i)] =
            ColorStyles.success200; // Green days
      }
    }

    // Mark 28th of March as red
    _dateColors[DateTime(2025, 3, 28)] = ColorStyles.error200;

    // Selected date is blue
    _dateColors[_selectedDate] = ColorStyles.primary200;
  }

  List<List<DateTime>> _generateCalendarDays() {
    List<List<DateTime>> result = [];

    // First day of the month
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);

    // // Last day of the month
    // final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);

    // First day of the calendar grid (could be from previous month)
    int firstWeekday = firstDay.weekday;
    final firstCalendarDay = firstDay.subtract(
      Duration(days: firstWeekday - 1),
    );

    // Generate 6 weeks (42 days) to ensure we cover the month
    DateTime day = firstCalendarDay;
    for (int week = 0; week < 6; week++) {
      List<DateTime> weekDays = [];
      for (int i = 0; i < 7; i++) {
        weekDays.add(day);
        day = day.add(const Duration(days: 1));
      }
      result.add(weekDays);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
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
                  onPressed: () => context.pop(),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      DateFormat('MMMM yyyy').format(_currentMonth),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Calendar Header
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDayHeader('Mon'),
                  _buildDayHeader('Tue'),
                  _buildDayHeader('Wed'),
                  _buildDayHeader('Thu'),
                  _buildDayHeader('Fri'),
                  _buildDayHeader('Sat'),
                  _buildDayHeader('Sun'),
                ],
              ),
            ),

            Divider(color: ColorStyles.neutral300),

            ..._calendarDays.asMap().entries.map((entry) {
              // final weekIndex = entry.key;
              final week = entry.value;

              // Determine if this week has dates from the current month
              final hasCurrentMonthDates = week.any(
                (day) => day.month == _currentMonth.month,
              );

              return _buildCalendarWeek(
                week
                    .map(
                      (day) => _buildCalendarDay(
                        day.day.toString(),
                        _dateColors[day],
                        isSelected:
                            day.year == _selectedDate.year &&
                            day.month == _selectedDate.month &&
                            day.day == _selectedDate.day,
                        isHighlighted:
                            day.year == 2025 && day.month == 3 && day.day == 28,
                        isNextMonth: day.month > _currentMonth.month,
                        isPreviousMonth: day.month < _currentMonth.month,
                      ),
                    )
                    .toList(),
                hasBg: hasCurrentMonthDates,
              );
            }).toList(),

            SizedBox(height: 24.h),

            // Progress Report
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: ColorStyles.info100,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress Report',
                        style: TextStyles.heading2(
                          weight: FontWeightOption.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 20.sp,
                            color: ColorStyles.neutral700,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            DateFormat('d MMMM yyyy').format(_selectedDate),
                            style: TextStyles.body1(
                              weight: FontWeightOption.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  Divider(
                    color: ColorStyles.info300.withOpacity(0.3),
                    thickness: 1,
                  ),

                  // Blood Sugar Levels
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop,
                              color: ColorStyles.error500,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Blood Sugar Levels:',
                              style: TextStyles.heading4(
                                weight: FontWeightOption.semiBold,
                                color: ColorStyles.primary500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Your blood sugar is stable and within the normal range at 120 mg/dL.',
                          style: TextStyles.body1(),
                        ),
                      ],
                    ),
                  ),

                  // Recommendation
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 8.h),
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note,
                              color: ColorStyles.primary500,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Recommendation:',
                              style: TextStyles.heading4(
                                weight: FontWeightOption.semiBold,
                                color: ColorStyles.primary500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'If you successfully follow the dietary plan consistently for a week, you may lose 1 kg of your current weight and your blood sugar levels will stabilize.',
                          style: TextStyles.body1(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildDayHeader(String day) {
    return SizedBox(
      width: 40.w,
      child: Text(
        day,
        textAlign: TextAlign.center,
        style: TextStyles.body1(weight: FontWeightOption.semiBold),
      ),
    );
  }

  Widget _buildCalendarWeek(List<Widget> days, {bool hasBg = true}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration:
          hasBg
              ? BoxDecoration(
                color: ColorStyles.neutral100,
                borderRadius: BorderRadius.circular(16.r),
              )
              : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: days,
      ),
    );
  }

  Widget _buildCalendarDay(
    String day,
    Color? bgColor, {
    bool isSelected = false,
    bool isHighlighted = false,
    bool isNextMonth = false,
    bool isPreviousMonth = false,
  }) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: isSelected ? ColorStyles.primary300 : bgColor,
        shape: BoxShape.circle,
        border:
            isSelected
                ? Border.all(color: ColorStyles.primary500, width: 2)
                : null,
      ),
      child: Center(
        child: Text(
          day,
          style: TextStyles.body1(
            weight:
                isSelected || isHighlighted
                    ? FontWeightOption.bold
                    : FontWeightOption.regular,
            color:
                isNextMonth || isPreviousMonth
                    ? ColorStyles.neutral400
                    : isSelected
                    ? ColorStyles.white
                    : isHighlighted
                    ? ColorStyles.error500
                    : ColorStyles.black,
          ),
        ),
      ),
    );
  }
}
