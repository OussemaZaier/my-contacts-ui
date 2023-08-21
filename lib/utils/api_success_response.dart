import 'package:contacts_flutter/utils/api_response.dart';
import 'package:contacts_flutter/utils/serializable.dart';

class ApiSuccessResponse<T extends Serializable> extends ApiResponse {
  @override
  String status;
  @override
  String message;
  String data;
  ApiSuccessResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiSuccessResponse.fromJson(
      Map<String, dynamic> json, Function(Map<String, dynamic>) create) {
    return ApiSuccessResponse<T>(
      status: json["status"],
      message: json["message"],
      data: create(json["data"]),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        "status": this.status,
        "message": this.message,
        "data": this.data,
      };
}
