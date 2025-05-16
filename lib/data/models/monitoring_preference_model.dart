import 'package:equatable/equatable.dart';

class CreateGlucometerPreferenceResponse {
  final int status;
  final GlucometerPreferenceData data;
  final String message;

  CreateGlucometerPreferenceResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CreateGlucometerPreferenceResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateGlucometerPreferenceResponse(
      status: json['status'],
      data: GlucometerPreferenceData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class CreateCgmPreferenceResponse {
  final int status;
  final CgmPreferenceData data;
  final String message;

  CreateCgmPreferenceResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CreateCgmPreferenceResponse.fromJson(Map<String, dynamic> json) {
    return CreateCgmPreferenceResponse(
      status: json['status'],
      data: CgmPreferenceData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class GlucometerPreferenceData extends Equatable {
  final String userId;
  final String startWakeUpTime;
  final String endWakeUpTime;
  final List<String> physicalActivityDays;
  final String startSleepTime;
  final String endSleepTime;
  final double hypoglycemiaAccuteThreshold;
  final double hypoglycemiaChronicThreshold;
  final double hyperglycemiaAccuteThreshold;
  final double hyperglycemiaChronicThreshold;
  final bool sendNotification;

  const GlucometerPreferenceData({
    required this.userId,
    required this.startWakeUpTime,
    required this.endWakeUpTime,
    required this.physicalActivityDays,
    required this.startSleepTime,
    required this.endSleepTime,
    required this.hypoglycemiaAccuteThreshold,
    required this.hypoglycemiaChronicThreshold,
    required this.hyperglycemiaAccuteThreshold,
    required this.hyperglycemiaChronicThreshold,
    required this.sendNotification,
  });

  factory GlucometerPreferenceData.fromJson(Map<String, dynamic> json) {
    return GlucometerPreferenceData(
      userId: json['userId'],
      startWakeUpTime: json['startWakeUpTime'],
      endWakeUpTime: json['endWakeUpTime'],
      physicalActivityDays: List<String>.from(
        json['physicalActivityDays'] ?? [],
      ),
      startSleepTime: json['startSleepTime'],
      endSleepTime: json['endSleepTime'],
      hypoglycemiaAccuteThreshold:
          json['hypoglycemiaAccuteThreshold'].toDouble(),
      hypoglycemiaChronicThreshold:
          json['hypoglycemiaChronicThreshold'].toDouble(),
      hyperglycemiaAccuteThreshold:
          json['hyperglycemiaAccuteThreshold'].toDouble(),
      hyperglycemiaChronicThreshold:
          json['hyperglycemiaChronicThreshold'].toDouble(),
      sendNotification: json['sendNotification'],
    );
  }

  @override
  List<Object> get props => [
    userId,
    startWakeUpTime,
    endWakeUpTime,
    physicalActivityDays,
    startSleepTime,
    endSleepTime,
    hypoglycemiaAccuteThreshold,
    hypoglycemiaChronicThreshold,
    hyperglycemiaAccuteThreshold,
    hyperglycemiaChronicThreshold,
    sendNotification,
  ];
}

class CgmPreferenceData extends Equatable {
  final String userId;
  final List<String>? physicalActivityDays;
  final double hypoglycemiaAccuteThreshold;
  final double hypoglycemiaChronicThreshold;
  final double hyperglycemiaAccuteThreshold;
  final double hyperglycemiaChronicThreshold;
  final bool sendNotification;

  const CgmPreferenceData({
    required this.userId,
    this.physicalActivityDays,
    required this.hypoglycemiaAccuteThreshold,
    required this.hypoglycemiaChronicThreshold,
    required this.hyperglycemiaAccuteThreshold,
    required this.hyperglycemiaChronicThreshold,
    required this.sendNotification,
  });

  factory CgmPreferenceData.fromJson(Map<String, dynamic> json) {
    return CgmPreferenceData(
      userId: json['userId'],
      physicalActivityDays:
          json['physicalActivityDays'] != null
              ? List<String>.from(json['physicalActivityDays'])
              : null,
      hypoglycemiaAccuteThreshold:
          json['hypoglycemiaAccuteThreshold'].toDouble(),
      hypoglycemiaChronicThreshold:
          json['hypoglycemiaChronicThreshold'].toDouble(),
      hyperglycemiaAccuteThreshold:
          json['hyperglycemiaAccuteThreshold'].toDouble(),
      hyperglycemiaChronicThreshold:
          json['hyperglycemiaChronicThreshold'].toDouble(),
      sendNotification: json['sendNotification'],
    );
  }

  @override
  List<Object?> get props => [
    userId,
    physicalActivityDays,
    hypoglycemiaAccuteThreshold,
    hypoglycemiaChronicThreshold,
    hyperglycemiaAccuteThreshold,
    hyperglycemiaChronicThreshold,
    sendNotification,
  ];
}
