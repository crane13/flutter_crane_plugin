import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view/BannerView.dart';
import 'PlatformUtils.dart';
import 'TextUtils.dart';
import 'track/TrackUtils.dart';

class FlutterGG {
  static const PLUGIN_KEY = 'flutter_gg';
  static const MethodChannel _channel = const MethodChannel(PLUGIN_KEY);

  static var _eventChannel =
      const EventChannel(PLUGIN_KEY, const StandardMethodCodec());

  static StreamSubscription _subscription = _eventChannel
      .receiveBroadcastStream()
      .listen(_onEvent, onError: _onError);

  FlutterGG() {
//    if (_subscription == null) {
//      _subscription = _eventChannel
//          .receiveBroadcastStream()
//          .listen(_onEvent, onError: _onError);
//    }
  }



  /// ==============     Game Center  ==================

  static Future<bool> initGameCenter() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("initGameCenter", {});
  }

  static Future<bool> showRank(int score) async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showLeader", {'score': score});
  }

  static Future<bool> reportScore(String rankId, int score) async {
    if (TextUtils.isEmpty(rankId)) {
      return false;
    }
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel
        .invokeMethod("reportScore", {'rankId': rankId, 'score': score});
  }

  static Future<bool> reportAchievements(String achievement) async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel
        .invokeMethod("reportAchievements", {'achievement': achievement});
  }

  /// ==============     Game Center end  ==================

  /// ==============     ad     ==================
  static Future setShowBanner(bool show) async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel
        .invokeMethod("showBannerEnable", {"showBanner": show});
  }

  static Future<bool> showBannerAd() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showbanner", {});
  }

  static Future<bool> showPopAd() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showPopAd", {});
  }

  static Future<bool> isRewardVideoReady() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("isRewardVideoReady", {});
  }

  static Future<bool> showRewardAd() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showRewardAd", {});
  }

  static Widget getAView(
      {double padding_h = 0, String size = 'banner', double maxHeight = 0}) {
    bool enable = PlatformUtils.hasChannelPlugin();
    if (enable) {
      if (size == 'large') {
        return BannerView(
          padding_h: padding_h,
          maxHeight: maxHeight,
          params: {'size': size},
          listener: (event) {
            TrackUtils.trackEvent(event);
          },
        );
      } else {
        return SizedBox(
          height: 60,
        );
      }
    } else {
      return SizedBox(
        height: 60,
      );
    }
  }

  /// ==============     ad end    ==================

  static Future<bool> setIsPad() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    bool result = await _channel.invokeMethod('isPad', {});
    return result;
  }

  static Future<String> getplatformVersion() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return '';
    }
    var version = await _channel.invokeMethod('getPlatformVersion', {});
    return version;
  }

  static Future<bool> showScoreView() async {
    if (PlatformUtils.isApple()) {
      return await _channel.invokeMethod("showScoreView", {});
    }
    return false;
  }

  static Future<String> getChannel() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return '';
    }
    return await _channel.invokeMethod("getChannel", {});
  }

  static Future<bool> setWallPaperParams() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("setWallPaperParams", {});
  }

  static Future<bool> setWallPaper() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("setWallPaper", {});
  }

  static Future<String> getPackageName() async {
    if (!PlatformUtils.hasChannelPlugin()) {
      return '';
    }
    return await _channel.invokeMethod("getPackageName", {});
  }

  static void _onEvent(Object? value) {
    String event = value!.toString();
    TrackUtils.trackEvent(event);
  }

  static void _onError(dynamic) {}
}
