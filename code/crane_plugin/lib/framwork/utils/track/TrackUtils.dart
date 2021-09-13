import '../TextUtils.dart';
import 'UmengUtils.dart';

class TrackUtils {
  static void initTrackSDK() {
    UmengUtils.initUmeng();
//    AppCenterUtils.initAppCenter();
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
