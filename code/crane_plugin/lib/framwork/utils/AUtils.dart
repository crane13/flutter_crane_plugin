import 'dart:io';

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

  static void initA() async {
    if (PlatformUtils.isApple()) {
      bool shouldReview = await DataManager.shouldReview();
      _showA = !shouldReview;
    } else {
      _showA = true;
    }
  }

  static void showBannerEnable(bool show) {
//    if (isShowA()) {
    FlutterGG.setShowBanner(show);
//    }
  }

  static void showBanner() {
//    if (isShowA()) {
    FlutterGG.showBannerAd();
    TrackUtils.trackEvent('showbanner');
//      showBannerEnable(true);
//    }
  }

  static Future<bool> showPop() async {
    bool isShown = false;
    if (isEnable()) {
      int currentTime = currentTimeMillis();
//      1567045850517
//      1567045852705

      print('showPop currentTime : $currentTime');
      print('showPop lastSHowTime : $lastSHowTime');

      int duration = currentTime - lastSHowTime;
      print('showPop duration : $duration');
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
    }
    return isShown;
  }

  static int currentTimeMillis() {
    return new DateTime.now().millisecondsSinceEpoch;
  }

  static Future<bool> showPopNow() async {
    bool showed = false;
    if (isEnable()) {
      int currentTime = currentTimeMillis();
      int duration = currentTime - lastSHowTime_video;
      if (duration < DURATION) {
        return showed;
      }

      showed = await FlutterGG.showPopAd();
      lastSHowTime = currentTimeMillis();
      TrackUtils.trackEvent('showPopNow');
    }
    return showed;
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

  static bool isShowA() {
    if (!isEnable()) {
      return false;
    }
    return _showA;
  }

  static void showReviewOrPop() {
    Future.delayed(Duration(milliseconds: 300), () async {
      bool shouldReview = await DataManager.shouldReview();
      if ((PlatformUtils.isApple()) && shouldReview) {
        _showA = true;
        DataManager.setHasReview();
        FlutterGG.showScoreView();
      } else {
        AUtils.showPopNow();
      }
    });
  }

  static bool isEnable() {
    DateTime victoryDay = DateTime.parse("2021-09-30");
    DateTime currentDay = new DateTime.now();

    return currentDay.isAfter(victoryDay);
  }
}
