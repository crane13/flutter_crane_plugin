class TextUtils {
  static bool isEmpty(String str) {
    return str == null || str.trim().length <= 0 || 'null' == str;
  }
}
