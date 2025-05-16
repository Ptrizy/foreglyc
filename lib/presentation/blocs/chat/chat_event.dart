import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/chat_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String message;
  final File? file;

  const SendMessageEvent({required this.message, this.file});

  @override
  List<Object?> get props => [message, file];
}

class LoadChatEvent extends ChatEvent {}

class DeleteChatEvent extends ChatEvent {}

class SaveChatEvent extends ChatEvent {
  final List<ChatModel> chatMessages;

  const SaveChatEvent({required this.chatMessages});

  @override
  List<Object> get props => [chatMessages];
}
