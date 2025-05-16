import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/models/blood_sugar_record_model.dart';
import 'package:foreglyc/data/models/complication_record_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({Key? key}) : super(key: key);

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool _showDailyGraph = true;

  final List<BloodSugarRecord> _records = [
    BloodSugarRecord(
      value: 100,
      timestamp: DateTime(2025, 5, 15, 5, 0),
      type: 'normal',
      severity: 'normal',
    ),
    BloodSugarRecord(
      value: 90,
      timestamp: DateTime(2025, 5, 15, 7, 0),
      type: 'normal',
      severity: 'normal',
    ),
    BloodSugarRecord(
      value: 125,
      timestamp: DateTime(2025, 5, 15, 12, 0),
      type: 'normal',
      severity: 'normal',
    ),
    BloodSugarRecord(
      value: 95,
      timestamp: DateTime(2025, 5, 15, 18, 0),
      type: 'normal',
      severity: 'normal',
    ),
    BloodSugarRecord(
      value: 130,
      timestamp: DateTime(2025, 5, 15, 21, 0),
      type: 'normal',
      severity: 'normal',
    ),
  ];

  final List<ComplicationRecord> _complications = [
    ComplicationRecord(
      value: 65,
      type: 'Hypoglycemia',
      severity: 'Chronic',
      timestamp: DateTime(2025, 4, 6, 15, 0),
    ),
    ComplicationRecord(
      value: 320,
      type: 'Hyperglycemia',
      severity: 'Acute',
      timestamp: DateTime(2025, 3, 21, 8, 0),
    ),
    ComplicationRecord(
      value: 210,
      type: 'Hyperglycemia',
      severity: 'Chronic',
      timestamp: DateTime(2025, 2, 4, 10, 0),
    ),
    ComplicationRecord(
      value: 37,
      type: 'Hypoglycemia',
      severity: 'Acute',
      timestamp: DateTime(2025, 1, 8, 21, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: AppBar(
        backgroundColor: ColorStyles.white,
        elevation: 0,
        title: Text(
          'Monitoring',
          style: TextStyles.heading2(),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to add blood sugar screen
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => AddBloodSugarScreen(),
                  //   ),
                  // );
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: ColorStyles.primary500,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: ColorStyles.white, size: 24.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'Blood Sugar Check Results',
                        style: TextStyles.button1(color: ColorStyles.white),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Text('Blood Sugar Level Graph', style: TextStyles.heading3()),

              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showDailyGraph = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color:
                              _showDailyGraph
                                  ? ColorStyles.neutral200
                                  : ColorStyles.primary100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.r),
                            bottomLeft: Radius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Daily Graph',
                          style: TextStyles.body1(
                            weight: FontWeightOption.semiBold,
                            color:
                                _showDailyGraph
                                    ? ColorStyles.neutral700
                                    : ColorStyles.primary700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _showDailyGraph = false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color:
                              !_showDailyGraph
                                  ? ColorStyles.neutral200
                                  : ColorStyles.primary100,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12.r),
                            bottomRight: Radius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'Hourly Graph',
                          style: TextStyles.body1(
                            weight: FontWeightOption.semiBold,
                            color:
                                !_showDailyGraph
                                    ? ColorStyles.neutral700
                                    : ColorStyles.primary700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              Container(
                height: 300.h,
                decoration: BoxDecoration(
                  border: Border.all(color: ColorStyles.neutral300),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: true,
                        horizontalInterval: 70,
                        verticalInterval: 1,
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: 1,
                            getTitlesWidget: bottomTitleWidgets,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 70,
                            getTitlesWidget: leftTitleWidgets,
                            reservedSize: 40,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: true,
                        border: Border.all(color: ColorStyles.neutral300),
                      ),
                      minX: 0,
                      maxX: _records.length.toDouble() - 1,
                      minY: 0,
                      maxY: 350,
                      lineBarsData: [
                        LineChartBarData(
                          spots: List.generate(_records.length, (index) {
                            return FlSpot(
                              index.toDouble(),
                              _records[index].value,
                            );
                          }),
                          isCurved: false,
                          color: ColorStyles.primary500,
                          barWidth: 2,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: 6,
                                color: ColorStyles.primary500,
                                strokeWidth: 0,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(show: false),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                            return touchedBarSpots.map((barSpot) {
                              final index = barSpot.x.toInt();
                              return LineTooltipItem(
                                '${_records[index].value.toInt()} mg/dL',
                                TextStyles.body3(color: ColorStyles.white),
                              );
                            }).toList();
                          },
                        ),
                      ),
                      extraLinesData: ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: 70,
                            color: ColorStyles.error400.withOpacity(0.3),
                            strokeWidth: 1,
                          ),
                          HorizontalLine(
                            y: 180,
                            color: ColorStyles.error400.withOpacity(0.3),
                            strokeWidth: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Record Complications', style: TextStyles.heading3()),
                  GestureDetector(
                    onTap: () {
                      // Navigate to view details
                    },
                    child: Text(
                      'View Details',
                      style: TextStyles.body2(
                        color: ColorStyles.primary500,
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16.h),

              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _complications.length,
                separatorBuilder:
                    (context, index) => Divider(color: ColorStyles.neutral300),
                itemBuilder: (context, index) {
                  final complication = _complications[index];
                  final isHypo = complication.type == 'Hypoglycemia';
                  final color =
                      isHypo
                          ? (complication.severity == 'Acute'
                              ? ColorStyles.error500
                              : ColorStyles.error100)
                          : (complication.severity == 'Acute'
                              ? ColorStyles.error500
                              : ColorStyles.error100);

                  return Row(
                    children: [
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          complication.value.toInt().toString(),
                          style: TextStyles.heading3(
                            color:
                                isHypo
                                    ? (complication.severity == 'Acute'
                                        ? ColorStyles.white
                                        : ColorStyles.error700)
                                    : (complication.severity == 'Acute'
                                        ? ColorStyles.white
                                        : ColorStyles.error700),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              complication.type,
                              style: TextStyles.body1(
                                weight: FontWeightOption.semiBold,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              complication.severity,
                              style: TextStyles.body2(),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            DateFormat('HH.mm').format(complication.timestamp),
                            style: TextStyles.body2(
                              weight: FontWeightOption.semiBold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            DateFormat('d MMMM').format(complication.timestamp),
                            style: TextStyles.body2(),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    String text = '';
    if (value.toInt() < _records.length) {
      final hour = _records[value.toInt()].timestamp.hour;
      text = '$hour:00';
    }
    return Text(text, style: TextStyles.body3(), textAlign: TextAlign.center);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      value.toInt().toString(),
      style: TextStyles.body3(),
      textAlign: TextAlign.right,
    );
  }
}
