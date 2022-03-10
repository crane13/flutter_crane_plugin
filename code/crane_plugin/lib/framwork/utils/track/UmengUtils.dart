import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class UmengUtils {
  static var UMENG_KEY_ANDROID = '';
  static var UMENG_KEY_IOS = '60827c339e4e8b6f617f4cc7';

  static void setKeys(String iosKey, String androidKey) {
    UMENG_KEY_IOS = iosKey;
    UMENG_KEY_ANDROID = androidKey;
  }

  static Future<void> initUmeng() async {
    Future.delayed(Duration(seconds: 1), () {
      if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
        UmengCommonSdk.initCommon(UMENG_KEY_ANDROID, UMENG_KEY_IOS, 'Umeng');
      }
    });
  }

  static void trackEventUmeng(String event) {
    if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
      UmengCommonSdk.onEvent(event, {});
    }
  }

  static void onPause(String page) {
    if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
      UmengCommonSdk.onPageEnd(page);
    }
  }

  static void onResume(String page) {
    if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
      UmengCommonSdk.onPageStart(page);
    }
  }
}
