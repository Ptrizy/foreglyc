import 'dart:io';

import 'package:foreglyc/data/models/file_model.dart';
import 'package:foreglyc/data/models/food_information_model.dart';
import 'package:foreglyc/data/models/food_monitoring_model.dart';

abstract class DietaryRepository {
  Future<FileUploadResponse> uploadFile(File file);
  Future<FoodInformationResponse> generateFoodInformation({
    required String mealTime,
    required String imageUrl,
  });
  Future<FoodMonitoringResponse> createFoodMonitoring({
    required String foodName,
    required String mealTime,
    required String imageUrl,
    required List<Nutrition> nutritions,
    required int totalCalory,
    required int totalCarbohydrate,
    required int totalProtein,
    required int totalFat,
    required int glyecemicIndex,
  });
}
