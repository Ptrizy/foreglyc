part of 'food_information_bloc.dart';

abstract class FoodInformationState extends Equatable {
  const FoodInformationState();

  @override
  List<Object> get props => [];
}

class FoodInformationInitial extends FoodInformationState {}

class FoodInformationLoading extends FoodInformationState {}

class FoodInformationGenerated extends FoodInformationState {
  final FoodInformationData foodInformation;

  const FoodInformationGenerated(this.foodInformation);

  @override
  List<Object> get props => [foodInformation];
}

class FoodInformationError extends FoodInformationState {
  final String message;

  const FoodInformationError(this.message);

  @override
  List<Object> get props => [message];
}
