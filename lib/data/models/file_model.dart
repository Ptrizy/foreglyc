class FileUploadResponse {
  final int status;
  final FileData data;
  final String message;

  FileUploadResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory FileUploadResponse.fromJson(Map<String, dynamic> json) {
    return FileUploadResponse(
      status: json['status'],
      data: FileData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class FileData {
  final String url;

  FileData({required this.url});

  factory FileData.fromJson(Map<String, dynamic> json) {
    return FileData(url: json['url']);
  }
}
