// lib/presentation/views/main/dietary/dietary_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/views/main/dietary/food_recall_screen.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class DietaryScreen extends StatefulWidget {
  const DietaryScreen({super.key});

  @override
  State<DietaryScreen> createState() => _DietaryScreenState();
}

class _DietaryScreenState extends State<DietaryScreen> {
  final List<Map<String, dynamic>> _meals = [
    {
      'type': 'Breakfast',
      'food': 'Ginger Boiled Chicken',
      'time': '6 AM',
      'gi': 50,
      'image': 'assets/breakfast.png',
    },
    {
      'type': 'Morning Snack',
      'food': 'Sweet Potato Pudding',
      'time': '9 AM',
      'gi': 50,
      'image': 'assets/morning_snack.png',
    },
    {
      'type': 'Lunch',
      'food': 'Fried Red Rice',
      'time': '12 AM',
      'gi': 50,
      'image': 'assets/lunch.png',
    },
    {
      'type': 'Afternoon Snack',
      'food': 'Beet Juice',
      'time': '3 PM',
      'gi': 50,
      'image': 'assets/afternoon_snack.png',
    },
    {
      'type': 'Dinner',
      'food': 'Steamed Tofu Rice',
      'time': '6 PM',
      'gi': 50,
      'image': 'assets/dinner.png',
    },
  ];

  // Nutrition data
  final Map<String, Map<String, dynamic>> _nutrition = {
    'Carbs': {'current': 27, 'total': 29, 'color': ColorStyles.primary500},
    'Fat': {'current': 40, 'total': 42, 'color': ColorStyles.primary500},
    'Protein': {'current': 32, 'total': 120, 'color': ColorStyles.primary500},
  };

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
      body: SingleChildScrollView(
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
                        _nutrition.entries.map((entry) {
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
                              Text('382 Kcal', style: TextStyles.heading3()),
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
                              Text('50 Unit', style: TextStyles.heading3()),
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Today\'s Intake', style: TextStyles.heading3()),
                  SizedBox(height: 8.h),
                  Text(
                    'Hi Alodia, your daily menu has been updated based on your latest lab results and reviewed by our nutritionist.',
                    style: TextStyles.body2(color: ColorStyles.neutral600),
                  ),
                  SizedBox(height: 16.h),

                  // Meals List
                  Container(
                    decoration: BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: ColorStyles.neutral300),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _meals.length,
                      separatorBuilder:
                          (context, index) =>
                              Divider(color: ColorStyles.neutral300),
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        return _buildMealItem(
                          type: meal['type'],
                          food: meal['food'],
                          time: meal['time'],
                          gi: meal['gi'],
                          image: meal['image'],
                          isLunch: meal['type'] == 'Lunch',
                          onTap: () {
                            if (meal['type'] == 'Lunch') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => FoodRecallScreen(
                                        mealType: meal['type'],
                                        currentFood: meal['food'],
                                        onFoodUpdated: (newFood) {
                                          setState(() {
                                            _meals[index]['food'] = newFood;
                                          });
                                        },
                                      ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
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
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                      ),
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
      ),
    );
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

  Widget _buildMealItem({
    required String type,
    required String food,
    required String time,
    required int gi,
    required String image,
    required bool isLunch,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: EdgeInsets.all(12.r),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.asset(
              image,
              width: 60.w,
              height: 60.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  type,
                  style: TextStyles.body1(weight: FontWeightOption.semiBold),
                ),
                SizedBox(height: 4.h),
                Text(food, style: TextStyles.body2()),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    '$gi GI',
                    style: TextStyles.body3(
                      color: Colors.green,
                      weight: FontWeightOption.semiBold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: ColorStyles.primary100,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              time,
              style: TextStyles.body3(
                color: ColorStyles.primary700,
                weight: FontWeightOption.semiBold,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color:
                    isLunch ? ColorStyles.primary500 : ColorStyles.neutral200,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                isLunch ? Icons.add : Icons.edit_off,
                color: isLunch ? ColorStyles.white : ColorStyles.neutral500,
                size: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
