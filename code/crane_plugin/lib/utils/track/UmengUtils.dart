// import 'package:flutter_umeng_analytics_fork/flutter_umeng_analytics_fork.dart';

// import 'package:flutter_umeng_analytics_fork/flutter_umeng_analytics_fork.dart';

class UmengUtils {
  static var UMENG_KEY_ANDROID = '';
  static var UMENG_KEY_IOS = '60827c339e4e8b6f617f4cc7';

  static void setKeys(String iosKey, String androidKey) {
    UMENG_KEY_IOS = iosKey;
    UMENG_KEY_ANDROID = androidKey;
  }

  static Future<void> initUmeng() async {
    // var data = await initWithUM(
    //     androidAppKey: UMENG_KEY_ANDROID,
    //     iosAppKey: UMENG_KEY_IOS,
    //     channel: 'channel');
    // if (Platform.isAndroid)
    //   UMengAnalytics.init(UMENG_KEY_ANDROID,
    //       policy: Policy.BATCH, encrypt: true, reportCrash: false);
    // else if (Platform.isIOS)
    //   UMengAnalytics.init(UMENG_KEY_IOS,
    //       policy: Policy.BATCH, encrypt: true, reportCrash: false);
  }

  static void trackEventUmeng(String event) {
    // onEvent(event, {});
    // UMengAnalytics.logEvent(event);
  }

  static void onPause(String page) {
    // onPageEnd(page);
    // UMengAnalytics.beginPageView(page);
  }

  static void onResume(String page) {
    // onPageStart(page);
    // UMengAnalytics.endPageView(page);
  }
}
