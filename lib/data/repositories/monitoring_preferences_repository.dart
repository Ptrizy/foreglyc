import 'package:foreglyc/data/models/monitoring_preference_model.dart';

abstract class MonitoringPreferenceRepository {
  Future<CreateGlucometerPreferenceResponse> createGlucometerPreference({
    required String startWakeUpTime,
    required String endWakeUpTime,
    required List<String> physicalActivityDays,
    required String startSleepTime,
    required String endSleepTime,
    required double hypoglycemiaAccuteThreshold,
    required double hypoglycemiaChronicThreshold,
    required double hyperglycemiaAccuteThreshold,
    required double hyperglycemiaChronicThreshold,
    required bool sendNotification,
  });

  Future<CreateCgmPreferenceResponse> createCgmPreference({
    List<String>? physicalActivityDays,
    required double hypoglycemiaAccuteThreshold,
    required double hypoglycemiaChronicThreshold,
    required double hyperglycemiaAccuteThreshold,
    required double hyperglycemiaChronicThreshold,
    required bool sendNotification,
  });
}
