import 'package:equatable/equatable.dart';

abstract class MonitoringEvent extends Equatable {
  const MonitoringEvent();

  @override
  List<Object> get props => [];
}

class CreateGlucometerMonitoringEvent extends MonitoringEvent {
  final int bloodGlucose;

  const CreateGlucometerMonitoringEvent(this.bloodGlucose);

  @override
  List<Object> get props => [bloodGlucose];
}

class GetGlucometerMonitoringEvent extends MonitoringEvent {}

class GetGlucometerMonitoringGraphEvent extends MonitoringEvent {
  final String type; // 'daily' or 'hourly'

  const GetGlucometerMonitoringGraphEvent(this.type);

  @override
  List<Object> get props => [type];
}
