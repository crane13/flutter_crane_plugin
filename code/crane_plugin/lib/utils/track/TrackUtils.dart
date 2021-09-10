
import '../CommonUtils.dart';
import 'UmengUtils.dart';

class TrackUtils {
  static void initTrackSDK() {
    UmengUtils.initUmeng();
//    AppCenterUtils.initAppCenter();
  }

  static void onPause(String page) {
    if (!CommonUtils.isStringEmpty(page)) {
      UmengUtils.onPause(page);
    }
  }

  static void onResume(String page) {
    if (!CommonUtils.isStringEmpty(page)) {
      UmengUtils.onResume(page);
    }
  }

  static void trackEvent(String event) {
    if (!CommonUtils.isStringEmpty(event)) {
//      AppCenterUtils.trackEventerAppCenter(event);
      UmengUtils.trackEventUmeng(event);
    }
  }
}
