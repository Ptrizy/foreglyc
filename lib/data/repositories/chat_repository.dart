import 'dart:io';

import 'package:foreglyc/data/models/chat_model.dart';
import 'package:foreglyc/data/models/file_model.dart';

abstract class ChatRepository {
  Future<ChatResponse> sendChatToForeglycExpert(List<ChatModel> chatMessages);

  Future<FileUploadResponse> uploadFile(File file);

  Future<bool> saveChat(List<ChatModel> chatMessages);

  Future<List<ChatModel>?> loadChat();

  Future<bool> deleteChat();

  Future<GlucosePredictionResponse> getGlucosePrediction();
  Future<GlucosePredictionResponse> chatWithGlucosePrediction(
    ChatWithPredictionRequest request,
  );
}
