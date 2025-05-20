part of 'dietary_bloc.dart';

abstract class DietaryState extends Equatable {
  const DietaryState();

  @override
  List<Object> get props => [];
}

class DietaryInitial extends DietaryState {}

class DietaryLoading extends DietaryState {}

class DietaryLoaded extends DietaryState {
  final FoodHomeData foodHomeData;

  const DietaryLoaded(this.foodHomeData);

  @override
  List<Object> get props => [foodHomeData];
}

class DietaryError extends DietaryState {
  final String message;

  const DietaryError(this.message);

  @override
  List<Object> get props => [message];
}
