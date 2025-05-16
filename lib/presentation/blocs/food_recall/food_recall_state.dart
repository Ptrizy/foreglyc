part of 'food_recall_bloc.dart';

abstract class FoodRecallState extends Equatable {
  const FoodRecallState();

  @override
  List<Object> get props => [];
}

class FoodRecallInitial extends FoodRecallState {}

class FoodRecallLoading extends FoodRecallState {}

class FoodImageUploaded extends FoodRecallState {
  final String imageUrl;

  const FoodImageUploaded(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class FoodInformationGenerated extends FoodRecallState {
  final FoodInformationData foodInformation;

  const FoodInformationGenerated(this.foodInformation);

  @override
  List<Object> get props => [foodInformation];
}

class FoodMonitoringCreated extends FoodRecallState {
  final FoodMonitoringData foodMonitoring;

  const FoodMonitoringCreated(this.foodMonitoring);

  @override
  List<Object> get props => [foodMonitoring];
}

class FoodRecallError extends FoodRecallState {
  final String message;

  const FoodRecallError(this.message);

  @override
  List<Object> get props => [message];
}
