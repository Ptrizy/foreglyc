import 'package:foreglyc/data/models/food_information_model.dart';

class FoodMonitoringResponse {
  final int status;
  final FoodMonitoringData data;
  final String message;

  FoodMonitoringResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory FoodMonitoringResponse.fromJson(Map<String, dynamic> json) {
    return FoodMonitoringResponse(
      status: json['status'],
      data: FoodMonitoringData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class FoodMonitoringData {
  final int id;
  final String foodName;
  final String mealTime;
  final String imageUrl;
  final List<Nutrition> nutritions;
  final int totalCalory;
  final int totalCarbohydrate;
  final int totalProtein;
  final int totalFat;
  final int glyecemicIndex;

  FoodMonitoringData({
    required this.id,
    required this.foodName,
    required this.mealTime,
    required this.imageUrl,
    required this.nutritions,
    required this.totalCalory,
    required this.totalCarbohydrate,
    required this.totalProtein,
    required this.totalFat,
    required this.glyecemicIndex,
  });

  factory FoodMonitoringData.fromJson(Map<String, dynamic> json) {
    return FoodMonitoringData(
      id: json['id'],
      foodName: json['foodName'],
      mealTime: json['mealTime'],
      imageUrl: json['imageUrl'],
      nutritions: List<Nutrition>.from(
        json['nutritions'].map((x) => Nutrition.fromJson(x)),
      ),
      totalCalory: json['totalCalory'],
      totalCarbohydrate: json['totalCarbohydrate'],
      totalProtein: json['totalProtein'],
      totalFat: json['totalFat'],
      glyecemicIndex: json['glyecemicIndex'],
    );
  }
}
