import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token Management
  static Future<void> saveToken(String token) async {
    await _prefs?.setString('auth_token', token);
  }

  static String? getToken() {
    return _prefs?.getString('auth_token');
  }

  static Future<void> removeToken() async {
    await _prefs?.remove('auth_token');
  }

  // User Data
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final jsonString = json.encode(userData);
    await _prefs?.setString('user_data', jsonString);
  }

  static Map<String, dynamic>? getUserData() {
    final jsonString = _prefs?.getString('user_data');
    if (jsonString != null) {
      return json.decode(jsonString) as Map<String, dynamic>;
    }
    return null;
  }

  static Future<void> removeUserData() async {
    await _prefs?.remove('user_data');
  }

  // Theme
  static Future<void> saveThemeMode(String mode) async {
    await _prefs?.setString('theme_mode', mode);
  }

  static String? getThemeMode() {
    return _prefs?.getString('theme_mode');
  }

  // Locale
  static Future<void> saveLocale(String locale) async {
    await _prefs?.setString('locale', locale);
  }

  static String? getLocale() {
    return _prefs?.getString('locale');
  }

  // Clear all data (logout)
  static Future<void> clearAll() async {
    await _prefs?.clear();
  }

  // Generic setters and getters
  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }
}
