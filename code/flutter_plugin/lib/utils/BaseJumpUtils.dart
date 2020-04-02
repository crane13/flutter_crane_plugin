import 'dart:io';

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
      String downloadUrl,
      String rateUrl,
      String iconPath}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new SettingsPage(
              app_name: appName,
              share_content: shareContent,
              download_url: downloadUrl,
              rate_url: rateUrl,
              icon_path: iconPath,
            )));
  }

  static void jumpTOSPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => new TosPage()));
  }

  static void jumpMoreAppPage(BuildContext context) {
    if (Platform.isIOS) {
      CommonUtils.openUrl('https://apps.apple.com/developer/id1061441649');
    } else {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => new MoreGamePage()));
    }
    TrackUtils.trackEvent('jumpMoreAppPage');
  }
}
