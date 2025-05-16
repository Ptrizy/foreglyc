import 'package:equatable/equatable.dart';

class HomeResponse {
  final int status;
  final HomeData data;
  final String message;

  HomeResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) {
    return HomeResponse(
      status: json['status'],
      data: HomeData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class HomeData extends Equatable {
  final String fullName;
  final String photoProfile;
  final String level;
  final List<DailyFoodResponse> dailyFoodResponses;
  final List<GlucoseMonitoringGraph> glucoseMonitoringGraphs;
  final int totalCalory;
  final bool isGlucometerMonitoringPreferenceAvailable;
  final bool isCGMMonitoringPreferenceAvailable;

  const HomeData({
    required this.fullName,
    required this.photoProfile,
    required this.level,
    required this.dailyFoodResponses,
    required this.glucoseMonitoringGraphs,
    required this.totalCalory,
    required this.isGlucometerMonitoringPreferenceAvailable,
    required this.isCGMMonitoringPreferenceAvailable,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) {
    return HomeData(
      fullName: json['fullName'],
      photoProfile: json['photoProfile'],
      level: json['level'],
      dailyFoodResponses:
          (json['dailyFoodResponses'] as List)
              .map((item) => DailyFoodResponse.fromJson(item))
              .toList(),
      glucoseMonitoringGraphs:
          (json['glucoseMonitoringGraphs'] as List)
              .map((item) => GlucoseMonitoringGraph.fromJson(item))
              .toList(),
      totalCalory: json['totalCalory'],
      isGlucometerMonitoringPreferenceAvailable:
          json['isGlucometerMonitoringPreferenceAvailable'],
      isCGMMonitoringPreferenceAvailable:
          json['isCGMMonitoringPreferenceAvailable'],
    );
  }

  @override
  List<Object> get props => [
    fullName,
    photoProfile,
    level,
    dailyFoodResponses,
    glucoseMonitoringGraphs,
    totalCalory,
    isGlucometerMonitoringPreferenceAvailable,
    isCGMMonitoringPreferenceAvailable,
  ];
}

class DailyFoodResponse extends Equatable {
  final String mealTime;
  final String time;
  final FoodMonitoring? foodMonitoring;
  final FoodRecommendation? foodRecomendation;

  const DailyFoodResponse({
    required this.mealTime,
    required this.time,
    this.foodMonitoring,
    this.foodRecomendation,
  });

  factory DailyFoodResponse.fromJson(Map<String, dynamic> json) {
    return DailyFoodResponse(
      mealTime: json['mealTime'],
      time: json['time'],
      foodMonitoring:
          json['foodMonitoring'] != null
              ? FoodMonitoring.fromJson(json['foodMonitoring'])
              : null,
      foodRecomendation:
          json['foodRecomendation'] != null
              ? FoodRecommendation.fromJson(json['foodRecomendation'])
              : null,
    );
  }

  @override
  List<Object?> get props => [
    mealTime,
    time,
    foodMonitoring,
    foodRecomendation,
  ];
}

class FoodMonitoring extends Equatable {
  final int id;
  final String foodName;
  final String mealTime;
  final String imageUrl;
  final dynamic nutritions;
  final int totalCalory;
  final int totalCarbohydrate;
  final int totalFat;
  final int totalProtein;
  final int glyecemicIndex;

  const FoodMonitoring({
    required this.id,
    required this.foodName,
    required this.mealTime,
    required this.imageUrl,
    this.nutritions,
    required this.totalCalory,
    required this.totalCarbohydrate,
    required this.totalFat,
    required this.totalProtein,
    required this.glyecemicIndex,
  });

  factory FoodMonitoring.fromJson(Map<String, dynamic> json) {
    return FoodMonitoring(
      id: json['id'],
      foodName: json['foodName'],
      mealTime: json['mealTime'],
      imageUrl: json['imageUrl'],
      nutritions: json['nutritions'],
      totalCalory: json['totalCalory'],
      totalCarbohydrate: json['totalCarbohydrate'],
      totalFat: json['totalFat'],
      totalProtein: json['totalProtein'],
      glyecemicIndex: json['glyecemicIndex'],
    );
  }

  @override
  List<Object> get props => [
    id,
    foodName,
    mealTime,
    imageUrl,
    totalCalory,
    totalCarbohydrate,
    totalFat,
    totalProtein,
    glyecemicIndex,
  ];
}

class FoodRecommendation extends Equatable {
  final int id;
  final String mealTime;
  final String foodName;
  final String ingredients;
  final String caloriesPerIngredients;
  final int totalCalories;
  final int glycemicIndex;
  final String imageUrl;

  const FoodRecommendation({
    required this.id,
    required this.mealTime,
    required this.foodName,
    required this.ingredients,
    required this.caloriesPerIngredients,
    required this.totalCalories,
    required this.glycemicIndex,
    required this.imageUrl,
  });

  factory FoodRecommendation.fromJson(Map<String, dynamic> json) {
    return FoodRecommendation(
      id: json['id'],
      mealTime: json['mealTime'],
      foodName: json['foodName'],
      ingredients: json['ingredients'],
      caloriesPerIngredients: json['caloriesPerIngredients'],
      totalCalories: json['totalCalories'],
      glycemicIndex: json['glycemicIndex'],
      imageUrl: json['imageUrl'],
    );
  }

  @override
  List<Object> get props => [
    id,
    mealTime,
    foodName,
    ingredients,
    caloriesPerIngredients,
    totalCalories,
    glycemicIndex,
    imageUrl,
  ];
}

class GlucoseMonitoringGraph extends Equatable {
  final String label;
  final double value;

  const GlucoseMonitoringGraph({required this.label, required this.value});

  factory GlucoseMonitoringGraph.fromJson(Map<String, dynamic> json) {
    return GlucoseMonitoringGraph(
      label: json['label'],
      value: json['value'].toDouble(),
    );
  }

  @override
  List<Object> get props => [label, value];
}
