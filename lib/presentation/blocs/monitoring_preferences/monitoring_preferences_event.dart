part of 'monitoring_preferences_bloc.dart';

abstract class MonitoringPreferenceEvent extends Equatable {
  const MonitoringPreferenceEvent();

  @override
  List<Object> get props => [];
}

class CreateGlucometerPreferenceEvent extends MonitoringPreferenceEvent {
  final String startWakeUpTime;
  final String endWakeUpTime;
  final List<String> physicalActivityDays;
  final String startSleepTime;
  final String endSleepTime;
  final double hypoglycemiaAccuteThreshold;
  final double hypoglycemiaChronicThreshold;
  final double hyperglycemiaAccuteThreshold;
  final double hyperglycemiaChronicThreshold;
  final bool sendNotification;

  const CreateGlucometerPreferenceEvent({
    required this.startWakeUpTime,
    required this.endWakeUpTime,
    required this.physicalActivityDays,
    required this.startSleepTime,
    required this.endSleepTime,
    required this.hypoglycemiaAccuteThreshold,
    required this.hypoglycemiaChronicThreshold,
    required this.hyperglycemiaAccuteThreshold,
    required this.hyperglycemiaChronicThreshold,
    required this.sendNotification,
  });

  @override
  List<Object> get props => [
    startWakeUpTime,
    endWakeUpTime,
    physicalActivityDays,
    startSleepTime,
    endSleepTime,
    hypoglycemiaAccuteThreshold,
    hypoglycemiaChronicThreshold,
    hyperglycemiaAccuteThreshold,
    hyperglycemiaChronicThreshold,
    sendNotification,
  ];
}

class CreateCgmPreferenceEvent extends MonitoringPreferenceEvent {
  final List<String>? physicalActivityDays;
  final double hypoglycemiaAccuteThreshold;
  final double hypoglycemiaChronicThreshold;
  final double hyperglycemiaAccuteThreshold;
  final double hyperglycemiaChronicThreshold;
  final bool sendNotification;

  const CreateCgmPreferenceEvent({
    this.physicalActivityDays,
    required this.hypoglycemiaAccuteThreshold,
    required this.hypoglycemiaChronicThreshold,
    required this.hyperglycemiaAccuteThreshold,
    required this.hyperglycemiaChronicThreshold,
    required this.sendNotification,
  });

  @override
  List<Object> get props => [
    if (physicalActivityDays != null) physicalActivityDays!,
    hypoglycemiaAccuteThreshold,
    hypoglycemiaChronicThreshold,
    hyperglycemiaAccuteThreshold,
    hyperglycemiaChronicThreshold,
    sendNotification,
  ];
}
