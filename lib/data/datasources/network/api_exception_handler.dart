import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/logger.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  ApiException({required this.message, this.statusCode, this.data});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode)';
}

class ApiExceptionHandler {
  static String handleException(dynamic error, [String? customErrorMessage]) {
    if (error is DioException) {
      return _handleDioException(error, customErrorMessage);
    } else {
      AppLogger.error('Unexpected error', error);
      return customErrorMessage ?? 'An unexpected error occurred';
    }
  }

  static String _handleDioException(
    DioException e,
    String? customErrorMessage,
  ) {
    String errorMessage = customErrorMessage ?? 'An error occurred';

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage =
            'Connection timed out. Please check your internet connection.';
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleBadResponse(e.response);
        break;
      case DioExceptionType.cancel:
        errorMessage = 'Request was cancelled';
        break;
      case DioExceptionType.unknown:
        if (e.error != null && e.error.toString().contains('SocketException')) {
          errorMessage = 'No internet connection';
        } else {
          errorMessage = 'An unexpected error occurred';
        }
        break;
      default:
        errorMessage = 'An unexpected error occurred';
    }

    AppLogger.error('DioException: $errorMessage', e);
    return errorMessage;
  }

  static String _handleBadResponse(Response? response) {
    if (response == null) return 'No response received';

    switch (response.statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission to access this resource.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error. Please try again later.';
      default:
        return response.data?['message'] ?? 'An error occurred on the server';
    }
  }
}
