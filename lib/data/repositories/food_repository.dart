import 'package:foreglyc/data/models/food_home_model.dart';

abstract class FoodRepository {
  Future<FoodHomeResponse> getFoodHomePage();
}
