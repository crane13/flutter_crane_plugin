import 'package:shared_preferences/shared_preferences.dart';

class CacheUtils {


  static Future setIntWithKey(String key, int v) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt(key, v);
    } catch (e) {}
  }

  static Future<int> getIntByKey(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getInt(key);
    } catch (e) {}
    return 0;
  }

}
