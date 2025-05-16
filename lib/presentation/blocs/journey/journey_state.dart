part of 'journey_bloc.dart';

sealed class JourneyState extends Equatable {
  const JourneyState();
  
  @override
  List<Object> get props => [];
}

final class JourneyInitial extends JourneyState {}
