import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:foreglyc/data/datasources/logger.dart';
import 'package:foreglyc/data/models/chat_model.dart';
import 'package:foreglyc/data/repositories/chat_repository.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository _chatRepository;
  List<ChatModel> _currentMessages = [];

  ChatBloc({required ChatRepository chatRepository})
    : _chatRepository = chatRepository,
      super(ChatInitial()) {
    on<LoadChatEvent>(_onLoadChat);
    on<SendMessageEvent>(_onSendMessage);
    on<SaveChatEvent>(_onSaveChat);
    on<DeleteChatEvent>(_onDeleteChat);
    on<GetGlucosePredictionEvent>(_onGetGlucosePrediction);
    on<ChatWithGlucosePredictionEvent>(_onChatWithGlucosePrediction);
  }

  Future<void> _onLoadChat(LoadChatEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      final savedChat = await _chatRepository.loadChat();
      if (savedChat != null && savedChat.isNotEmpty) {
        _currentMessages = savedChat;
        emit(ChatLoaded(messages: _currentMessages));
      } else {
        _currentMessages = [];
        emit(ChatLoaded(messages: _currentMessages));
      }
    } catch (e) {
      emit(ChatError(message: 'Failed to load chat: ${e.toString()}'));
    }
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      final userMessage = ChatModel(
        role: 'user',
        message: event.message,
        fileUrl: '',
      );

      if (event.file != null) {
        emit(
          FileUploading(currentMessages: [..._currentMessages, userMessage]),
        );

        final fileResponse = await _chatRepository.uploadFile(event.file!);

        final userMessageWithFile = ChatModel(
          role: 'user',
          message: event.message,
          fileUrl: fileResponse.data.url,
        );

        emit(
          FileUploaded(
            fileUrl: fileResponse.data.url,
            currentMessages: [..._currentMessages, userMessageWithFile],
          ),
        );

        // Update the message with file URL
        _currentMessages = [..._currentMessages, userMessageWithFile];
      } else {
        // No file, just add the user message
        _currentMessages = [..._currentMessages, userMessage];
      }

      // Send the messages to the API
      emit(ChatSending(currentMessages: _currentMessages));

      final response = await _chatRepository.sendChatToForeglycExpert(
        _currentMessages,
      );

      // Update current messages with the response
      _currentMessages = response.data;

      // Save the chat automatically
      await _chatRepository.saveChat(_currentMessages);

      emit(ChatLoaded(messages: _currentMessages));
    } catch (e) {
      emit(ChatError(message: 'Failed to send message: ${e.toString()}'));
    }
  }

  Future<void> _onSaveChat(SaveChatEvent event, Emitter<ChatState> emit) async {
    try {
      emit(ChatLoading());
      await _chatRepository.saveChat(event.chatMessages);
      emit(ChatSaved(messages: event.chatMessages));
    } catch (e) {
      emit(ChatError(message: 'Failed to save chat: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteChat(
    DeleteChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      await _chatRepository.deleteChat();
      _currentMessages = [];
      emit(ChatDeleted());
    } catch (e) {
      emit(ChatError(message: 'Failed to delete chat: ${e.toString()}'));
    }
  }

  Future<void> _onGetGlucosePrediction(
    GetGlucosePredictionEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      final response = await _chatRepository.getGlucosePrediction();
      AppLogger.debug(response.toString());
      emit(GlucosePredictionLoaded(response: response));
    } catch (e) {
      emit(ChatError(message: 'Failed to get prediction: ${e.toString()}'));
    }
  }

  Future<void> _onChatWithGlucosePrediction(
    ChatWithGlucosePredictionEvent event,
    Emitter<ChatState> emit,
  ) async {
    try {
      emit(ChatLoading());
      final response = await _chatRepository.chatWithGlucosePrediction(
        event.request,
      );
      AppLogger.debug(response.toString());
      emit(ChatWithPredictionLoaded(response: response));
    } catch (e) {
      final errorMessage =
          e is DioException
              ? e.response?.data?.toString() ?? e.message
              : e.toString();
      emit(ChatError(message: 'Failed to chat with prediction: $errorMessage'));
    }
  }
}
