import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/monitoring_model.dart';
import 'package:foreglyc/data/repositories/monitoring_repository.dart';

class MonitoringRepositoryImpl implements MonitoringRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;

  MonitoringRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
  }) : _apiConfig = apiConfig,
       _apiClient = apiClient;

  @override
  Future<CreateMonitoringGlucoseResponse> createMonitoringGlucoseGlucometer(
    int bloodGlucose,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.createMonitoringGlucoseGlucometer,
        data: {'bloodGlucose': bloodGlucose},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 201) {
        AppLogger.debug("Berhasil cuy\n ${response.toString()}");
      }

      return CreateMonitoringGlucoseResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to create glucose monitoring',
      );
    }
  }

  @override
  Future<GetMonitoringGlucoseResponse> getMonitoringGlucoseGlucometer() async {
    try {
      final response = await _apiClient.dio.get(
        _apiConfig.getMonitoringGlucoseGlucometer,
      );
      return GetMonitoringGlucoseResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get glucose monitoring data',
      );
    }
  }

  @override
  Future<GetMonitoringGlucoseGraphResponse> getMonitoringGlucoseGlucometerGraph(
    String type,
  ) async {
    try {
      final response = await _apiClient.dio.get(
        _apiConfig.getMonitoringGlucoseGlucometerGraph(type),
      );
      return GetMonitoringGlucoseGraphResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to get glucose graph data',
      );
    }
  }
}
