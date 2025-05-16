import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/file_model.dart';
import 'package:foreglyc/data/models/food_information_model.dart';
import 'package:foreglyc/data/models/food_monitoring_model.dart';
import 'package:foreglyc/data/repositories/dietary_repository.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class DietaryRepositoryImpl implements DietaryRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;

  DietaryRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
  }) : _apiConfig = apiConfig,
       _apiClient = apiClient;

  @override
  Future<FileUploadResponse> uploadFile(File file) async {
    try {
      final fileName = path.basename(file.path);
      final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
      final fileType = mimeType.split('/').first;
      final fileSubType = mimeType.split('/').last;

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          file.path,
          filename: fileName,
          contentType: MediaType(fileType, fileSubType),
        ),
      });

      final response = await _apiClient.dio.post(
        _apiConfig.uploadFile,
        data: formData,
      );

      return FileUploadResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to upload file: ${e.toString()}');
    }
  }

  @override
  Future<FoodInformationResponse> generateFoodInformation({
    required String mealTime,
    required String imageUrl,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.generateFoodInformations,
        data: {'mealTime': mealTime, 'imageUrl': imageUrl},
      );

      return FoodInformationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to generate food information: ${e.toString()}');
    }
  }

  @override
  Future<FoodMonitoringResponse> createFoodMonitoring({
    required String foodName,
    required String mealTime,
    required String imageUrl,
    required List<Nutrition> nutritions,
    required int totalCalory,
    required int totalCarbohydrate,
    required int totalProtein,
    required int totalFat,
    required int glyecemicIndex,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.createFoodMonitorings,
        data: {
          'foodName': foodName,
          'mealTime': mealTime,
          'imageUrl': imageUrl,
          'nutritions':
              nutritions
                  .map(
                    (nutrition) => {
                      'type': nutrition.type,
                      'components':
                          nutrition.components
                              .map(
                                (component) => {
                                  'name': component.name,
                                  'portion': component.portion,
                                  'unit': component.unit,
                                  'calory': component.calory,
                                },
                              )
                              .toList(),
                    },
                  )
                  .toList(),
          'totalCalory': totalCalory,
          'totalCarbohydrate': totalCarbohydrate,
          'totalProtein': totalProtein,
          'totalFat': totalFat,
          'glyecemicIndex': glyecemicIndex,
        },
      );

      return FoodMonitoringResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create food monitoring: ${e.toString()}');
    }
  }
}
