import 'dart:convert';

class BaseResponse<T> {
  final int status;
  final T? data;
  final String message;

  BaseResponse({required this.status, this.data, required this.message});

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse<T>(
      status: json['status'],
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'status': status,
      'data': data != null ? toJsonT(data as T) : null,
      'message': message,
    };
  }
}

SignupResponse signupResponseFromJson(String str) =>
    BaseResponse<SignupData>.fromJson(
      json.decode(str),
      (data) => SignupData.fromJson(data),
    );

String signupResponseToJson(SignupResponse data) =>
    json.encode(data.toJson((data) => data.toJson()));

class SignupData {
  final String id;
  final String fullName;
  final String email;
  final String photoProfile;
  final bool isVerified;

  SignupData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.photoProfile,
    required this.isVerified,
  });

  factory SignupData.fromJson(Map<String, dynamic> json) => SignupData(
    id: json['id'],
    fullName: json['fullName'],
    email: json['email'],
    photoProfile: json['photoProfile'],
    isVerified: json['isVerified'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'photoProfile': photoProfile,
    'isVerified': isVerified,
  };
}

typedef SignupResponse = BaseResponse<SignupData>;

VerificationResponse verificationResponseFromJson(String str) =>
    BaseResponse<VerificationData>.fromJson(
      json.decode(str),
      (data) => VerificationData.fromJson(data),
    );

String verificationResponseToJson(VerificationResponse data) =>
    json.encode(data.toJson((data) => data.toJson()));

class VerificationData {
  final String id;
  final String fullName;
  final String email;
  final String photoProfile;
  final bool isVerified;

  VerificationData({
    required this.id,
    required this.fullName,
    required this.email,
    required this.photoProfile,
    required this.isVerified,
  });

  factory VerificationData.fromJson(Map<String, dynamic> json) =>
      VerificationData(
        id: json['id'],
        fullName: json['fullName'],
        email: json['email'],
        photoProfile: json['photoProfile'],
        isVerified: json['isVerified'],
      );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'photoProfile': photoProfile,
    'isVerified': isVerified,
  };
}

typedef VerificationResponse = BaseResponse<VerificationData>;

SigninResponse signinResponseFromJson(String str) =>
    BaseResponse<SigninData>.fromJson(
      json.decode(str),
      (data) => SigninData.fromJson(data),
    );

String signinResponseToJson(SigninResponse data) =>
    json.encode(data.toJson((data) => data.toJson()));

class SigninData {
  final String tokenType;
  final String accessToken;
  final int expiresAt;

  SigninData({
    required this.tokenType,
    required this.accessToken,
    required this.expiresAt,
  });

  factory SigninData.fromJson(Map<String, dynamic> json) => SigninData(
    tokenType: json['tokenType'],
    accessToken: json['accessToken'],
    expiresAt: json['expiresAt'],
  );

  Map<String, dynamic> toJson() => {
    'tokenType': tokenType,
    'accessToken': accessToken,
    'expiresAt': expiresAt,
  };
}

typedef SigninResponse = BaseResponse<SigninData>;
