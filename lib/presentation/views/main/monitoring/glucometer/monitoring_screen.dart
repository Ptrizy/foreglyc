import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/models/home_model.dart';
import 'package:foreglyc/data/models/monitoring_model.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_bloc.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_event.dart';
import 'package:foreglyc/presentation/blocs/monitoring/monitoring_state.dart';
import 'package:fl_chart/fl_chart.dart';

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  bool _showDailyGraph = true;

  @override
  void initState() {
    super.initState();
    context.read<MonitoringBloc>().add(
      GetGlucometerMonitoringGraphEvent(_showDailyGraph ? 'daily' : 'hourly'),
    );
    context.read<MonitoringBloc>().add(GetGlucometerMonitoringEvent());
  }

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
      body: BlocConsumer<MonitoringBloc, MonitoringState>(
        listener: (context, state) {
          if (state is MonitoringError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Add Blood Sugar Check Results Button
                  GestureDetector(
                    onTap: () {
                      // Navigate to add blood sugar screen
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
                          Icon(
                            Icons.add,
                            color: ColorStyles.white,
                            size: 24.sp,
                          ),
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

                  // Graph Type Selector
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDailyGraph = true;
                            });
                            context.read<MonitoringBloc>().add(
                              GetGlucometerMonitoringGraphEvent('daily'),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color:
                                  _showDailyGraph
                                      ? ColorStyles.primary100
                                      : ColorStyles.neutral200,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Daily Graph',
                              style: TextStyles.body1(
                                weight: FontWeightOption.semiBold,
                                color:
                                    _showDailyGraph
                                        ? ColorStyles.primary700
                                        : ColorStyles.neutral700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDailyGraph = false;
                            });
                            context.read<MonitoringBloc>().add(
                              GetGlucometerMonitoringGraphEvent('hourly'),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            decoration: BoxDecoration(
                              color:
                                  !_showDailyGraph
                                      ? ColorStyles.primary100
                                      : ColorStyles.neutral200,
                              borderRadius: BorderRadius.all(
                                Radius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Hourly Graph',
                              style: TextStyles.body1(
                                weight: FontWeightOption.semiBold,
                                color:
                                    !_showDailyGraph
                                        ? ColorStyles.primary700
                                        : ColorStyles.neutral700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  // Graph Container
                  Container(
                    height: 300.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: ColorStyles.neutral300),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: _buildGraphContent(state),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Record Complications
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Record Complications',
                        style: TextStyles.heading3(),
                      ),
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

                  // Complications List
                  _buildComplicationsList(state),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBloodSugarChart(List<GlucoseMonitoringGraph> glucoseData) {
    if (glucoseData.isEmpty) {
      return Center(child: Text('No data available'));
    }

    final spots =
        glucoseData
            .asMap()
            .entries
            .map((entry) => FlSpot(entry.key.toDouble(), entry.value.value))
            .toList();

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 70,
          verticalInterval: 1,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < glucoseData.length) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      glucoseData[index].label,
                      style: TextStyles.body3(
                        fontSize: 11.38,
                        color: ColorStyles.neutral600,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 70,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyles.body3(
                    fontSize: 9.5,
                    color: ColorStyles.neutral600,
                  ),
                );
              },
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (glucoseData.length - 1).toDouble(),
        minY: 0,
        maxY: 350,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: ColorStyles.primary500,
            barWidth: 0,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: ColorStyles.primary500,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
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
                return LineTooltipItem(
                  '${barSpot.y.toInt()} mg/dL',
                  TextStyles.body3(
                    color: ColorStyles.white,
                    weight: FontWeightOption.semiBold,
                  ),
                );
              }).toList();
            },
          ),
        ),
        backgroundColor: Colors.white,
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 70,
              color: Colors.red.withOpacity(0.3),
              strokeWidth: 2,
            ),
            HorizontalLine(
              y: 140,
              color: Colors.green.withOpacity(0.3),
              strokeWidth: 2,
            ),
            HorizontalLine(
              y: 210,
              color: Colors.red.withOpacity(0.3),
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraphContent(MonitoringState state) {
    if (state is MonitoringGraphLoaded) {
      return _buildBloodSugarChart(state.response.data);
    } else if (state is MonitoringLoading && state.isGraphLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is MonitoringError && state.isGraphError) {
      return Center(child: Text('Failed to load graph data'));
    } else {
      return Center(child: Text('No graph data available'));
    }
  }

  Widget _buildComplicationsList(MonitoringState state) {
    if (state is MonitoringListLoaded) {
      return _buildComplicationItems(state.response.data);
    } else if (state is MonitoringLoading && state.isListLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (state is MonitoringError && state.isListError) {
      return Center(child: Text('Failed to load complications data'));
    } else {
      return Center(child: Text('No complications data available'));
    }
  }

  Widget _buildComplicationItems(List<GlucoseMonitoringData> complications) {
    if (complications.isEmpty) {
      return Center(child: Text('No complications recorded'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: complications.length,
      separatorBuilder:
          (context, index) => Divider(color: ColorStyles.neutral300),
      itemBuilder: (context, index) {
        final complication = complications[index];
        final isHypo = complication.status.toLowerCase().contains('hypo');
        final color =
            isHypo
                ? (complication.isSafe
                    ? ColorStyles.error100
                    : ColorStyles.error500)
                : (complication.isSafe
                    ? ColorStyles.error100
                    : ColorStyles.error500);

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
                complication.bloodGlucose.toInt().toString(),
                style: TextStyles.heading3(
                  color:
                      complication.isSafe
                          ? ColorStyles.error700
                          : ColorStyles.white,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    complication.status,
                    style: TextStyles.body1(weight: FontWeightOption.semiBold),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    complication.isSafe ? 'Normal' : 'Warning',
                    style: TextStyles.body2(),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  complication.time,
                  style: TextStyles.body2(weight: FontWeightOption.semiBold),
                ),
                SizedBox(height: 4.h),
                Text(complication.date, style: TextStyles.body2()),
              ],
            ),
          ],
        );
      },
    );
  }
}
