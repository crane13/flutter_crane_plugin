// import 'dart:io';
//
// import 'package:appcenter_analytics/appcenter_analytics.dart';
// import 'package:appcenter_base/appcenter.dart';
// import 'package:appcenter_crashes/appcenter_crashes.dart';
//
// class AppCenterUtils {
//  static var APPCENTER_SECRET_IOS = '';
//  static var APPCENTER_SECRET_ANDROID = '';
//
//  static void setKeys(String iosKey, String androidKey) {
//    APPCENTER_SECRET_IOS = iosKey;
//    APPCENTER_SECRET_ANDROID = androidKey;
//  }
//
//  static void initAppCenter() async {
//    var app_secret =
//        Platform.isAndroid ? APPCENTER_SECRET_ANDROID : APPCENTER_SECRET_IOS;
//
//    await AppCenter.start(
//        app_secret, [AppCenterAnalytics.id, AppCenterCrashes.id]);
//
//    await AppCenter.setEnabled(true); // global
// //  await AppCenterAnalytics.setEnabled(false); // just a service
// //  await AppCenterCrashes.setEnabled(false); // just a service
//  }
//
//  static void trackEventerAppCenter(String event) {
//    AppCenterAnalytics.trackEvent(event);
// //  AppCenterAnalytics.trackEvent("casino", { "dollars" : "10" }); // with
//  }
// }
