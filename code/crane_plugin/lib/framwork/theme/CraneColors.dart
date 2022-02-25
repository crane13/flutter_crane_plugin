import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'ThemeType.dart';

class CraneColors {
  static const Color colorPrimary = Colors.white;
  static const Color txt_black = Color(0xff1a1a1a);
  static const Color txt_grey = Color(0xffb1b1b1);
  static const Color txt_hint = Color(0xffa7ada3);
  static const Color line_divider = Color(0xfff2f2f2);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color black_translucence_88 = Color(0x88000000);


  static Color getBlackColor() {
    return ThemeType.isDarkMode() ? Colors.black : Colors.white;
  }

  static Color getBgSettingColor() {
    return ThemeType.isDarkMode() ? black : Colors.white;
  }

  static Color getNavBarBgColor() {
    return ThemeType.isDarkMode() ? Colors.black26 : Colors.white;
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

  static Color? getDividerColor() {
    return ThemeType.isDarkMode() ? Colors.white24 : Colors.grey[200];
  }

  static Color getBgColor() {
    return ThemeType.isDarkMode() ? black : colorPrimary;
  }
  static Color getBgDialogColor() {
    return ThemeType.isDarkMode() ? Color(0xff3c3935) : black_translucence_88;
  }
}
