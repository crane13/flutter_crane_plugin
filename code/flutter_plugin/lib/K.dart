import 'dart:io';

class K {
  static var IS_GOOGLEPLAY = true;

  static var ANDROID_PACKAGE = '';
  static var IOS_PACKAGE = '';
  static var IOS_APPID = '';

  static init(bool is_googleplay, String android_package, String ios_package, String ios_appid) {
    IS_GOOGLEPLAY = is_googleplay;
    ANDROID_PACKAGE = android_package;
    IOS_PACKAGE = ios_package;
    IOS_APPID = ios_appid;
  }

  static String getPackage() {
    return Platform.isIOS ? IOS_PACKAGE : ANDROID_PACKAGE;
  }

  static String getMoreListUrl() {
    if (Platform.isIOS) {
      return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_ios.json';
    } else {
      if (IS_GOOGLEPLAY) {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_google_play.json';
      } else {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps.json';
      }
    }
  }

  static String getMoreListLocal() {
    if (Platform.isIOS) {
      return 'assets/more_apps_ios.json';
    } else {
      if (IS_GOOGLEPLAY) {
        return 'assets/more_apps_google_play.json';
      } else {
        return 'assets/more_apps.json';
      }
    }
  }

  static String getRateUrl() {
    if (Platform.isIOS) {
      return 'itms-apps://itunes.apple.com/app/id${IOS_APPID}?action=write-review';
    } else {
      if (IS_GOOGLEPLAY) {
        return 'https://play.google.com/store/apps/details?id=${ANDROID_PACKAGE}';
      } else {
        return 'https://www.coolapk.com/game/${ANDROID_PACKAGE}';
      }
    }
  }

}
