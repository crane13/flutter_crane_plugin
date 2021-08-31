import 'dart:io';

class PlatformUtils {
  static bool isApp() {
    try {
      return Platform.isAndroid || Platform.isIOS;
    } catch (e) {
      return false;
    }
  }
}
