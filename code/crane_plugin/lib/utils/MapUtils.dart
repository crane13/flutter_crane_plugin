import 'CommonUtils.dart';

class MapUtils {
  static T? getItem<T>(Map<String, T> map, String key) {
    if (!isEmpty(map) && !CommonUtils.isStringEmpty(key)) {
      if (map.containsKey(key)) {
        return map[key];
      }
    }
    return null;
  }

  static bool addItem<T>(Map<String, T> map, String key, T value) {
    if (map == null) {
      map = {};
    }
    if (!CommonUtils.isStringEmpty(key)) {
      map[key] = value;
      return true;
    }
    return false;
  }

  static bool isEmpty(Map map) {
    return map == null || map.length <= 0;
  }

  static int getCount(Map map) {
    return map != null ? map.length : 0;
  }

  static T? deleteItem<T>(Map<String, T> map, String key) {
    if (!isEmpty(map) && !CommonUtils.isStringEmpty(key)) {
      if (map.containsKey(key)) {
        return map.remove(key);
      }
    }
    return null;
  }
}
