import 'dart:async';

import 'package:craneplugin/ui/view/BannerView.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'CommonUtils.dart';

//import 'package:permission_handler/permission_handler.dart';

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

  static Future<String> getSkuInfo(String sku_id) async {
    return await _channel.invokeMethod("getSkuInfo", {
      'sku_id': sku_id,
    });
  }

  static Future<bool> unlockScene(String sku_id) async {
    return await _channel.invokeMethod("unlockScene", {
      'sku_id': sku_id,
    });
  }

  static Future<String> restore() async {
    return await _channel.invokeMethod("restore", {});
  }

  static Future<bool> restoreByPage(BuildContext context) async {
    String result = await FlutterGG.restore();
    print('restore : ${result}');
    List<String> sku_ids = result.split(',');
    for (String sku_id in sku_ids) {
      if (!CommonUtils.isStringEmpty(sku_id)) {
        await CommonUtils.setScenceLocked(sku_id.split('_')[0], true);
      }
    }
    return true;
  }

  static Future<bool> setIsPad() async {
    bool result = await _channel.invokeMethod('isPad', {});
    print('isPad === ${result}');
    return result;
  }

  static void _onEvent(Object value) {
    String event = value.toString();
    TrackUtils.trackEvent(event);
  }

  static void _onError(dynamic) {}

  static Future<String> getplatformVersion() async {
    var version = await _channel.invokeMethod('getPlatformVersion', {});
//    print('version ===== ${version}');
    return version;
  }

  static Future register(
      {String appId,
      bool doOnIOS: true,
      doOnAndroid: true,
      enableMTA: false}) async {
    return await _channel.invokeMethod("registerApp", {
      "appId": appId,
      "iOS": doOnIOS,
      "android": doOnAndroid,
      "enableMTA": enableMTA
    });
  }

  static Future setShowBanner(bool show) async {
    return await _channel
        .invokeMethod("showBannerEnable", {"showBanner": show});
  }

  static Future<bool> showPopAd() async {
    return await _channel.invokeMethod("showPopAd", {});
  }

  static Future<bool> showRewardAd() async {
    return await _channel.invokeMethod("showRewardAd", {});
  }

  static Future<bool> isRewardVideoReady() async {
    return await _channel.invokeMethod("isRewardVideoReady", {});
  }

//  static Future<bool> unlockScene(String scene) async {
//    return await _channel.invokeMethod("unlockScene", {
//      'scene': scene,
//    });
//  }

  static Future<bool> removeAds() async {
    return await _channel.invokeMethod("removeAds", {});
  }

  static Future<bool> initGameCenter() async {
    return await _channel.invokeMethod("initGameCenter", {});
  }

  static Future<bool> showRank(int score) async {
    return await _channel.invokeMethod("showLeader", {'score': score});
  }

  static Future<bool> reportScore(int score) async {
    return await _channel.invokeMethod("reportScore", {'score': score});
  }

  static Future<bool> reportAchievements(String achievement) async {
    return await _channel
        .invokeMethod("reportAchievements", {'achievement': achievement});
  }

  static Future<bool> showBannerAd() async {
    return await _channel.invokeMethod("showbanner", {});
  }

  static Widget getAView(
      {double padding_h = 0, String size = 'banner', double maxHeight = 0}) {
//    ConfigInfo configInfo = ConfigUtils.getConfigLocal();
    bool enable = true;

    if (enable) {
      if (size == 'large') {
        return BannerView(
          padding_h: padding_h,
          maxHeight: maxHeight,
          params: {
//            'gdt_appId': '',
//            'gdt_bannerId': '',
//            'admob_appId': 'ca-app-pub-7441199969844342~8048196040',
//            'admob_bannerId': 'ca-app-pub-7441199969844342/2608167106',
            'size': size
          },
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
}
