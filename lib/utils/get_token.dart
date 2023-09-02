import 'package:shared_preferences/shared_preferences.dart';

class Token {
  late SharedPreferences _prefs;

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<String?> get getToken async {
    await _initPrefs();
    return _prefs.getString('token');
  }
}
