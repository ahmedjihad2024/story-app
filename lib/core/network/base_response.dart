abstract class BasicResponse {
  bool get success;
  String get message;
}

class BaseResponse implements BasicResponse {
  final bool status;

  @override
  final String message;

  const BaseResponse({
    this.status = true,
    required this.message,
  });

  @override
  bool get success => status;

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      status: json['status'] as bool? ?? json['success'] as bool? ?? true,
      message: json['message'] as String? ?? json['data']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };

  @override
  String toString() => 'BaseResponse(status: $status, message: $message)';
}

