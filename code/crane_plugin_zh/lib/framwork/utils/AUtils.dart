import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
import 'package:flutter/material.dart';

import 'DataManager.dart';
import 'FlutterGG.dart';
import 'track/TrackUtils.dart';

class AUtils {
  static const DURATION = 2 * 60 * 1000;

  static int lastSHowTime = 0;
  static int lastSHowTime_video = 0;

  static bool _showA = true;

  static bool aClosed = false;

  static void initA() async {
    if (PlatformUtils.isApple()) {
      bool shouldReview = await DataManager.shouldReview();
      _showA = !shouldReview;
    } else {
      _showA = true;
    }
  }

  static void showBannerEnable(bool show) {
    if (!isEnable()) {
      return;
    }
    if (!isShowA()) {
      return;
    }
    FlutterGG.setShowBanner(show);
  }

  static void showBanner({bool isTop = false}) {
    if (!isEnable()) {
      return;
    }
    if (!isShowA()) {
      return;
    }
    FlutterGG.showBannerAd(isTop: isTop);
    TrackUtils.trackEvent('showbanner');
  }

  static Future<bool> showPop() async {
    if (!isEnable()) {
      return false;
    }
    bool isShown = false;
    int currentTime = currentTimeMillis();
//      1567045850517
//      1567045852705

    int duration = currentTime - lastSHowTime;
    if (duration < DURATION) {
      return isShown;
    }

    isShown = await FlutterGG.showPopAd();
    if (isShown == null) {
      isShown = false;
    }
    if (isShown) {
      lastSHowTime = currentTime;
      TrackUtils.trackEvent('showPop');
    }
    return isShown;
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static Future<bool> showPopNow() async {
    if (!isEnable()) {
      return false;
    }
    bool showed = false;
    int currentTime = currentTimeMillis();
    int duration = currentTime - lastSHowTime_video;
    if (duration < DURATION) {
      return showed;
    }

    showed = await FlutterGG.showPopAd(isNow: true);
    lastSHowTime = currentTimeMillis();
    TrackUtils.trackEvent('showPopNow');
    return showed;
  }

  static Future<bool> isVideoReady() async {
    if (!isEnable()) {
      return false;
    }
    return await FlutterGG.isRewardVideoReady();
  }

  static Future<bool> showVideo() async {
    if (!isEnable()) {
      return false;
    }
    lastSHowTime = currentTimeMillis();
    lastSHowTime_video = currentTimeMillis();
    TrackUtils.trackEvent('showVideo');
    return await FlutterGG.showRewardAd();
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

  static void showReviewOrPop({bool popNow = true}) {
    Future.delayed(Duration(milliseconds: 900), () async {
      bool shouldReview = await DataManager.shouldReview();
      if ((PlatformUtils.isApple()) && shouldReview) {
        _showA = true;
        DataManager.setHasReview();
        FlutterGG.showScoreView();
      } else {
        if (popNow) {
          AUtils.showPopNow();
        } else {
          AUtils.showPop();
        }
      }
    });
  }

  static bool isShowA() {
    return _showA;
  }

  static bool isEnable() {
    if (aClosed) {
      return false;
    }
    DateTime victoryDay = DateTime.parse("2022-10-31");
    DateTime currentDay = new DateTime.now();

    return currentDay.isAfter(victoryDay);
  }
}
