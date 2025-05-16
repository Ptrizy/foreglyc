part of 'food_information_bloc.dart';

abstract class FoodInformationEvent extends Equatable {
  const FoodInformationEvent();

  @override
  List<Object> get props => [];
}

class GenerateFoodInformation extends FoodInformationEvent {
  final String mealTime;
  final String imageUrl;

  const GenerateFoodInformation({
    required this.mealTime,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [mealTime, imageUrl];
}
