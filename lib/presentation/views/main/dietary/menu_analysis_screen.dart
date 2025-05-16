import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';

class MenuAnalysisScreen extends StatefulWidget {
  final File imageFile;
  final String mealType;
  final Function(String) onSave;

  const MenuAnalysisScreen({
    super.key,
    required this.imageFile,
    required this.mealType,
    required this.onSave,
  });

  @override
  State<MenuAnalysisScreen> createState() => _MenuAnalysisScreenState();
}

class _MenuAnalysisScreenState extends State<MenuAnalysisScreen> {
  // Sample analysis data
  final List<Map<String, dynamic>> _analysisItems = [
    {
      'category': 'Carbohydrates',
      'icon': '🌾',
      'items': [
        {
          'name': 'Breading',
          'calories': '180Kcal / 250Kcal',
          'portion': 'Portion = 1 piece',
        },
      ],
    },
    {
      'category': 'Protein',
      'icon': '🍗',
      'items': [
        {
          'name': 'Chicken',
          'calories': '50Kcal / 80Kcal',
          'portion': 'Portion = 30-50 grams of small pieces',
        },
      ],
    },
    {
      'category': 'Fat',
      'icon': '🧈',
      'items': [
        {
          'name': 'Frying Oil',
          'calories': '40Kcal - 100Kcal',
          'portion': 'Portion = Absorbed by the chicken',
        },
      ],
    },
    {
      'category': 'Flavorings & Seasonings',
      'icon': '🧂',
      'items': [
        {
          'name': 'Sauce/Glaze',
          'calories': '20Kcal / 50Kcal',
          'portion': 'Portion = 1-2 tablespoons',
        },
      ],
    },
    {'category': 'Other', 'icon': '📝', 'items': []},
  ];

  final TextEditingController _otherIngredientsController =
      TextEditingController();

  @override
  void dispose() {
    _otherIngredientsController.dispose();
    super.dispose();
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
          'Menu Analysis Results',
          style: TextStyles.heading3(),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(color: ColorStyles.neutral300),

            // Food Image
            Padding(
              padding: EdgeInsets.all(16.r),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Image.file(
                  widget.imageFile,
                  width: double.infinity,
                  height: 150.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Analysis Items
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _analysisItems.length,
              itemBuilder: (context, index) {
                final item = _analysisItems[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: ColorStyles.primary100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Text(item['icon'], style: TextStyle(fontSize: 18.sp)),
                          SizedBox(width: 8.w),
                          Text(
                            item['category'],
                            style: TextStyles.body1(
                              weight: FontWeightOption.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 8.h),

                    // Category Items
                    if (item['category'] == 'Other')
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextField(
                          controller: _otherIngredientsController,
                          decoration: InputDecoration(
                            hintText: 'Enter additional ingredients not listed',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(
                                color: ColorStyles.neutral300,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 12.h,
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: item['items'].length,
                        itemBuilder: (context, subIndex) {
                          final subItem = item['items'][subIndex];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(16.r),
                              decoration: BoxDecoration(
                                color: ColorStyles.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: ColorStyles.neutral300,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          subItem['name'],
                                          style: TextStyles.body1(
                                            weight: FontWeightOption.semiBold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          subItem['calories'],
                                          style: TextStyles.body2(),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          subItem['portion'],
                                          style: TextStyles.body2(),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(8.r),
                                    decoration: BoxDecoration(
                                      color: ColorStyles.primary500,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: ColorStyles.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),

                    SizedBox(height: 16.h),
                  ],
                );
              },
            ),

            // Total Calories
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorStyles.primary500,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12.r),
                      child: Row(
                        children: [
                          Icon(Icons.restaurant, color: ColorStyles.white),
                          SizedBox(width: 8.w),
                          Text(
                            'Estimated Total Calories',
                            style: TextStyles.body1(
                              color: ColorStyles.white,
                              weight: FontWeightOption.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: ColorStyles.white.withOpacity(0.3),
                      height: 1,
                    ),
                    Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Text(
                        '300 - 500 calories',
                        style: TextStyles.heading3(color: ColorStyles.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Save Button
            Padding(
              padding: EdgeInsets.all(16.r),
              child: GestureDetector(
                onTap: () {
                  // Save the analysis and return to dietary screen
                  widget.onSave('Fried Chicken');
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
                    'Save',
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
}
