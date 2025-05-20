// lib/presentation/views/main/dietary/dietary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/models/food_home_model.dart';
import 'package:foreglyc/presentation/blocs/dietary/dietary_bloc.dart';
import 'package:foreglyc/presentation/views/main/dietary/food_recall_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DietaryScreen extends StatefulWidget {
  const DietaryScreen({super.key});

  @override
  State<DietaryScreen> createState() => _DietaryScreenState();
}

class _DietaryScreenState extends State<DietaryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DietaryBloc>().add(LoadDietaryData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyles.white,
      appBar: AppBar(
        backgroundColor: ColorStyles.white,
        elevation: 0,
        title: Text(
          'Dietary Plan',
          style: TextStyles.heading2(),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<DietaryBloc, DietaryState>(
        builder: (context, state) {
          if (state is DietaryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DietaryError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is DietaryLoaded) {
            return _buildContent(state.foodHomeData);
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
    );
  }

  Widget _buildContent(FoodHomeData foodHomeData) {
    // Calculate total consumed nutrition from all meals
    final totalConsumedCarbs = foodHomeData.dailyFoodResponses.fold<int>(
      0,
      (sum, meal) => sum + (meal.foodMonitoring.totalCarbohydrate),
    );

    final totalConsumedFat = foodHomeData.dailyFoodResponses.fold<int>(
      0,
      (sum, meal) => sum + (meal.foodMonitoring.totalFat),
    );

    final totalConsumedProtein = foodHomeData.dailyFoodResponses.fold<int>(
      0,
      (sum, meal) => sum + (meal.foodMonitoring.totalProtein),
    );

    final totalConsumedCalories = foodHomeData.dailyFoodResponses.fold<int>(
      0,
      (sum, meal) => sum + (meal.foodMonitoring.totalCalory),
    );

    // Nutrition data with comparison to daily goals
    final Map<String, Map<String, dynamic>> nutrition = {
      'Carbs': {
        'current': totalConsumedCarbs,
        'total': foodHomeData.totalCarbohydrate,
        'color': ColorStyles.primary500,
      },
      'Fat': {
        'current': totalConsumedFat,
        'total': foodHomeData.totalFat,
        'color': ColorStyles.primary500,
      },
      'Protein': {
        'current': totalConsumedProtein,
        'total': foodHomeData.totalProtein,
        'color': ColorStyles.primary500,
      },
    };

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: ColorStyles.neutral300),

          // Meal Schedule and Nutrition
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                // Meal Schedule Circle
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 120.r,
                      lineWidth: 20.w,
                      percent: 0.6,
                      backgroundColor: ColorStyles.neutral200,
                      progressColor: ColorStyles.primary500,
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Follow Your',
                            style: TextStyles.body1(
                              weight: FontWeightOption.semiBold,
                            ),
                          ),
                          Text(
                            'Meal Schedule!',
                            style: TextStyles.body1(
                              weight: FontWeightOption.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Time indicators
                    Positioned(
                      top: 0,
                      child: _buildTimeIndicator('12.00', true),
                    ),
                    Positioned(
                      right: 0,
                      child: _buildTimeIndicator('15.00', true),
                    ),
                    Positioned(
                      bottom: 0,
                      child: _buildTimeIndicator('18.00', false),
                    ),
                    Positioned(
                      left: 0,
                      child: _buildTimeIndicator('09.00', true),
                    ),
                    Positioned(
                      bottom: 40.h,
                      left: 20.w,
                      child: _buildTimeIndicator('06.00', true),
                    ),
                  ],
                ),

                SizedBox(height: 24.h),

                // Nutrition Bars
                Column(
                  children:
                      nutrition.entries.map((entry) {
                        final name = entry.key;
                        final data = entry.value;
                        final current = data['current'] as int;
                        final total = data['total'] as int;
                        final color = data['color'] as Color;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyles.body1(
                                      weight: FontWeightOption.semiBold,
                                    ),
                                  ),
                                  Text(
                                    '$current/$total g',
                                    style: TextStyles.body2(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4.h),
                              LinearPercentIndicator(
                                lineHeight: 8.h,
                                percent: current / total,
                                backgroundColor: ColorStyles.neutral200,
                                progressColor: color,
                                barRadius: Radius.circular(4.r),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),

                SizedBox(height: 16.h),

                // Calories and Insulin
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorStyles.neutral300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${foodHomeData.totalCalory} Kcal',
                              style: TextStyles.heading3(),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.eco,
                                  color: Colors.green,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text('Consumed', style: TextStyles.body2()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: ColorStyles.neutral300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '${foodHomeData.totalInsuline} Unit',
                              style: TextStyles.heading3(),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: ColorStyles.primary500,
                                  size: 16.sp,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Insulin Required',
                                  style: TextStyles.body2(),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Update Insulin Dose Button
                GestureDetector(
                  onTap: () {
                    // Handle insulin dose update
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: ColorStyles.primary500),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.medical_services_outlined,
                          color: ColorStyles.primary500,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Update Insulin Dose',
                          style: TextStyles.button1(
                            color: ColorStyles.primary500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Today's Intake
          _buildTodaysIntake(
            foodHomeData.dailyFoodResponses,
            foodHomeData.totalCalory,
          ),

          SizedBox(height: 24.h),

          // Nutritionist Certification
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nutritionist Certification',
                  style: TextStyles.heading3(),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20.r,
                      backgroundImage: AssetImage('assets/desfira.png'),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Desfira Risma M.Gizi, Sp.GK',
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // AI Help
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
                    'How can ForeGlyc calculate my calorie needs?',
                    style: TextStyles.body1(weight: FontWeightOption.semiBold),
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        // Handle AI help
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Ask Fore-AI now',
                            style: TextStyles.body2(
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
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 80.h), // Extra space for bottom navigation
        ],
      ),
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
                          showAddButton: !hasFoodData,
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

  Widget _buildTimeIndicator(String time, bool isActive) {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: BoxDecoration(
        color: isActive ? ColorStyles.primary500 : ColorStyles.neutral200,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        time,
        style: TextStyles.body3(
          color: isActive ? ColorStyles.white : ColorStyles.neutral700,
          weight: FontWeightOption.semiBold,
        ),
      ),
    );
  }
}
