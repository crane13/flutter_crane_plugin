import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterPluginIap {
  static const MethodChannel _channel =
  const MethodChannel('flutter_plugin_iap');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// ==============     IAP  ==================

  static Future<bool> initIAP() async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("initIAP", {});
  }

  static Future<String> getSkuInfo(String sku_id) async {
    if (!hasChannelPlugin()) {
      return '';
    }
    return await _channel.invokeMethod("getSkuInfo", {
      'sku_id': sku_id,
    });
  }

  static Future<bool> removeAds() async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("removeAds", {});
  }

  static Future<bool> unlockScene(String sku_id) async {
    if (!hasChannelPlugin()) {
      return false;
    }
    return await _channel.invokeMethod("unlockScene", {
      'sku_id': sku_id,
    });
  }

  static Future<String> restore() async {
    if (!hasChannelPlugin()) {
      return '';
    }
    return await _channel.invokeMethod("restore", {});
  }

  /// ==============     IAP end ==================

  static bool hasChannelPlugin() {
    return Platform.isIOS || Platform.isMacOS;
  }
}
