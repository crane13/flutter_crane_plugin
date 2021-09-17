import 'package:crane_plugin/framwork/K.dart';
import 'package:crane_plugin/framwork/utils/track/UmengUtils.dart';

class Configs {
  static void init() {
    UmengUtils.UMENG_KEY_IOS = '';
    UmengUtils.UMENG_KEY_ANDROID = '';

    K.IOS_APPID = '';
    K.ANDROID_PACKAGE = '';
    K.IOS_PACKAGE = '';
    K.IS_GOOGLEPLAY = true;
    K.setChannel('');
  }
}
