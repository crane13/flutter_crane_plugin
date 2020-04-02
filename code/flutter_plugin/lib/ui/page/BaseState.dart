import 'package:craneplugin/utils/theme/ThemeType.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  bool isResumed = false;

  initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
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

  String getPageName() {
    print('getPageName ========== ${runtimeType.toString()}');
    return runtimeType.toString();
  }

  void onCreate() {}

  double getPaddingTop() => MediaQuery.of(context).padding.top;

  double getPaddingBottom() => MediaQuery.of(context).padding.bottom;

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
