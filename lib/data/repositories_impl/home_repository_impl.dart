import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/local/home_preference.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/home_model.dart';
import 'package:foreglyc/data/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;
  final HomePreferences _homePreferences;

  HomeRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
    required HomePreferences homePreferences,
  }) : _apiClient = apiClient,
       _apiConfig = apiConfig,
       _homePreferences = homePreferences;

  @override
  Future<HomeResponse> getHomeData() async {
    try {
      final response = await _apiClient.dio.get(_apiConfig.getHomepage);

      if (response.data != null) {
        final homeResponse = HomeResponse.fromJson(response.data);
        await _homePreferences.saveHome(homeResponse);
        return homeResponse;
      }
      AppLogger.debug(response.data.toString());

      throw Exception('Response data is null');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to get home data');
    }
  }
}
