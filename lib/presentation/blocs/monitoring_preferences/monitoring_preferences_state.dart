part of 'monitoring_preferences_bloc.dart';

abstract class MonitoringPreferenceState extends Equatable {
  const MonitoringPreferenceState();

  @override
  List<Object> get props => [];
}

class MonitoringPreferenceInitial extends MonitoringPreferenceState {}

class MonitoringPreferenceLoading extends MonitoringPreferenceState {}

class GlucometerPreferenceCreated extends MonitoringPreferenceState {
  final CreateGlucometerPreferenceResponse response;

  const GlucometerPreferenceCreated(this.response);

  @override
  List<Object> get props => [response];
}

class CgmPreferenceCreated extends MonitoringPreferenceState {
  final CreateCgmPreferenceResponse response;

  const CgmPreferenceCreated(this.response);

  @override
  List<Object> get props => [response];
}

class MonitoringPreferenceError extends MonitoringPreferenceState {
  final String message;

  const MonitoringPreferenceError(this.message);

  @override
  List<Object> get props => [message];
}
