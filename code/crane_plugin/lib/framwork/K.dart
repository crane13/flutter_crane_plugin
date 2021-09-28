import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/framwork/utils/FlutterGG.dart';
import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';

class K {
  static const ICON_DEFAULT =
      'packages/crane_plugin/assets/images/default_1x1.png';

  static var CRANE_APP_NAME = 'Crane App';

  static var IS_OVERSEA = true;

  static var IOS_APPID = '';

  static var _channel = '';

  static setChannel(String channel) {
    K._channel = channel;
  }

  static getChannel() {
    return _channel;
  }

  static String getMoreListLocal() {
    if (PlatformUtils.isApple()) {
      if (ConfigUtils.isChinese()) {
        return 'packages/crane_plugin/assets/json/more_apps_ios_zh.json';
      } else {
        return 'packages/crane_plugin/assets/json/more_apps_ios.json';
      }
    } else if (PlatformUtils.isAndroid()) {
      if (IS_OVERSEA) {
        return 'packages/crane_plugin/assets/json/more_apps_google_play.json';
      } else {
        return 'packages/crane_plugin/assets/json/more_apps.json';
      }
    }
    return '';
  }

  static String getMoreListUrl() {
    if (PlatformUtils.isApple()) {
      if (ConfigUtils.isChinese()) {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_ios_zh.json';
      } else {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_ios.json';
      }
    } else if (PlatformUtils.isAndroid()) {
      if (IS_OVERSEA) {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps_google_play.json';
      } else {
        return 'https://configs-1253122004.cos.ap-chengdu.myqcloud.com/more_apps.json';
      }
    }
    return '';
  }

  static Uri getMoreListUrlForHttp() {
    String unencodedPath = '';
    if (PlatformUtils.isApple()) {
      if (ConfigUtils.isChinese()) {
        unencodedPath = '/more_apps_ios_zh.json';
      } else {
        unencodedPath = '/more_apps_ios.json';
      }
    } else if (PlatformUtils.isAndroid()) {
      if (IS_OVERSEA) {
        unencodedPath = '/more_apps_google_play.json';
      } else {
        unencodedPath = '/more_apps.json';
      }
    }

    return Uri.https(
        'configs-1253122004.cos.ap-chengdu.myqcloud.com', unencodedPath, {});
  }

  static Future<String> getRateUrl() async {
    if (PlatformUtils.isApple()) {
      return 'itms-apps://itunes.apple.com/app/id$IOS_APPID?action=write-review';
    } else {
      String packageName = await FlutterGG.getPackageName();
      if (IS_OVERSEA) {
        return 'https://play.google.com/store/apps/details?id=$packageName';
      } else {
        return 'https://www.coolapk.com/game/$packageName';
      }
    }
  }
}
