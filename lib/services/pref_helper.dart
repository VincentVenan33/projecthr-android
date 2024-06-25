import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  Future<String?> getToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('token');
  }

  Future<void> setToken(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('token', token);
  }

  Future<void> removeToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.remove('token');
  }
}
