import 'package:contacts_flutter/utils/api_response.dart';

class ApiErrorResponse extends ApiResponse {
  @override
  String status;
  @override
  String message;

  ApiErrorResponse({
    required this.status,
    required this.message,
  });

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) =>
      ApiErrorResponse(
        status: json["status"],
        message: json["message"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
