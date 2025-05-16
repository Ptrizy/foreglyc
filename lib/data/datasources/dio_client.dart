import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/local/auth_preferences.dart';
import 'logger.dart';

class DioClient {
  final Dio _dio = Dio();
  Dio get dio => _dio;

  DioClient() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // header => token
          final token = await AuthPreferences.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          AppLogger.info('Request: ${options.method} ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          AppLogger.info(
            'Response: ${response.statusCode} ${response.statusMessage}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          AppLogger.error('Error: ${e.message}', e, e.stackTrace);
          return handler.next(e);
        },
      ),
    );
  }
}
