import 'package:equatable/equatable.dart';
import 'package:foreglyc/data/models/home_model.dart';

class CreateMonitoringGlucoseResponse {
  final int status;
  final CreateGlucoseMonitoringData data;
  final String message;

  CreateMonitoringGlucoseResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory CreateMonitoringGlucoseResponse.fromJson(Map<String, dynamic> json) {
    return CreateMonitoringGlucoseResponse(
      status: json['status'],
      data: CreateGlucoseMonitoringData.fromJson(json['data']),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'data': data.toJson(), 'message': message};
  }
}

class GetMonitoringGlucoseResponse {
  final int status;
  final List<GlucoseMonitoringData> data;
  final String message;

  GetMonitoringGlucoseResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GetMonitoringGlucoseResponse.fromJson(Map<String, dynamic> json) {
    return GetMonitoringGlucoseResponse(
      status: json['status'],
      data:
          (json['data'] as List)
              .map((item) => GlucoseMonitoringData.fromJson(item))
              .toList(),
      message: json['message'],
    );
  }
}

class GlucoseGraphData {
  final String label;
  final double value;

  GlucoseGraphData({required this.label, required this.value});

  factory GlucoseGraphData.fromJson(Map<String, dynamic> json) {
    return GlucoseGraphData(
      label: json['label'],
      value: json['value'].toDouble(),
    );
  }
}

class GetMonitoringGlucoseGraphResponse {
  final int status;
  final List<GlucoseMonitoringGraph> data;
  final String message;

  GetMonitoringGlucoseGraphResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory GetMonitoringGlucoseGraphResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return GetMonitoringGlucoseGraphResponse(
      status: json['status'],
      data:
          (json['data'] as List)
              .map((item) => GlucoseMonitoringGraph.fromJson(item))
              .toList(),
      message: json['message'],
    );
  }
}

class CreateGlucoseMonitoringData extends Equatable {
  final int bloodGlucose;
  final String status;
  final String unit;
  final String date;
  final String time;
  final bool isSafe;

  const CreateGlucoseMonitoringData({
    required this.bloodGlucose,
    required this.status,
    required this.unit,
    required this.date,
    required this.time,
    required this.isSafe,
  });

  factory CreateGlucoseMonitoringData.fromJson(Map<String, dynamic> json) {
    return CreateGlucoseMonitoringData(
      bloodGlucose: json['bloodGlucose'],
      status: json['status'],
      unit: json['unit'],
      date: json['date'],
      time: json['time'],
      isSafe: json['isSafe'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bloodGlucose': bloodGlucose,
      'status': status,
      'unit': unit,
      'date': date,
      'time': time,
      'isSafe': isSafe,
    };
  }

  @override
  List<Object> get props => [bloodGlucose, status, unit, date, time, isSafe];
}

class GlucoseMonitoringData extends Equatable {
  final int id;
  final double bloodGlucose;
  final String status;
  final String unit;
  final String date;
  final String time;
  final bool isSafe;

  const GlucoseMonitoringData({
    required this.id,
    required this.bloodGlucose,
    required this.status,
    required this.unit,
    required this.date,
    required this.time,
    required this.isSafe,
  });

  factory GlucoseMonitoringData.fromJson(Map<String, dynamic> json) {
    return GlucoseMonitoringData(
      id: json['id'],
      bloodGlucose: json['bloodGlucose'].toDouble(),
      status: json['status'],
      unit: json['unit'],
      date: json['date'],
      time: json['time'],
      isSafe: json['isSafe'],
    );
  }

  @override
  List<Object> get props => [
    id,
    bloodGlucose,
    status,
    unit,
    date,
    time,
    isSafe,
  ];
}
