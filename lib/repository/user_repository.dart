import 'package:contacts_flutter/utils/api_response.dart';

abstract class UserRepository {
  Future<ApiResponse> login(String email, String password);
  Future<ApiResponse> verifyToken(String token);
}
