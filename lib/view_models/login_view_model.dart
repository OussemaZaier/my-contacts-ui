import 'package:contacts_flutter/repository/user_node_repository.dart';
import 'package:contacts_flutter/utils/api_error_response.dart';
import 'package:contacts_flutter/utils/api_response.dart';
import 'package:contacts_flutter/utils/api_success_response.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginViewModel extends ChangeNotifier {
  bool _loading = false;
  ApiResponse? _res;
  String? _error;

  bool get loading => _loading;
  ApiResponse? get res => _res;
  String? get error => _error;

  final userRepository = UserNode();

  setLoading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  setResponse(ApiResponse res) {
    _res = res;
  }

  setError(String error) {
    _error = error;
  }

  login(String email, String password) async {
    setLoading(true);
    var response = await userRepository.login(email, password);
    if (response is ApiSuccessResponse) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', response.data);
      setResponse(response);
      print(response.status);
      print(response.message);
      print(response.data);
    }
    if (response is ApiErrorResponse) {
      setError(response.message);
      print(response.status);
      print(response.message);
    }
    setLoading(false);
  }

  verifyToken(String token) async {
    setLoading(true);
    var response = await userRepository.verifyToken(token);

    if (response is ApiSuccessResponse) {
      setResponse(response);
      print(response.status);
      print(response.message);
      print(response.data);
    }
    if (response is ApiErrorResponse) {
      setError(response.message);
      print('here');
      print(response.status);
      print(response.message);
    }
    setLoading(false);
  }
}
