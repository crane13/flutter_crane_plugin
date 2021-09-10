// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mine_clear/framwork/page/MoreGamePage.dart';
// import 'package:flutter_mine_clear/framwork/page/SettingsPage.dart';
// import 'package:flutter_mine_clear/framwork/page/TosPage.dart';
// import 'package:flutter_mine_clear/framwork/utils/track/TrackUtils.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class BaseJumpUtils {
//   static void jumpSettingsPage(BuildContext context,
//       {String shareContent, String shareImage, String iconPath}) {
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => new SettingsPage(
//               share_content: shareContent,
//               share_image: shareImage,
//               icon_path: iconPath,
//             )));
//   }
//
//   static void jumpTOSPage(BuildContext context) {
//     _jump(context, TosPage());
//   }
//
//   static void jumpMoreAppPage(BuildContext context) {
//     if (Platform.isIOS) {
//       openUrl('https://apps.apple.com/developer/id1061441649');
//     } else {
//       _jump(context, MoreGamePage());
//     }
//     TrackUtils.trackEvent('jumpMoreAppPage');
//   }
//
//   static void openUrl(String url) async {
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {}
//   }
//
//   static Future<dynamic> _jump(BuildContext context, Widget widget) async {
//     if (context != null && widget != null) {
//       return Navigator.of(context)
//           .push(CupertinoPageRoute(builder: (context) => widget));
//     }
//     return null;
//   }
// }
