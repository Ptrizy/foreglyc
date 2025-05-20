import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:foreglyc/data/models/home_model.dart';
import 'package:foreglyc/presentation/blocs/home/home_bloc.dart';
import 'package:foreglyc/presentation/views/main/dietary/food_recall_screen.dart';
import 'package:foreglyc/presentation/views/main/home/glucose_prediction_ai/blood_sugar_prediction_screen.dart';
import 'package:foreglyc/presentation/views/main/home/services/fore_ai/fore_ai_screen.dart';
import 'package:foreglyc/presentation/views/main/home/services/fore_log/glucose_tracking_popup.dart';
import 'package:foreglyc/presentation/views/main/home/services/journey/journey_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchHomeData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return _buildLoadingState();
            } else if (state is HomeError) {
              return _buildErrorState(state.message);
            } else if (state is HomeLoaded) {
              return _buildLoadedState(state.response.data);
            }
            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(color: ColorStyles.primary500),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Something went wrong',
            style: TextStyles.body1(weight: FontWeightOption.semiBold),
          ),
          SizedBox(height: 8.h),
          Text(message, style: TextStyles.body3(color: ColorStyles.neutral700)),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              context.read<HomeBloc>().add(FetchHomeData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyles.primary500,
              foregroundColor: Colors.white,
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(HomeData data) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(gradient: ColorStyles.gradient1),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: SvgPicture.asset('assets/eclipse_home.svg', width: 248.w),
        ),

        _buildHeader(data),

        Positioned(
          top: 108.h,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBloodSugarReport(data.glucoseMonitoringGraphs),
                  _buildServices(),
                  _buildTodaysIntake(data.dailyFoodResponses, data.totalCalory),
                  _buildQuestions(),
                  _buildForeGlycServices(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(HomeData data) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25.r,
              backgroundImage:
                  data.photoProfile.isNotEmpty
                      ? NetworkImage(data.photoProfile) as ImageProvider
                      : const AssetImage('assets/default_profile.png'),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.fullName.length > 10
                        ? '${data.fullName.substring(0, 10)}...'
                        : data.fullName,
                    style: TextStyles.heading2(
                      color: Colors.white,
                      weight: FontWeightOption.semiBold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFD1E3FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '🏆 ${data.level}',
                          style: TextStyles.body3(
                            fontSize: 12,
                            color: ColorStyles.primary500,
                            weight: FontWeightOption.semiBold,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        SvgPicture.asset(
                          'assets/icons/CaretLeft.svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/icons/notif.svg',
                width: 24.w,
                height: 24.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBloodSugarReport(List<GlucoseMonitoringGraph> glucoseData) {
    String status = 'Normal';
    Color statusColor = Colors.green;

    if (glucoseData.isNotEmpty) {
      final latestValue = glucoseData.last.value;
      if (latestValue < 70) {
        status = 'Low';
        statusColor = Colors.red;
      } else if (latestValue > 180) {
        status = 'High';
        statusColor = Colors.red;
      }
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 16.w,
        right: 16.w,
        bottom: 16.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Blood Sugar Level Report',
            style: TextStyles.body1(
              fontSize: 18,
              weight: FontWeightOption.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Text(
                'Blood Sugar Level Status',
                style: TextStyles.body3(color: ColorStyles.neutral700),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status,
                  style: TextStyles.body3(
                    fontSize: 12,
                    color: statusColor,
                    weight: FontWeightOption.semiBold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(height: 200.h, child: _buildBloodSugarChart(glucoseData)),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          BloodSugarPredictionScreen(glucoseData: glucoseData),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyles.primary500,
              foregroundColor: Colors.white,
              minimumSize: Size(double.infinity, 36.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'View Blood Sugar Status Prediction',
              style: TextStyles.body2(
                color: Colors.white,
                weight: FontWeightOption.semiBold,
              ),
            ),
          ),
        ],
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

  Widget _buildServices() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Services',
            style: TextStyles.heading4(weight: FontWeightOption.semiBold),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildServiceItem(
                imagePath: 'assets/services_fore_ai.svg',
                label: 'Fore-AI',
              ),
              _buildServiceItem(
                imagePath: 'assets/services_fore_log.svg',
                label: 'Fore-Log',
              ),
              _buildServiceItem(
                imagePath: 'assets/services_journey.svg',
                label: 'Journey',
              ),
            ],
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildServiceItem({required String imagePath, required String label}) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            switch (label) {
              case 'Fore-AI':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ForeAIScreen()),
                );
                break;
              case 'Journey':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const JourneyScreen(),
                  ),
                );
                break;
              case 'Fore-Log':
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder:
                      (context) => Dialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: GlucoseTrackingPopup(),
                        ),
                      ),
                );
                break;
            }
          },
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            children: [
              SizedBox(
                width: 56.w,
                height: 56.w,
                child: SvgPicture.asset(imagePath, fit: BoxFit.fill),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyles.body3(weight: FontWeightOption.semiBold),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTodaysIntake(
    List<DailyFoodResponse> dailyFoods,
    int totalCalories,
  ) {
    final currentHour = TimeOfDay.now().hour;
    // Assuming a target of 1400 calories, but this should come from the API
    final targetCalories = 1400;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Today\'s Intake',
                style: TextStyles.body1(
                  fontSize: 18,
                  weight: FontWeightOption.semiBold,
                ),
              ),
              const Spacer(),
              Text(
                '${totalCalories}Kcal / ${targetCalories}Kcal',
                style: TextStyles.body3(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF27272A).withOpacity(0.15),
                  blurRadius: 8,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              children:
                  dailyFoods.isEmpty
                      ? [Center(child: Text('No meal data available'))]
                      : dailyFoods.map((meal) {
                        final hasFoodData =
                            meal.foodMonitoring?.foodName?.isNotEmpty == true ||
                            meal.foodRecomendation?.foodName?.isNotEmpty ==
                                true;

                        return _buildMealItem(
                          mealType: meal.mealTime,
                          foodName:
                              hasFoodData
                                  ? meal.foodMonitoring?.foodName ??
                                      meal.foodRecomendation?.foodName ??
                                      'No meal data'
                                  : 'No meal data',
                          time: meal.time,
                          timeHour: _parseTimeToHour(meal.time),
                          currentHour: TimeOfDay.now().hour,
                          imagePath:
                              hasFoodData
                                  ? meal.foodMonitoring?.imageUrl ??
                                      meal.foodRecomendation?.imageUrl ??
                                      _getDefaultMealImage(meal.mealTime)
                                  : _getDefaultMealImage(meal.mealTime),
                          showAddButton:
                              !hasFoodData, // Selalu aktif jika tidak ada data
                          isNetworkImage:
                              hasFoodData &&
                              (meal.foodMonitoring?.imageUrl?.isNotEmpty ==
                                      true ||
                                  meal
                                          .foodRecomendation
                                          ?.imageUrl
                                          ?.isNotEmpty ==
                                      true),
                        );
                      }).toList(),
            ),
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  int _parseTimeToHour(String time) {
    final parts = time.split(' ');
    final hour = int.tryParse(parts[0]) ?? 0;
    final isPM = parts.length > 1 && parts[1].toUpperCase() == 'PM';
    return isPM && hour != 12 ? hour + 12 : hour;
  }

  // Helper method to determine the next meal time that needs input
  int _getNextMealTimeHour(List<DailyFoodResponse> meals, int currentHour) {
    final List<int> futureMealHours =
        meals
            .where(
              (meal) =>
                  meal.foodMonitoring == null && meal.foodRecomendation == null,
            )
            .map((meal) => _getMealTimeHour(meal.mealTime))
            .where((hour) => hour > currentHour)
            .toList();

    return futureMealHours.isEmpty ? 0 : futureMealHours.reduce(min);
  }

  // Helper to get meal time hour
  int _getMealTimeHour(String mealTime) {
    switch (mealTime) {
      case 'Breakfast':
        return 6;
      case 'Morning Snack':
        return 9;
      case 'Lunch':
        return 12;
      case 'Afternoon Snack':
        return 15;
      case 'Dinner':
        return 18;
      default:
        return 0;
    }
  }

  // Helper to get default meal image based on meal type
  String _getDefaultMealImage(String mealTime) {
    switch (mealTime) {
      case 'Breakfast':
        return 'assets/breakfast.png';
      case 'Morning Snack':
        return 'assets/morning_snack.png';
      case 'Lunch':
        return 'assets/lunch.png';
      case 'Afternoon Snack':
        return 'assets/afternoon_snack.png';
      case 'Dinner':
        return 'assets/dinner.png';
      default:
        return 'assets/breakfast.png';
    }
  }

  Widget _buildMealItem({
    required String mealType,
    required String foodName,
    required String time,
    required int timeHour,
    required int currentHour,
    required String imagePath,
    bool showAddButton = false,
    bool isNetworkImage = false,
  }) {
    final bool isPastMeal = timeHour <= currentHour;
    final Color timeBackgroundColor =
        isPastMeal ? ColorStyles.primary100 : ColorStyles.neutral100;
    final Color timeTextColor =
        isPastMeal ? ColorStyles.primary500 : ColorStyles.neutral700;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child:
                isNetworkImage
                    ? Image.network(
                      imagePath,
                      width: 60.w,
                      height: 60.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          _getDefaultMealImage(mealType),
                          width: 60.w,
                          height: 60.w,
                          fit: BoxFit.cover,
                        );
                      },
                    )
                    : SvgPicture.asset(
                      'assets/icons/default_null_menu.svg',
                      width: 60.w,
                      height: 60.h,
                    ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType,
                  style: TextStyles.body2(weight: FontWeightOption.semiBold),
                ),
                SizedBox(height: 4.h),
                Text(foodName, style: TextStyles.body3()),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: timeBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              time,
              style: TextStyles.body3(
                color: timeTextColor,
                weight: FontWeightOption.semiBold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          InkWell(
            onTap:
                showAddButton
                    ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => FoodRecallScreen(
                                mealType: mealType,
                                currentFood: foodName,
                                onFoodUpdated: (newFood) {},
                              ),
                        ),
                      );
                    }
                    : null,
            child:
                showAddButton
                    ? SvgPicture.asset(
                      'assets/icons/camera_active.svg',
                      width: 24.w,
                      height: 24.h,
                    )
                    : SvgPicture.asset(
                      'assets/icons/camera_inactive.svg',
                      width: 24.w,
                      height: 24.h,
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 110.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 280.w,
                  child: _buildQuestionCard(
                    question:
                        'Why should I consistently follow the dietary plan?',
                    onTap: () {},
                  ),
                ),
                SizedBox(width: 12.w),
                SizedBox(
                  width: 280.w,
                  child: _buildQuestionCard(
                    question: 'How can ForeGlyc calculate my calorie needs?',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildQuestionCard({
    required String question,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorStyles.primary100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(width: 1.w, color: Color(0xFFB2D1FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyles.body1(
              color: Color(0xFF100F33),
              weight: FontWeightOption.semiBold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ask Fore-AI now',
                  style: TextStyles.body3(
                    color: ColorStyles.primary500,
                    weight: FontWeightOption.semiBold,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_forward,
                  color: ColorStyles.primary500,
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForeGlycServices() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(width: 1.w, color: Color(0xFFD1E3FF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "💡 ForeGlyc's services are expert-tested",
                style: TextStyles.body2(
                  color: ColorStyles.primary500,
                  weight: FontWeightOption.semiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Image.asset('assets/experts.png', width: 80.w, height: 40.h),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildServiceFeature(
                      icon: Icons.calculate_outlined,
                      label: 'Dietary Plan Calculation',
                    ),
                    SizedBox(height: 8.h),
                    _buildServiceFeature(
                      icon: Icons.trending_up_outlined,
                      label: 'Blood Sugar Prediction',
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: ColorStyles.primary500, thickness: 3.h, indent: 0),
        ],
      ),
    );
  }

  Widget _buildServiceFeature({required IconData icon, required String label}) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            color: ColorStyles.primary100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: ColorStyles.primary500, size: 14.sp),
        ),
        SizedBox(width: 8.w),
        Text(label, style: TextStyles.body3(weight: FontWeightOption.semiBold)),
      ],
    );
  }
}

// Helper function to find minimum value
int min(int a, int b) => a < b ? a : b;
