import 'dart:convert';

import 'package:convert/convert.dart';
import 'package:craneplugin/K.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonUtils {
  static const MINITES = 60;
  static const HOUR = 60 * MINITES;

  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static String generateMd5WithSalt(String data, {salt = '123456'}) {
    var content = new Utf8Encoder().convert(data + salt);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }

  static bool isStringEmpty(String str) {
    return str == null || str.trim().length <= 0;
  }

  static void showToast(BuildContext context, String message) {
    if (!isStringEmpty(message)) {
      Toast.show(message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
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

//  static void openMoreApp() async {
//    String url = Const.getMoreAppUrl();
//    if (await canLaunch(url)) {
//      await launch(url);
//    } else {}
//    TrackUtils.trackEvent('openMoreApp');
//  }
//
  static void rate() async {
    String url = K.getRateUrl();
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
    TrackUtils.trackEvent('rate');
  }
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

  static void shareApp(BuildContext context) {
//    Share.share(
//        S.of(context).app_name +
//            ' - ' +
//            S.of(context).share_content +
//            Const.getDownloadUrl(),
//        icon: S.of(context).app_name,
//        url: K.getDownloadUrl());
//    TrackUtils.trackEvent('share');
  }

}
