import 'dart:io';

import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';

class K {
  static const ICON_DEFAULT = 'packages/crane_plugin/assets/images/default_1x1.png';

  static var CRANE_APP_NAME = 'Crane App';

  static var IS_OVERSEA = true;

  static var IOS_APPID = '';
  static var ANDROID_PACKAGE = '';
  static var IOS_PACKAGE = '';

  static var _channel = '';

  static setChannel(String channel) {
    K._channel = channel;
  }

  static getChannel() {
    return _channel;
  }

  static String getPackage() {
    return Platform.isIOS ? IOS_PACKAGE : ANDROID_PACKAGE;
  }

  static String getMoreListLocal() {
    if (Platform.isIOS) {
      if (ConfigUtils.isChinese()) {
        return 'packages/crane_plugin/assets/json/more_apps_ios_zh.json';
      } else {
        return 'packages/crane_plugin/assets/json/more_apps_ios.json';
      }
    } else {
      if (IS_OVERSEA) {
        return 'packages/crane_plugin/assets/json/more_apps_google_play.json';
      } else {
        return 'packages/crane_plugin/assets/json/more_apps.json';
      }
    }
  }

  static String getMoreListUrl() {
    if (Platform.isIOS) {
      if (ConfigUtils.isChinese()) {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_ios_zh.json';
      } else {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_ios.json';
      }
    } else {
      if (IS_OVERSEA) {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_google_play.json';
      } else {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps.json';
      }
    }
  }

  static Uri getMoreListUrlForHttp() {
    String unencodedPath = '';
    if (Platform.isIOS) {
      if (ConfigUtils.isChinese()) {
        unencodedPath = '/more_apps_ios_zh.json';
      } else {
        unencodedPath = '/more_apps_ios.json';
      }
    } else {
      if (IS_OVERSEA) {
        unencodedPath = '/more_apps_google_play.json';
      } else {
        unencodedPath = '/more_apps.json';
      }
    }

    return Uri.https(
        'configs-1253122004.cos.ap-chengdu.myqcloud.com', unencodedPath, {});
  }

  static String getRateUrl() {
    if (PlatformUtils.isApple()) {
      return 'itms-apps://itunes.apple.com/app/id$IOS_APPID?action=write-review';
    } else {
      if (IS_OVERSEA) {
        return 'https://play.google.com/store/apps/details?id=$ANDROID_PACKAGE';
      } else {
        return 'https://www.coolapk.com/game/$ANDROID_PACKAGE';
      }
    }
  }
}
