import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/chat_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatSending extends ChatState {
  final List<ChatModel> currentMessages;

  const ChatSending({required this.currentMessages});

  @override
  List<Object?> get props => [currentMessages];
}

class ChatLoaded extends ChatState {
  final List<ChatModel> messages;

  const ChatLoaded({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class FileUploading extends ChatState {
  final List<ChatModel> currentMessages;

  const FileUploading({required this.currentMessages});

  @override
  List<Object?> get props => [currentMessages];
}

class FileUploaded extends ChatState {
  final String fileUrl;
  final List<ChatModel> currentMessages;

  const FileUploaded({required this.fileUrl, required this.currentMessages});

  @override
  List<Object?> get props => [fileUrl, currentMessages];
}

class ChatSaved extends ChatState {
  final List<ChatModel> messages;

  const ChatSaved({required this.messages});

  @override
  List<Object?> get props => [messages];
}

class ChatDeleted extends ChatState {}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
