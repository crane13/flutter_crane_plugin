import 'dart:io';

import 'package:craneplugin/ui/page/MoreGamePage.dart';
import 'package:craneplugin/ui/page/SettingsPage.dart';
import 'package:craneplugin/ui/page/TosPage.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/material.dart';

import 'CommonUtils.dart';

class BaseJumpUtils {
  static void jumpSettingsPage(BuildContext context,
      {String app_name,
      String share_content,
      String download_url,
      String rate_url,
      String icon_path}) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => new SettingsPage(
              app_name: app_name,
              share_content: share_content,
              download_url: download_url,
              rate_url: rate_url,
              icon_path: icon_path,
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
