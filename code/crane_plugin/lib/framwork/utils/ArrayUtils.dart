class ArrayUtils {
  static T? getItem<T>(List<T> list, int index) {
    if (list != null && list.length > 0 && index >= 0 && index < list.length) {
      return list[index];
    }
    return null;
  }

  static bool isEmpty(List list) {
    return list == null || list.length <= 0;
  }

  static int getCount(List list) {
    return list != null ? list.length : 0;
  }

  static bool deleteItem<T>(List<T> list, {int index = -1, T? item}) {
    if (!isEmpty(list)) {
      if (index >= 0 && index < list.length) {
        list.removeAt(index);
        return true;
      }
      if (item != null && list.contains(item)) {
        list.remove(item);
        return true;
      }
    }
    return false;
  }

  static bool containItem<T>(List<T> list, T item) {
    if (!isEmpty(list) && item != null) {
      return list.contains(item);
    }
    return false;
  }
}
