import 'package:craneplugin/utils/FlutterGG.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';

class AUtils {
  static const DURATION = 1 * 60 * 1000;

  static int lastSHowTime = 0;
  static int lastSHowTime_video = 0;

  static void showBannerEnable(bool show) {
    if (isEnableNow()) {
      FlutterGG.setShowBanner(show);
    }
  }

  static void showBanner() {
    if (isEnableNow()) {
      FlutterGG.showBannerAd();
      TrackUtils.trackEvent('showbanner');
//      showBannerEnable(true);
    }
  }

  static void showPop() async {
    if (isEnable()) {
      int currentTime = currentTimeMillis();
//      1567045850517
//      1567045852705

      print('showPop currentTime : $currentTime');
      print('showPop lastSHowTime : $lastSHowTime');

      int duration = currentTime - lastSHowTime;
      print('showPop duration : $duration');
      if (duration < DURATION) {
        return;
      }

      bool isShown = await FlutterGG.showPopAd();
      if (isShown) {
        lastSHowTime = currentTime;
        TrackUtils.trackEvent('showPop');
      }
    }
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static void showPopNow() {
    if (isEnable()) {
      int currentTime = currentTimeMillis();
      int duration = currentTime - lastSHowTime_video;
      if (duration < DURATION) {
        return;
      }

      FlutterGG.showPopAd();
      lastSHowTime = currentTimeMillis();
      TrackUtils.trackEvent('showPopNow');
    }
  }

  static Future<bool> isVideoReady() async {
    bool isReady = false;
    if (isEnable()) {
      isReady = await FlutterGG.isRewardVideoReady();
    }
    return isReady;
  }

  static Future<bool> showVideo() async {
    if (isEnable()) {
      lastSHowTime = currentTimeMillis();
      lastSHowTime_video = currentTimeMillis();
      TrackUtils.trackEvent('showVideo');
      return await FlutterGG.showRewardAd();
    }
    return true;
  }

  static Widget getAView(
      {double padding_h = 0, String size = 'banner', double maxHeight = 0}) {
    if (isEnable()) {
      TrackUtils.trackEvent('showbanner_big');
      return FlutterGG.getAView(
          padding_h: padding_h, size: size, maxHeight: maxHeight);
    }
    return Text('');
  }

  static bool isEnableNow() {
    return true;
  }

  static bool isEnable() {
    DateTime victoryDay = DateTime.parse("2021-08-25");
    DateTime currentDay = new DateTime.now();
    return currentDay.isAfter(victoryDay);
//    return true;
  }
}
