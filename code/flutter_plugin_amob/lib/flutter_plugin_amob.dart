import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_plugin_amob/view/BannerView.dart';

class FlutterPluginAmob {
  static const MethodChannel _channel =
      const MethodChannel('flutter_plugin_amob');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// ==============     ad     ==================
  static Future setShowBanner(bool show) async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel
        .invokeMethod("showBannerEnable", {"showBanner": show});
  }

  static Future<bool> showBannerAd() async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showbanner", {});
  }

  static Future<bool> showPopAd() async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showPopAd", {});
  }

  static Future<bool> isRewardVideoReady() async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("isRewardVideoReady", {});
  }

  static Future<bool> showRewardAd() async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("showRewardAd", {});
  }

  static Widget getAView(
      {double padding_h = 0, String size = 'banner', double maxHeight = 0}) {
    bool enable = hasChannelPlugin();
    if (enable) {
      if (size == 'large') {
        return BannerView(
          padding_h: padding_h,
          maxHeight: maxHeight,
          params: {'size': size},
          listener: (event) {
            // TrackUtils.trackEvent(event);
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

  static bool hasChannelPlugin() {
    return Platform.isIOS || Platform.isAndroid;
  }
}
