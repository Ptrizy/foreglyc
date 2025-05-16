import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foreglyc/core/styles/color.dart';
import 'package:foreglyc/core/styles/text.dart';
import 'package:foreglyc/presentation/views/main/dietary/menu_analysis_screen.dart';
import 'package:image_picker/image_picker.dart';

class FoodRecallScreen extends StatefulWidget {
  final String mealType;
  final String currentFood;
  final Function(String) onFoodUpdated;

  const FoodRecallScreen({
    Key? key,
    required this.mealType,
    required this.currentFood,
    required this.onFoodUpdated,
  }) : super(key: key);

  @override
  State<FoodRecallScreen> createState() => _FoodRecallScreenState();
}

class _FoodRecallScreenState extends State<FoodRecallScreen> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

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
          'Food Recall',
          style: TextStyles.heading3(),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Meal Type
              Text(widget.mealType, style: TextStyles.heading2()),
              SizedBox(height: 8.h),
              Text(
                'Current food: ${widget.currentFood}',
                style: TextStyles.body1(),
              ),
              SizedBox(height: 24.h),

              // Instructions
              Container(
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  color: ColorStyles.primary100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Take a photo of your food',
                      style: TextStyles.body1(
                        weight: FontWeightOption.semiBold,
                        color: ColorStyles.primary700,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Our AI will analyze the nutritional content of your meal.',
                      style: TextStyles.body2(color: ColorStyles.primary700),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Image Preview or Placeholder
              if (_imageFile != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    _imageFile!,
                    width: double.infinity,
                    height: 300.h,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: ColorStyles.neutral200,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: ColorStyles.neutral300),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        size: 64.sp,
                        color: ColorStyles.neutral500,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'No image selected',
                        style: TextStyles.body1(color: ColorStyles.neutral500),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 24.h),

              // Camera and Gallery Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: _takePicture,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: ColorStyles.primary500,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: ColorStyles.white),
                            SizedBox(width: 8.w),
                            Text(
                              'Take Photo',
                              style: TextStyles.button1(
                                color: ColorStyles.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: _pickFromGallery,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        decoration: BoxDecoration(
                          color: ColorStyles.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: ColorStyles.primary500),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library,
                              color: ColorStyles.primary500,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Gallery',
                              style: TextStyles.button1(
                                color: ColorStyles.primary500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              // Analyze Button
              GestureDetector(
                onTap: _imageFile != null ? _analyzeFood : null,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color:
                        _imageFile != null
                            ? ColorStyles.primary500
                            : ColorStyles.neutral300,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Analyze Food',
                    style: TextStyles.button1(
                      color:
                          _imageFile != null
                              ? ColorStyles.white
                              : ColorStyles.neutral500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
  }

  void _analyzeFood() {
    if (_imageFile != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => MenuAnalysisScreen(
                imageFile: _imageFile!,
                mealType: widget.mealType,
                onSave: (foodName) {
                  widget.onFoodUpdated(foodName);
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
        ),
      );
    }
  }
}
