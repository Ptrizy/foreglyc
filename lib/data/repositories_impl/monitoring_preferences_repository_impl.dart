import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/monitoring_preference_model.dart';
import 'package:foreglyc/data/repositories/monitoring_preferences_repository.dart';

class MonitoringPreferenceRepositoryImpl
    implements MonitoringPreferenceRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;

  MonitoringPreferenceRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
  }) : _apiConfig = apiConfig,
       _apiClient = apiClient;

  @override
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
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.createGlucometerMonitoringPreferences,
        data: {
          'startWakeUpTime': startWakeUpTime,
          'endWakeUpTime': endWakeUpTime,
          'physicalActivityDays': physicalActivityDays,
          'startSleepTime': startSleepTime,
          'endSleepTime': endSleepTime,
          'hypoglycemiaAccuteThreshold': hypoglycemiaAccuteThreshold,
          'hypoglycemiaChronicThreshold': hypoglycemiaChronicThreshold,
          'hyperglycemiaAccuteThreshold': hyperglycemiaAccuteThreshold,
          'hyperglycemiaChronicThreshold': hyperglycemiaChronicThreshold,
          'sendNotification': sendNotification,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return CreateGlucometerPreferenceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create glucometer preference',
      );
    }
  }

  @override
  Future<CreateCgmPreferenceResponse> createCgmPreference({
    List<String>? physicalActivityDays,
    required double hypoglycemiaAccuteThreshold,
    required double hypoglycemiaChronicThreshold,
    required double hyperglycemiaAccuteThreshold,
    required double hyperglycemiaChronicThreshold,
    required bool sendNotification,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.createCgmMonitoringPreferences,
        data: {
          if (physicalActivityDays != null)
            'physicalActivityDays': physicalActivityDays,
          'hypoglycemiaAccuteThreshold': hypoglycemiaAccuteThreshold,
          'hypoglycemiaChronicThreshold': hypoglycemiaChronicThreshold,
          'hyperglycemiaAccuteThreshold': hyperglycemiaAccuteThreshold,
          'hyperglycemiaChronicThreshold': hyperglycemiaChronicThreshold,
          'sendNotification': sendNotification,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      return CreateCgmPreferenceResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create CGM preference',
      );
    }
  }
}
