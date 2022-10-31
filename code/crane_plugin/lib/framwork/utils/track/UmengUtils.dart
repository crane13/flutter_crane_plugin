import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
// import 'package:fl_umeng/fl_umeng.dart';

class UmengUtils {
  static var UMENG_KEY_ANDROID = '';
  static var UMENG_KEY_IOS = '60827c339e4e8b6f617f4cc7';

  static void setKeys(String iosKey, String androidKey) {
    UMENG_KEY_IOS = iosKey;
    UMENG_KEY_ANDROID = androidKey;
  }

  static Future<void> initUmeng() async {
    Future.delayed(Duration(seconds: 1), () async {
      if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
        // final bool data = await FlUMeng().init(
        //     preInit: true,
        //     androidAppKey: UMENG_KEY_ANDROID,
        //     iosAppKey: UMENG_KEY_IOS,
        //     channel: 'channel');
        // print('Umeng 初始化成功 = $data');
        // await FlUMeng().setLogEnabled(true);
      }
    });
  }

  static void trackEventUmeng(String event) async {
    if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
      // final bool data = await FlUMeng().onEvent(event, <String, String>{});
    }
  }

  static void onPause(String page) async {
    if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
      // await FlUMeng().onPageEnd(page);
    }
  }

  static void onResume(String page) async {
    if (PlatformUtils.isAndroid() || PlatformUtils.isIOS()) {
      // await FlUMeng().onPageStart(page);
    }
  }
}
