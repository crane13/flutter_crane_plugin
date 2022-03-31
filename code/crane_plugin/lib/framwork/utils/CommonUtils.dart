import 'dart:math' as math;

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'TextUtils.dart';

class CommonUtils {
  static const MINITES = 60;
  static const HOUR = 60 * MINITES;

  static final oCcy = new NumberFormat("#,##0.000", "en_US");
  static final oCcy_2 = new NumberFormat("#,##0.00", "en_US");
  static final oCcy_2_ = new NumberFormat("#0.00", "en_US");

  static void showToast(BuildContext context, String message) {
    if (!TextUtils.isEmpty(message)) {
      // Fluttertoast.showToast(
      //     msg: message,
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     // backgroundColor: Colors.red,
      //     // textColor: Colors.white,
      //     fontSize: 16.0);

      BotToast.showText(text: message, align: Alignment.center);
    }
  }

  static int parseInt(String str, {int defaultValue = 0}) {
    try {
      return int.parse(str);
    } catch (e) {}
    return defaultValue;
  }

  static double parseDouble(dynamic str, {double defaultValue = 0}) {
    try {
      if (str is double) {
        return str;
      }
      return double.parse(str);
    } catch (e) {}
    return defaultValue;
  }

  static double splitAndRound_2(double value) {
    if (value == null) {
      return 0.00;
    }
    return splitAndRound(value, 2);
  }

  static double splitAndRound_3(double value) {
    if (value == null) {
      return 0.000;
    }
    return splitAndRound(value, 3);
  }

  static double splitAndRound_0(double value) {
    if (value == null) {
      return 0;
    }
    return splitAndRound(value, 0);
  }

  static double splitAndRound(double a, int n) {
    a = a * math.pow(10, n);
    return (a.round()) / (math.pow(10, n));
  }

  static String double3(double value) {
    if (value == null) {
      return '0.000';
    }
    return oCcy.format(value);
  }

  static String double2_0(double value) {
    if (value == null) {
      return '0.00';
    }
    return oCcy_2_.format(value);
  }

  static String double2(double value) {
    if (value == null || value == 0) {
      return '';
    }
    return oCcy_2.format(value);
  }

  static String formatStr(String str) {
    if (TextUtils.isEmpty(str)) {
      return '';
    }
    return str;
  }

  /**
   * 根据传入的日期值判断是否是星期六或星期日
   * return true/false
   */
  static bool isWeekend() {
    DateTime dateTime = DateTime.now();
    return (dateTime.weekday == DateTime.saturday ||
        dateTime.weekday == DateTime.sunday);
  }

  /**
   * 获取当前时间，格式：1315
   */
  static int getIntCurrentTime() {
    DateTime dateTime = DateTime.now();
    int hour = dateTime.hour;
    int minute = dateTime.minute;
    String currentTimeStr = "";
    if (minute < 10) {
      currentTimeStr = '${hour}0$minute';
    } else {
      currentTimeStr = '${hour}$minute';
    }
    int currentTime = parseInt(currentTimeStr);
    return currentTime;
  }

  static int getCurrentYear() {
    return DateTime.now().year;
  }

  static int getCurrentMonth() {
    return DateTime.now().month;
  }

  static double abs(double d) {
    return d < 0 ? -d : d;
  }

  static String formatTimeBySeconds(int startSecends) {
    if (startSecends == null || startSecends <= 0) {
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
    if (i == null) {
      return '00';
    }
    return i > 9 ? '$i' : '0$i';
  }

  static void vibrate() {
    HapticFeedback.heavyImpact();
  }

  static void vibrateExpode() {
    try {
      HapticFeedback.heavyImpact();
    } catch (e) {}
  }
}
