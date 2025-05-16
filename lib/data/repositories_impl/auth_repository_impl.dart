import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/local/auth_preferences.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/auth_model.dart';
import 'package:foreglyc/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;

  AuthRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
  }) : _apiClient = apiClient,
       _apiConfig = apiConfig;

  @override
  Future<SignupResponse> signUp(
    String fullName,
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.signUp,
        data: {
          "fullName": fullName,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      final signupResponse = signupResponseFromJson(json.encode(response.data));

      AppLogger.debug(signupResponse.toString());

      if (signupResponse.data != null) {
        await AuthPreferences.saveId(signupResponse.data!.id);
      }

      return signupResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Registration failed. Please try again.',
      );
    }
  }

  @override
  Future<SigninResponse> signIn(String email, String password) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.signIn,
        data: {"email": email, "password": password},
      );

      final signinResponse = signinResponseFromJson(json.encode(response.data));

      AppLogger.debug(signinResponse.toString());

      if (signinResponse.data != null) {
        await AuthPreferences.saveToken(signinResponse.data!.accessToken);
      }

      return signinResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ??
            'Login failed. Please check your credentials.',
      );
    }
  }

  @override
  Future<VerificationResponse> verifyEmail(String code) async {
    try {
      final userId = await AuthPreferences.getId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      final response = await _apiClient.dio.post(
        '${_apiConfig.baseUrl}/api/v1/auth/verify-email/$userId',
        data: {"code": code},
      );

      final verificationResponse = verificationResponseFromJson(
        json.encode(response.data),
      );

      AppLogger.debug(verificationResponse.toString());

      return verificationResponse;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Verification failed. Please try again.',
      );
    }
  }

  @override
  Future<bool> resendVerificationEmail() async {
    try {
      final userId = await AuthPreferences.getId();
      if (userId == null) {
        throw Exception('User ID not found');
      }

      await _apiClient.dio.post(
        '${_apiConfig.baseUrl}/api/v1/auth/resend-verification-email/$userId',
      );

      return true;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Failed to resend verification email.',
      );
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await AuthPreferences.deleteToken();
      await AuthPreferences.deleteId();
      return true;
    } catch (e) {
      throw Exception('Failed to sign out. Please try again.');
    }
  }
}
