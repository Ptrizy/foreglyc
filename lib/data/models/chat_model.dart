class ChatModel {
  final String role;
  final String message;
  final String fileUrl;

  ChatModel({required this.role, required this.message, this.fileUrl = ''});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      role: json['role'],
      message: json['message'],
      fileUrl: json['fileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'role': role, 'message': message, 'fileUrl': fileUrl};
  }

  @override
  String toString() {
    return 'ChatModel(role: $role, message: $message, fileUrl: $fileUrl)';
  }
}

class ChatResponse {
  final int status;
  final List<ChatModel> data;
  final String message;

  ChatResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      status: json['status'],
      data:
          (json['data'] as List)
              .map((item) => ChatModel.fromJson(item))
              .toList(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((chat) => chat.toJson()).toList(),
      'message': message,
    };
  }
}
