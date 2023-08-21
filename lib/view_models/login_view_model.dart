import 'package:contacts_flutter/repository/user_node_repository.dart';
import 'package:contacts_flutter/utils/api_error_response.dart';
import 'package:contacts_flutter/utils/api_response.dart';
import 'package:contacts_flutter/utils/api_success_response.dart';
import 'package:flutter/material.dart';

class LoginViewModel extends ChangeNotifier {
  bool _loading = false;
  ApiResponse? _res;
  String? _error;

  bool get loading => _loading;
  ApiResponse? get res => _res;
  String? get error => _error;

  setLoading(bool loading) async {
    _loading = loading;
    notifyListeners();
  }

  setResponse(ApiResponse res) async {
    _res = res;
  }

  setError(String error) async {
    _error = error;
  }

  login(String email, String password) async {
    setLoading(true);
    final userRepository = UserNode();
    var reponse = await userRepository.login(email, password);
    if (reponse is ApiSuccessResponse) {
      setResponse(reponse);
      print(reponse.message);
    }
    if (reponse is ApiErrorResponse) {
      setError(reponse.message);
      print(reponse.message);
    }

    setLoading(false);
  }
}
