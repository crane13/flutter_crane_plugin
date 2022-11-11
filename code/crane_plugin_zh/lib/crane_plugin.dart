
import 'dart:async';

import 'package:flutter/services.dart';

class CranePlugin {
  static const MethodChannel _channel =
      const MethodChannel('crane_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
