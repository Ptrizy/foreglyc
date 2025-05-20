import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/food_home_model.dart';
import 'package:foreglyc/data/repositories/food_repository.dart';

class FoodRepositoryImpl implements FoodRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;

  FoodRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
  }) : _apiClient = apiClient,
       _apiConfig = apiConfig;

  @override
  Future<FoodHomeResponse> getFoodHomePage() async {
    try {
      final response = await _apiClient.dio.get(
        _apiConfig.getFoodHomePage,
        options: Options(validateStatus: (status) => status! < 500),
      );
      AppLogger.debug(response.data.toString());

      if (response.statusCode == 200) {
        return FoodHomeResponse.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to get food homepage: ${response.statusCode} - ${response.statusMessage}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
