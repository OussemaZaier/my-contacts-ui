import 'package:contacts_flutter/repository/user_repository.dart';
import 'package:contacts_flutter/utils/api_response.dart';
import 'package:contacts_flutter/utils/api_success_response.dart';
import 'package:contacts_flutter/utils/get_error_response.dart';
import 'package:dio/dio.dart';

class UserNode extends UserRepository {
  final dio = Dio();

  @override
  Future<ApiResponse> login(String email, String password) async {
    dio.options.sendTimeout = const Duration(seconds: 30); // Milliseconds
    dio.options.receiveTimeout = const Duration(seconds: 30); // Milliseconds
    dio.options.connectTimeout = const Duration(minutes: 1); // Milliseconds

    try {
      final response = await dio.post(
          'http://192.168.1.20:5000/api/users/login',
          data: {'email': email, 'password': password});
      return ApiSuccessResponse(
        status: response.data["status"],
        message: response.data["message"],
        data: response.data["data"],
      );
    } on DioException catch (e) {
      return getErrorResponse(e);
    }
  }
}
