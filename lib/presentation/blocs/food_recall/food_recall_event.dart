part of 'food_recall_bloc.dart';

abstract class FoodRecallEvent extends Equatable {
  const FoodRecallEvent();

  @override
  List<Object> get props => [];
}

class UploadFoodImage extends FoodRecallEvent {
  final File imageFile;

  const UploadFoodImage(this.imageFile);

  @override
  List<Object> get props => [imageFile];
}

class GenerateFoodInformation extends FoodRecallEvent {
  final String mealTime;
  final String imageUrl;

  const GenerateFoodInformation({
    required this.mealTime,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [mealTime, imageUrl];
}

class CreateFoodMonitoring extends FoodRecallEvent {
  final String foodName;
  final String mealTime;
  final String imageUrl;
  final List<Nutrition> nutritions;
  final int totalCalory;
  final int totalCarbohydrate;
  final int totalProtein;
  final int totalFat;
  final int glyecemicIndex;

  const CreateFoodMonitoring({
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

  @override
  List<Object> get props => [
    foodName,
    mealTime,
    imageUrl,
    nutritions,
    totalCalory,
    totalCarbohydrate,
    totalProtein,
    totalFat,
    glyecemicIndex,
  ];
}
