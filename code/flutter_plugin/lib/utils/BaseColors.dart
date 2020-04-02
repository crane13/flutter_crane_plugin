import 'package:craneplugin/utils/theme/ThemeType.dart';
import 'package:flutter/material.dart';

class BaseColors {
//  static bool isDarkMode = false;

//  static const bgColor = Colors.black;
  static const blackColor = Colors.black;
  static const whiteColor = Colors.black87;
  static const txtblackColor = Colors.white;

//  static const mainColor = Colors.amber;
  static const mainColor = Color(0xffE0E3DA);

//  static const mainColor = Color(0xffA593E0);

//  static const mainColor = Colors.black;
//
  static const bgColor = Color(0xffA593E0);

//  static const bgColor = Color(0xff379392);
//  static const blackColor = Colors.black;
//  static const whiteColor = Colors.black87;
//  static const txtblackColor = Colors.white;

//  static void isDarkMode()
//  {
//    return themeType ==
//  }

  static Color getBlackColor() {
    return ThemeType.isDarkMode() ? Colors.black : Colors.white;
  }

  static Color getBgSettingColor() {
    return ThemeType.isDarkMode() ? blackColor : Colors.white;
  }

  static Color getNavBarBgColor() {
    return ThemeType.isDarkMode() ? Colors.black : Colors.white;
  }

  static Color getNavBarColor() {
    return ThemeType.isDarkMode() ? Colors.white : Colors.black87;
  }

  static Color getTxtTitleColor() {
    return ThemeType.isDarkMode() ? Colors.white : Colors.black87;
  }

  static Color getSettingIconColor() {
    return ThemeType.isDarkMode() ? Colors.white : Colors.black54;
  }

  static Color getTxtDetailColor() {
    return ThemeType.isDarkMode() ? Colors.white54 : Colors.grey;
  }

  static Color getDividerColor() {
    return ThemeType.isDarkMode() ? Colors.white24 : Colors.grey[200];
  }

  static Color getBgColor() {
    return ThemeType.isDarkMode() ? blackColor : bgColor;
  }
}
