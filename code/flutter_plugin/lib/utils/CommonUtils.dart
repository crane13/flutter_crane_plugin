import 'dart:math' as math;

// import 'package:crypto/crypto.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtils {
  static const MINITES = 60;
  static const HOUR = 60 * MINITES;

  // static String generateMd5(String data) {
  //   var content = new Utf8Encoder().convert(data);
  //   var digest = md5.convert(content);
  //   return hex.encode(digest.bytes);
  // }

  // static String generateMd5WithSalt(String data, {salt = '123456'}) {
  //   var content = new Utf8Encoder().convert(data + salt);
  //   var digest = md5.convert(content);
  //   return hex.encode(digest.bytes);
  // }

  static bool isStringEmpty(String str) {
    return str == null || str.trim().length <= 0;
  }

  static void showToast(BuildContext context, String message) {
    if (!isStringEmpty(message)) {
      // Toast.show(message, context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Toast.show(message, gravity: Toast.center);
    }
  }

  static String getFormatTimeBySeconds(int startSecends) {
    if (startSecends <= 0) {
      return '00:00';
    }
    int hour = (startSecends / HOUR).floor();
    int minite = ((startSecends % HOUR) / MINITES).floor();
    int seconds = (startSecends % MINITES).floor();
    var time = '';
    if (hour > 0) {
      time = '${format2(hour)}:${format2(minite)}:${format2(seconds)}';
    } else {
      time = '${format2(minite)}:${format2(seconds)}';
    }
    return time;
  }

  static String format2(int i) {
    return i > 9 ? '${i}' : '0$i';
  }

  static void openOtherApp(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  static Future setScenceLocked(String key, bool unlocked) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool value = await prefs.setBool(key, unlocked);
      return value != null && value;
    } catch (e) {}
  }

  static Future<bool> getScenceunLocked(String key) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getBool(key);
    } catch (e) {}
    return false;
  }

  static Future<bool> saveCurrentLevelInfo(
      String currentLevel, String currentData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString(currentLevel, currentData);
    } catch (e) {}
  }

  static Future<String> getCurrentLevelInfo(String currentLevel) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      return prefs.getString(currentLevel);
    } catch (e) {}
    return '';
  }

//  static void openMoreApp() async {
//    String url = Const.getMoreAppUrl();
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {}
//    TrackUtils.trackEvent('openMoreApp');
//  }
//

//
//  static void feedback() async {
//    String url = Const.getFeedbackUrl();
//
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {}
//    TrackUtils.trackEvent('feedback');
//  }

  static void openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }

  static void shareApp(BuildContext context, String app_name,
      String share_content, String download_url, String share_image) {
    Share.share('$app_name - $share_content $download_url');
//     Share.share(
// //        S.of(context).app_name +
// //            ' - ' +
// //            S.of(context).share_content +
// //            Const.getDownloadUrl(),
//         '$app_name - $share_content $download_url',
//         icon: share_image,
//         url: download_url);
    TrackUtils.trackEvent('share');
  }

  static int parseInt(String str, {int defaultValue = 0}) {
    try {
      return int.parse(str);
    } catch (e) {}
    return defaultValue;
  }

  static double parseDouble(String str, {double defaultValue = 0}) {
    try {
      return double.parse(str);
    } catch (e) {}
    return defaultValue;
  }

  static double splitAndRound_2(double value) {
    return splitAndRound(value, 2);
  }

  static double splitAndRound(double a, int n) {
    a = a * math.pow(10, n);
    return (a.round()) / (math.pow(10, n));
  }
}
