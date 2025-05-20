import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:foreglyc/data/datasources/local/chat_preferences.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/datasources/network/api_client.dart';
import 'package:foreglyc/data/datasources/network/api_config.dart';
import 'package:foreglyc/data/models/chat_model.dart';
import 'package:foreglyc/data/models/file_model.dart';
import 'package:foreglyc/data/repositories/chat_repository.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

class ChatRepositoryImpl implements ChatRepository {
  final ApiClient _apiClient;
  final ApiConfig _apiConfig;
  final ChatPreferences _chatPreferences;

  ChatRepositoryImpl({
    required ApiClient apiClient,
    required ApiConfig apiConfig,
    required ChatPreferences chatPreferences,
  }) : _apiConfig = apiConfig,
       _apiClient = apiClient,
       _chatPreferences = chatPreferences;

  @override
  Future<ChatResponse> sendChatToForeglycExpert(
    List<ChatModel> chatMessages,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.chatbotForeglycExport,
        data: chatMessages.map((chat) => chat.toJson()).toList(),
      );

      return ChatResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to send chat: ${e.toString()}');
    }
  }

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
  Future<bool> saveChat(List<ChatModel> chatMessages) async {
    try {
      final chatJson = jsonEncode(
        chatMessages.map((chat) => chat.toJson()).toList(),
      );
      return await _chatPreferences.saveChat(chatJson);
    } catch (e) {
      throw Exception('Failed to save chat: ${e.toString()}');
    }
  }

  @override
  Future<List<ChatModel>?> loadChat() async {
    try {
      final chatJson = await _chatPreferences.loadChat();
      if (chatJson == null) return null;

      final chatList = List<Map<String, dynamic>>.from(jsonDecode(chatJson));
      return chatList.map((chat) => ChatModel.fromJson(chat)).toList();
    } catch (e) {
      throw Exception('Failed to load chat: ${e.toString()}');
    }
  }

  @override
  Future<bool> deleteChat() async {
    try {
      return await _chatPreferences.deleteChat();
    } catch (e) {
      throw Exception('Failed to delete chat: ${e.toString()}');
    }
  }

  @override
  Future<GlucosePredictionResponse> getGlucosePrediction() async {
    try {
      final response = await _apiClient.dio.get(
        _apiConfig.getGlucosePrediction,
      );
      AppLogger.debug(response.data.toString());
      return GlucosePredictionResponse.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Failed to get glucose prediction: ${e.toString()}');
    }
  }

  @override
  Future<GlucosePredictionResponse> chatWithGlucosePrediction(
    ChatWithPredictionRequest request,
  ) async {
    try {
      final response = await _apiClient.dio.post(
        _apiConfig.chatWithGlucosePredictions,
        data: request.toJson(),
      );
      AppLogger.debug(response.data.toString());
      return GlucosePredictionResponse.fromJson(response.data['data']);
    } catch (e, stackTrace) {
      // Debugging tambahan
      print('Error details: $e');
      print('Stack trace: $stackTrace');
      throw Exception(
        'Failed to chat with glucose prediction: ${e.toString()}',
      );
    }
  }
}
