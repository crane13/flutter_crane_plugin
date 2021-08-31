import 'dart:io';

import 'package:craneplugin/ui/page/LoadingPage.dart';
import 'package:craneplugin/ui/page/MoreGamePage.dart';
import 'package:craneplugin/ui/page/SettingsPage.dart';
import 'package:craneplugin/ui/page/TosPage.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';

import 'CommonUtils.dart';

class BaseJumpUtils {
  static void jumpSettingsPage(BuildContext context,
      {String appName,
      String shareContent,
      String shareImage,
      String downloadUrl,
      String rateUrl,
      String iconPath}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new SettingsPage(
              app_name: appName,
              share_content: shareContent,
              download_url: downloadUrl,
              share_image: shareImage,
              rate_url: rateUrl,
              icon_path: iconPath,
            )));
  }

  static void jumpTOSPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new TosPage()));
  }

  static void jumpMoreAppPage(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      CommonUtils.openUrl('https://apps.apple.com/developer/id1061441649');
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => new MoreGamePage()));
    }
    TrackUtils.trackEvent('jumpMoreAppPage');
  }

  static void jumpStudio() {
    String url = 'https://cranedev123.github.io/';
    CommonUtils.openUrl(url);
  }

  static void jumpLoadingPage(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) {
          return LoadingPage();
        }));
//    Navigator.of(context)
//        .push(MaterialPageRoute(builder: (context) => new LoadingPage()));
  }
}
