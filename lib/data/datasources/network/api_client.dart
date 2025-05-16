import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/dio_client.dart';
import 'api_exception_handler.dart';

class ApiClient {
  final Dio dio = DioClient().dio;

  Future<T> request<T>({
    required Future<Response<dynamic>> Function() apiCall,
    required T Function(dynamic data) responseBuilder,
    String? customErrorMessage,
  }) async {
    try {
      final response = await apiCall();
      return responseBuilder(response.data);
    } catch (e) {
      final errorMessage = ApiExceptionHandler.handleException(
        e,
        customErrorMessage,
      );
      throw ApiException(
        message: errorMessage,
        statusCode: e is DioException ? e.response?.statusCode : null,
        data: e is DioException ? e.response?.data : null,
      );
    }
  }
}
