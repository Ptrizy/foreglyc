class FoodHomeResponse {
  final int status;
  final FoodHomeData data;
  final String message;

  FoodHomeResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory FoodHomeResponse.fromJson(Map<String, dynamic> json) {
    return FoodHomeResponse(
      status: json['status'],
      data: FoodHomeData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class FoodHomeData {
  final List<DailyFoodResponse> dailyFoodResponses;
  final int totalCalory;
  final int totalCarbohydrate;
  final int totalFat;
  final int totalProtein;
  final int totalInsuline;

  FoodHomeData({
    required this.dailyFoodResponses,
    required this.totalCalory,
    required this.totalCarbohydrate,
    required this.totalFat,
    required this.totalProtein,
    required this.totalInsuline,
  });

  factory FoodHomeData.fromJson(Map<String, dynamic> json) {
    return FoodHomeData(
      dailyFoodResponses: List<DailyFoodResponse>.from(
        json['dailyFoodResponses'].map((x) => DailyFoodResponse.fromJson(x)),
      ),
      totalCalory: json['totalCalory'],
      totalCarbohydrate: json['totalCarbohydrate'],
      totalFat: json['totalFat'],
      totalProtein: json['totalProtein'],
      totalInsuline: json['totalInsuline'],
    );
  }
}

class DailyFoodResponse {
  final String mealTime;
  final String time;
  final FoodMonitoring foodMonitoring;
  final FoodRecommendation foodRecomendation;

  DailyFoodResponse({
    required this.mealTime,
    required this.time,
    required this.foodMonitoring,
    required this.foodRecomendation,
  });

  factory DailyFoodResponse.fromJson(Map<String, dynamic> json) {
    return DailyFoodResponse(
      mealTime: json['mealTime'],
      time: json['time'],
      foodMonitoring: FoodMonitoring.fromJson(json['foodMonitoring']),
      foodRecomendation: FoodRecommendation.fromJson(json['foodRecomendation']),
    );
  }
}

class FoodMonitoring {
  final int id;
  final String foodName;
  final String mealTime;
  final String imageUrl;
  final List<Nutrition>? nutritions;
  final int totalCalory;
  final int totalCarbohydrate;
  final int totalFat;
  final int totalProtein;
  final int glyecemicIndex;

  FoodMonitoring({
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
      nutritions:
          json['nutritions'] != null
              ? List<Nutrition>.from(
                json['nutritions'].map((x) => Nutrition.fromJson(x)),
              )
              : null,
      totalCalory: json['totalCalory'],
      totalCarbohydrate: json['totalCarbohydrate'],
      totalFat: json['totalFat'],
      totalProtein: json['totalProtein'],
      glyecemicIndex: json['glyecemicIndex'],
    );
  }
}

class FoodRecommendation {
  final int id;
  final String mealTime;
  final String foodName;
  final String ingredients;
  final String caloriesPerIngredients;
  final int totalCalories;
  final int glycemicIndex;
  final String imageUrl;

  FoodRecommendation({
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
}

class Nutrition {
  final String type;
  final List<NutritionComponent> components;

  Nutrition({required this.type, required this.components});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      type: json['type'],
      components: List<NutritionComponent>.from(
        json['components'].map((x) => NutritionComponent.fromJson(x)),
      ),
    );
  }
}

class NutritionComponent {
  final String name;
  final int portion;
  final String unit;
  final int calory;

  NutritionComponent({
    required this.name,
    required this.portion,
    required this.unit,
    required this.calory,
  });

  factory NutritionComponent.fromJson(Map<String, dynamic> json) {
    return NutritionComponent(
      name: json['name'],
      portion: json['portion'],
      unit: json['unit'],
      calory: json['calory'],
    );
  }
}
