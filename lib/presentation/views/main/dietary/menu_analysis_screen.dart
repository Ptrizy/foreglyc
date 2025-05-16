import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/data/models/food_information_model.dart';
import 'package:foreglyc/presentation/blocs/food_recall/food_recall_bloc.dart';

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
  final TextEditingController _otherIngredientsController =
      TextEditingController();
  FoodInformationData? _foodInformation;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Listen for generated food information
    _listenForFoodInformation();
  }

  void _listenForFoodInformation() {
    final bloc = context.read<FoodRecallBloc>();
    if (bloc.state is FoodInformationGenerated) {
      setState(() {
        _foodInformation =
            (bloc.state as FoodInformationGenerated).foodInformation;
      });
    }

    bloc.stream.listen((state) {
      if (state is FoodInformationGenerated) {
        setState(() {
          _foodInformation = state.foodInformation;
        });
      } else if (state is FoodMonitoringCreated) {
        widget.onSave(state.foodMonitoring.foodName);
      }
    });
  }

  @override
  void dispose() {
    _otherIngredientsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodRecallBloc, FoodRecallState>(
      listener: (context, state) {
        if (state is FoodRecallError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
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

                if (_foodInformation == null)
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16.h),
                          Text('Analyzing your food...'),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      // Food Name
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Text(
                          _foodInformation!.foodName,
                          style: TextStyles.heading2(),
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Nutrition Categories
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _foodInformation!.nutritions.length,
                        itemBuilder: (context, index) {
                          final nutrition = _foodInformation!.nutritions[index];
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
                                    Text(
                                      _getNutritionIcon(nutrition.type),
                                      style: TextStyle(fontSize: 18.sp),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      nutrition.type,
                                      style: TextStyles.body1(
                                        weight: FontWeightOption.semiBold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8.h),

                              // Nutrition Items
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: nutrition.components.length,
                                itemBuilder: (context, subIndex) {
                                  final component =
                                      nutrition.components[subIndex];
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 8.h,
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(16.r),
                                      decoration: BoxDecoration(
                                        color: ColorStyles.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
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
                                                  component.name,
                                                  style: TextStyles.body1(
                                                    weight:
                                                        FontWeightOption
                                                            .semiBold,
                                                  ),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  '${component.calory} Kcal',
                                                  style: TextStyles.body2(),
                                                ),
                                                SizedBox(height: 4.h),
                                                Text(
                                                  'Portion: ${component.portion}${component.unit}',
                                                  style: TextStyles.body2(),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (_isEditing)
                                            Container(
                                              padding: EdgeInsets.all(8.r),
                                              decoration: BoxDecoration(
                                                color: ColorStyles.primary500,
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
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

                      // Other Ingredients
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
                            Text('📝', style: TextStyle(fontSize: 18.sp)),
                            SizedBox(width: 8.w),
                            Text(
                              'Other Ingredients',
                              style: TextStyles.body1(
                                weight: FontWeightOption.semiBold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 8.h),
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
                      ),
                      SizedBox(height: 16.h),

                      // Total Nutrition
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
                                    Icon(
                                      Icons.restaurant,
                                      color: ColorStyles.white,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Nutrition Summary',
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
                                child: Column(
                                  children: [
                                    _buildNutritionRow(
                                      'Total Calories',
                                      '${_foodInformation!.totalCalory} Kcal',
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildNutritionRow(
                                      'Carbohydrates',
                                      '${_foodInformation!.totalCarbohydrate}g',
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildNutritionRow(
                                      'Protein',
                                      '${_foodInformation!.totalProtein}g',
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildNutritionRow(
                                      'Fat',
                                      '${_foodInformation!.totalFat}g',
                                    ),
                                    SizedBox(height: 8.h),
                                    _buildNutritionRow(
                                      'Glycemic Index',
                                      '${_foodInformation!.glyecemicIndex}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Edit and Save Buttons
                      Padding(
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isEditing = !_isEditing;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  decoration: BoxDecoration(
                                    color:
                                        _isEditing
                                            ? ColorStyles.neutral300
                                            : ColorStyles.primary500,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    _isEditing ? 'Cancel' : 'Edit',
                                    style: TextStyles.button1(
                                      color: ColorStyles.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: GestureDetector(
                                onTap:
                                    state is FoodRecallLoading
                                        ? null
                                        : () {
                                          context.read<FoodRecallBloc>().add(
                                            CreateFoodMonitoring(
                                              foodName:
                                                  _foodInformation!.foodName,
                                              mealTime: widget.mealType,
                                              imageUrl:
                                                  _foodInformation!.imageUrl,
                                              nutritions:
                                                  _foodInformation!.nutritions,
                                              totalCalory:
                                                  _foodInformation!.totalCalory,
                                              totalCarbohydrate:
                                                  _foodInformation!
                                                      .totalCarbohydrate,
                                              totalProtein:
                                                  _foodInformation!
                                                      .totalProtein,
                                              totalFat:
                                                  _foodInformation!.totalFat,
                                              glyecemicIndex:
                                                  _foodInformation!
                                                      .glyecemicIndex,
                                            ),
                                          );
                                        },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                  decoration: BoxDecoration(
                                    color:
                                        state is FoodRecallLoading
                                            ? ColorStyles.neutral300
                                            : ColorStyles.primary500,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  alignment: Alignment.center,
                                  child:
                                      state is FoodRecallLoading
                                          ? CircularProgressIndicator(
                                            color: ColorStyles.white,
                                          )
                                          : Text(
                                            'Save',
                                            style: TextStyles.button1(
                                              color: ColorStyles.white,
                                            ),
                                          ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNutritionRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.body1(color: ColorStyles.white)),
        Text(
          value,
          style: TextStyles.body1(
            color: ColorStyles.white,
            weight: FontWeightOption.semiBold,
          ),
        ),
      ],
    );
  }

  String _getNutritionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'carbohydrate':
        return '🌾';
      case 'protein':
        return '🍗';
      case 'fat':
        return '🧈';
      default:
        return '📝';
    }
  }
}
