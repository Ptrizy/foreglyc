import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/monitoring_model.dart';

abstract class MonitoringState extends Equatable {
  const MonitoringState();

  @override
  List<Object> get props => [];
}

class MonitoringInitial extends MonitoringState {}

class MonitoringCreated extends MonitoringState {
  final GetMonitoringGlucoseGraphResponse response;
  const MonitoringCreated(this.response);

  @override
  List<Object> get props => [response];
}

class MonitoringLoading extends MonitoringState {
  final bool isGraphLoading;
  final bool isListLoading;

  const MonitoringLoading({
    this.isGraphLoading = false,
    this.isListLoading = false,
  });

  @override
  List<Object> get props => [isGraphLoading, isListLoading];
}

class MonitoringGlucoseLoading extends MonitoringState {}

class MonitoringGlucoseCreated extends MonitoringState {}

class MonitoringGraphLoaded extends MonitoringState {
  final GetMonitoringGlucoseGraphResponse response;
  const MonitoringGraphLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class MonitoringListLoaded extends MonitoringState {
  final GetMonitoringGlucoseResponse response;
  const MonitoringListLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class MonitoringError extends MonitoringState {
  final String message;
  final bool isGraphError;
  final bool isListError;

  const MonitoringError({
    required this.message,
    this.isGraphError = false,
    this.isListError = false,
  });

  @override
  List<Object> get props => [message, isGraphError, isListError];
}
