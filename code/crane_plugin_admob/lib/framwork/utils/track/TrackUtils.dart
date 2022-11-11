import '../TextUtils.dart';
import 'UmengUtils.dart';

class TrackUtils {
  static bool isUmengInited = false;
  static void initTrackSDK() {
    UmengUtils.initUmeng(preInit: true);
    isUmengInited = false;
  }

  static void initUmeng() {
    if (isUmengInited) {
      return;
    }
    UmengUtils.initUmeng(preInit: false);
    isUmengInited = true;
  }


  static void onPause(String page) {
    if (!TextUtils.isEmpty(page)) {
      UmengUtils.onPause(page);
    }
  }

  static void onResume(String page) {
    if (!TextUtils.isEmpty(page)) {
      UmengUtils.onResume(page);
    }
  }

  static void trackEvent(String event) {
    if (!TextUtils.isEmpty(event)) {
//      AppCenterUtils.trackEventerAppCenter(event);
      UmengUtils.trackEventUmeng(event);
    }
  }
}
