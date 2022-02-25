import 'dart:ui';

import 'package:crane_plugin/framwork/utils/CacheUtils.dart';
import 'package:crane_plugin/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeType {
  static const KEY_THEME = 'key_theme';

  static const THEME_LIGHT = 1;
  static const THEME_DARK = 2;
  static const THEME_SYSTERM = 0;

  static Brightness? brightnessValue;

  static int _themeType = THEME_SYSTERM;

  static void setBrightness(Brightness brightness) {
    brightnessValue = brightness;
  }

  static void initTheme(int themeType) {}

  static void setThemeType(int type) {
    _themeType = type;
    saveThemeType(type);
  }

  static bool isDarkMode() {
    return THEME_DARK == _themeType ||
        (THEME_SYSTERM == _themeType && brightnessValue == Brightness.dark);
  }

  static String getThemeStr(BuildContext context) {
    switch (_themeType) {
      case THEME_LIGHT:
        return S.of(context).theme_light;
      case THEME_DARK:
        return S.of(context).theme_dark;
      case THEME_SYSTERM:
        return S.of(context).theme_systerm;
    }
    return '';
  }

  static IconData getThemeIcon() {
    switch (_themeType) {
      case THEME_LIGHT:
        return Icons.brightness_7;
      case THEME_DARK:
        return Icons.brightness_4;
      case THEME_SYSTERM:
        return Icons.settings;
    }
    return Icons.brightness_4;
  }

  static bool isSystermDarkMode(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    print('isSystermDarkMode brightnessValue : ${brightnessValue}');
    return brightnessValue == Brightness.dark;
  }

  static Future<bool> saveThemeType(int theme) async {
    return await CacheUtils.setIntWithKey(KEY_THEME, theme);
  }

  static Future<int> readThemeType() async {
    int? theme = await CacheUtils.getIntByKey(KEY_THEME);
    if (theme == null) {
      theme = ThemeType.THEME_LIGHT;
    }
    return theme;
  }

  static Future<bool> hasSetTheme() async {
    int? theme = await CacheUtils.getIntByKey(KEY_THEME);
    if (theme == null || theme < 0) {
      return false;
    }
    return true;
  }
}
