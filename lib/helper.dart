import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _loggedInKey = 'isLoggedIn';

  // Save the login state
  static Future<void> setLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, isLoggedIn);
  }

  // Check the login state
  static Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Clear preferences (e.g., on logout)
  static Future<void> clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
