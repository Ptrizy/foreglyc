class FoodInformationResponse {
  final int status;
  final FoodInformationData data;
  final String message;

  FoodInformationResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory FoodInformationResponse.fromJson(Map<String, dynamic> json) {
    return FoodInformationResponse(
      status: json['status'],
      data: FoodInformationData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class FoodInformationData {
  final String foodName;
  final String mealTime;
  final String imageUrl;
  final List<Nutrition> nutritions;
  final int totalCalory;
  final int totalCarbohydrate;
  final int totalProtein;
  final int totalFat;
  final int glyecemicIndex;

  FoodInformationData({
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

  factory FoodInformationData.fromJson(Map<String, dynamic> json) {
    return FoodInformationData(
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
