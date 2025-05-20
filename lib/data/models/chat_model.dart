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

// Add to chat_model.dart or create a new file glucose_prediction_model.dart

class GlucosePrediction {
  final String time;
  final int value;
  final String? status; // Only for monitoring graph

  GlucosePrediction({required this.time, required this.value, this.status});

  factory GlucosePrediction.fromJson(Map<String, dynamic> json) {
    return GlucosePrediction(
      time: json['time'] ?? json['label'] ?? '',
      value: json['value'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'time': time, 'value': value, if (status != null) 'status': status};
  }
}

class Scenario {
  final String type;
  final List<GlucosePrediction> predictions;
  final String reason;
  final List<String> recommendations;

  Scenario({
    required this.type,
    required this.predictions,
    required this.reason,
    required this.recommendations,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      type: json['type'],
      predictions:
          (json['prediction'] as List)
              .map((item) => GlucosePrediction.fromJson(item))
              .toList(),
      reason: json['reason'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'prediction': predictions.map((p) => p.toJson()).toList(),
      'reason': reason,
      'recommendations': recommendations,
    };
  }
}

class GlucosePredictionResponse {
  final List<GlucosePrediction>? monitoringGraph;
  final List<Scenario> scenarios;
  final List<ChatModel> chats;

  GlucosePredictionResponse({
    this.monitoringGraph,
    required this.scenarios,
    required this.chats,
  });

  factory GlucosePredictionResponse.fromJson(Map<String, dynamic> json) {
    return GlucosePredictionResponse(
      monitoringGraph:
          json['glucoseMonitoringGraph'] != null
              ? (json['glucoseMonitoringGraph'] as List)
                  .map((item) => GlucosePrediction.fromJson(item))
                  .toList()
              : null,
      scenarios:
          (json['scenario'] as List)
              .map((item) => Scenario.fromJson(item))
              .toList(),
      chats:
          json['chats'] != null
              ? (json['chats'] as List)
                  .map((item) => ChatModel.fromJson(item))
                  .toList()
              : [], // Default empty list jika chats null
    );
  }
}

class ChatWithPredictionRequest {
  final List<Scenario> scenarios;
  final List<ChatModel> chats;

  ChatWithPredictionRequest({required this.scenarios, required this.chats});

  Map<String, dynamic> toJson() {
    return {
      'scenario': scenarios.map((s) => s.toJson()).toList(),
      'chats': chats.map((c) => c.toJson()).toList(),
    };
  }
}
