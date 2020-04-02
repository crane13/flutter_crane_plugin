import 'dart:async';
import 'dart:math' as math;

import 'package:craneplugin/utils/ConfigUtils.dart';
import 'package:craneplugin/utils/theme/ThemeType.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  bool isResumed = false;

  int currentScore = 0;
  double screenH = 0.0;
  double screenW = 0.0;

  Timer timerBase;

  Size screenSize = null;

  initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    screenSize = ConfigUtils.screenSize;
    computeScreenHW();

    timerBase = new Timer(const Duration(milliseconds: 100), () {
      setState(() {
        screenSize = MediaQuery.of(context).size;
        ConfigUtils.setScreenSize(screenSize);
        computeScreenHW();
      });
    });
  }

  void computeScreenHW() {
    if (screenSize != null) {
      double h = screenSize.height;
      double w = screenSize.width;
      screenH = math.min(h, w);
      screenW = math.max(h, w);
    }
  }

  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    } else if (state == AppLifecycleState.paused) {
      onPause();
    }
  }

  @override
  void didChangePlatformBrightness() {
    final Brightness brightness =
        WidgetsBinding.instance.window.platformBrightness;
    ThemeType.brightnessValue = brightness;
    setState(() {});
  }

  sendEvent(String event) {
    TrackUtils.trackEvent(event);
  }

  onScoreChanged(int score) {
    setState(() {
      currentScore = score;
    });
  }

  String getPageName() {
    print('getPageName ========== ${runtimeType.toString()}');
    return runtimeType.toString();
  }

  void onCreate() {}

  double getPaddingTop() => MediaQuery.of(context).padding.top;

  double getPaddingBottom() => MediaQuery.of(context).padding.bottom;

  double getPaddingRight() => MediaQuery.of(context).padding.right;

  void onResume() {
    isResumed = true;
    TrackUtils.onResume(getPageName());

    print('base state onresume');
  }

  void onPause() {
    isResumed = false;
    TrackUtils.onPause(getPageName());
  }

  void onDestroy() {}
}
