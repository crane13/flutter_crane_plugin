import 'package:umeng_common_sdk/umeng_common_sdk.dart';

class UmengUtils {
  static var UMENG_KEY_ANDROID = '';
  static var UMENG_KEY_IOS = '';

  static void setKeys(String iosKey, String androidKey) {
    UMENG_KEY_IOS = iosKey;
    UMENG_KEY_ANDROID = androidKey;
  }

  static void initUmeng() {
    UmengCommonSdk.initCommon(UMENG_KEY_ANDROID, UMENG_KEY_IOS, 'Umeng');
    UmengCommonSdk.setPageCollectionModeManual();
  }

  static void trackEventUmeng(String event) {
    UmengCommonSdk.onEvent(event, {});
  }

  static void onPause(String page) {
    UmengCommonSdk.onPageEnd(page);
  }

  static void onResume(String page) {
    UmengCommonSdk.onPageStart(page);
  }
}
