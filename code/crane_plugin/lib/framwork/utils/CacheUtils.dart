import 'package:shared_preferences/shared_preferences.dart';

class CacheUtils {
  static Future setIntWithKey(String key, int v) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, v);
    } catch (e) {}
  }

  static Future<int?> getIntByKey(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getInt(key);
    } catch (e) {}
    return 0;
  }

  static Future setStringWithKey(String key, String v) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, v);
    } catch (e) {}
  }

  static Future<String?> getStringByKey(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getString(key);
    } catch (e) {}
    return '';
  }

  static Future setBoolWithKey(String key, bool v) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, v);
    } catch (e) {}
  }

  static Future<bool?> getBoolByKey(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getBool(key);
    } catch (e) {}
    return false;
  }
}
