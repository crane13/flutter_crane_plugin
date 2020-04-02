import 'dart:io';

import 'package:flutter_umeng_analytics_fork/flutter_umeng_analytics_fork.dart';

class UmengUtils {
  static var UMENG_KEY_ANDROID = '';
  static var UMENG_KEY_IOS = '';

  static void setKeys(String iosKey, String androidKey) {
    UMENG_KEY_IOS = iosKey;
    UMENG_KEY_ANDROID = androidKey;
  }

  static void initUmeng() {
    if (Platform.isAndroid)
      UMengAnalytics.init(UMENG_KEY_ANDROID,
          policy: Policy.BATCH, encrypt: true, reportCrash: false);
    else if (Platform.isIOS)
      UMengAnalytics.init(UMENG_KEY_IOS,
          policy: Policy.BATCH, encrypt: true, reportCrash: false);
  }

  static void trackEventUmeng(String event) {
    UMengAnalytics.logEvent(event);
  }

  static void onPause(String page) {
    UMengAnalytics.beginPageView(page);
  }

  static void onResume(String page) {
    UMengAnalytics.endPageView(page);
  }
}
