import 'package:shared_preferences/shared_preferences.dart';

class SharedClient {
  static Future<void> setString(SharedKeys key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key.name, value);
  }

  static Future<String?> getString(SharedKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key.name);
  }

  static Future<void> setInt(SharedKeys key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key.name, value);
  }

  static Future<int?> getInt(SharedKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key.name);
  }

  static Future<void> setBool(SharedKeys key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key.name, value);
  }

  static Future<bool?> getBool(SharedKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key.name);
  }

  static Future<void> remove(SharedKeys key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key.name);
  }
}

enum SharedKeys { token, isDarkMode }
