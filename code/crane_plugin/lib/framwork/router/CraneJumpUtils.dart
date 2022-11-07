import 'package:crane_plugin/framwork/page/LoadingPage.dart';
import 'package:crane_plugin/framwork/page/SettingsPage.dart';
import 'package:crane_plugin/framwork/page/TosPage.dart';
import 'package:crane_plugin/framwork/utils/FlutterGG.dart';
import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
import 'package:crane_plugin/framwork/utils/track/TrackUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// import 'package:url_launcher/url_launcher_string.dart';

import '../K.dart';

class CraneJumpUtils {
  static void jumpSettingsPage(BuildContext context,
      {String shareContent = '',
      String shareImage = '',
      String iconPath = K.ICON_DEFAULT}) {
    jump(
        context,
        SettingsPage(
          share_content: shareContent,
          share_image: shareImage,
          icon_path: iconPath,
        ));
  }

  static void jumpTOSPage(BuildContext context) {
    jump(context, TosPage());
  }

  static void jumpMoreAppPage(BuildContext context) {
    if (PlatformUtils.isApple()) {
      openUrl('https://apps.apple.com/developer/id1061441649');
    } else {
      openUrl('https://www.taptap.cn/developer/84820');
      // jump(context, MoreGamePage());
    }
    TrackUtils.trackEvent('jumpMoreAppPage');
  }

  static void openUrl(String url) async {
    // if (await canLaunchUrlString(url)) {
    //   await launchUrlString(url);
    // } else {}
    FlutterGG.lanchView(url);
  }

  static void jumpRankPage(BuildContext context) {
    FlutterGG.showRank(0);
  }

  static void jumpAchievementPage(BuildContext context) {
    FlutterGG.showAchievement();
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

  static Future<dynamic> jump(BuildContext context, Widget widget) async {
    if (context != null && widget != null) {
      return Navigator.of(context)
          .push(CupertinoPageRoute(builder: (context) => widget));
    }
    return null;
  }
}
