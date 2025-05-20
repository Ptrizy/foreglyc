part of 'dietary_bloc.dart';

abstract class DietaryEvent extends Equatable {
  const DietaryEvent();

  @override
  List<Object> get props => [];
}

class LoadDietaryData extends DietaryEvent {}
