import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crane_plugin/framwork/theme/CraneColors.dart';
import 'package:crane_plugin/framwork/utils/AUtils.dart';
import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
import 'package:crane_plugin/framwork/utils/TextUtils.dart';
import 'package:crane_plugin/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../K.dart';

class V {
  static MaterialApp buildApp(Widget homePage, String title, {Theme? theme}) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
          // 全局设置字体大小不随系统的设置而变化
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!),
      debugShowCheckedModeBanner: false,
      title: 'Mine Sweeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homePage,
      localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (S.delegate.isSupported(deviceLocale!)) {
        } else {
          deviceLocale = S.delegate.supportedLocales[0];
        }
        ConfigUtils.locale = deviceLocale;
        return deviceLocale;
      },
    );
  }

  static Widget buildNotifyWidget(Widget child, Function callback) {
    if (child == null) {
      return SizedBox();
    }
    return NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollStartNotification) {
            if (callback != null) {
              callback(false);
            }
          } else if (scrollNotification is ScrollUpdateNotification) {
            if (callback != null) {
              callback(true);
            }
          } else if (scrollNotification is ScrollEndNotification) {
            if (callback != null) {
              callback(false);
            }
          }
          return false;
        },
        child: child);
  }

  /// CupertinoPageScaffold
  static Widget buildPage(BuildContext context, String title, Widget child,
      {List<Widget>? actionItems,
      bool showBottomLine = true,
      bool showNavigationBar = true,
      bool isBgTranslate = false,
      bool useSafeArea = true,
      Widget? leading}) {
    Widget trailing = SizedBox();
    if (actionItems != null && actionItems.length > 0) {
      trailing = Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: actionItems,
      );
    }

    if (leading == null) {
      leading = GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 50,
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.arrow_back_ios_new,
            color: CraneColors.getTxtTitleColor(),
            size: 20,
          ),
        ),
      );
    }

    return Theme(
        data: ThemeData(
            primaryColor: CraneColors.colorPrimary,
            accentColor: CraneColors.white,
            cursorColor: CraneColors.txt_black,
            hintColor: CraneColors.txt_hint,
            backgroundColor:
                isBgTranslate ? CraneColors.transparent : CraneColors.white,
            dividerColor: CraneColors.line_divider),
        child: CupertinoPageScaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: isBgTranslate
                ? CraneColors.transparent
                : CraneColors.getBgSettingColor(),
            navigationBar: showNavigationBar
                ? CupertinoNavigationBar(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 0, 12, 0),
                    leading: leading,
                    middle: Text(
                      '$title',
                      style: TextStyle(
                          fontSize: 17,
                          color: CraneColors.getTxtTitleColor(),
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: trailing,
                    backgroundColor: isBgTranslate
                        ? CraneColors.transparent
                        : CraneColors.getNavBarBgColor(),
//                    actionsForegroundColor: BaseColors.getNavBarColor(),
                    border: Border(
                        bottom: BorderSide(
                            color: showBottomLine
                                ? CraneColors.getDividerColor()!
                                : CraneColors.transparent,
                            width: 0.5)),
                  )
                : null,
            child: useSafeArea ? SafeArea(child: child) : child));
  }

  /// Text Button
  static Widget buildButtonText(String txt, Function onClicked,
      {double fontSize = 14,
      Color color = CraneColors.txt_black,
      int maxLines = 10,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start}) {
    return GestureDetector(
      onTap: () {
        if (onClicked != null) {
          onClicked();
        }
      },
      child: buildText(txt,
          fontSize: fontSize,
          color: color,
          maxLines: maxLines,
          fontWeight: fontWeight,
          textAlign: textAlign),
    );
  }

  /// TextView
  static Widget buildText(String txt,
      {double fontSize = 14,
      Color color = CraneColors.txt_black,
      int maxLines = 10,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      String? fontFamily = 'Roboto'}) {
    if (TextUtils.isEmpty(txt)) {
      txt = '';
    }
    if (color == null) {
      color = CraneColors.getTxtTitleColor();
    }
    return Text(
      '$txt',
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontSize: fontSize,
          decoration: TextDecoration.none,
          fontWeight: fontWeight),
    );
  }

  /// ImageView from asset
  static Widget buildImage(String img,
      {double w = 20,
      double h = -1,
      BoxFit fit = BoxFit.contain,
      Color? color}) {
    if (h < 0) {
      h = w;
    }
    return Image.asset(
      '$img',
      width: w,
      height: h,
      fit: fit,
      color: color,
    );
  }

  /// ImageButton
  static Widget buildImageButton(String img,
      {double w = 20,
      double h = -1,
      BoxFit fit = BoxFit.contain,
      Color? color,
      Function? onClicked}) {
    return GestureDetector(
      onTap: () {
        if (onClicked != null) {
          onClicked();
        }
      },
      child: buildImage(img, w: w, color: color, fit: fit, h: h),
    );
  }

  /// CommonLoading View
  static Widget buildLoadingView() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
            child: SpinKitThreeBounce(
          color: CraneColors.txt_hint,
          size: 30,
        )));
  }

  static Widget buildLoadingHeaderFootor() {
    return SpinKitThreeBounce(
      color: CraneColors.colorPrimary,
      size: 20,
    );
  }

  /// CommonError View
  static Widget buildErrorView({String errorMsg = ''}) {
    if (TextUtils.isEmpty(errorMsg)) {
      errorMsg = '木有数据哦';
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Container(
        height: double.infinity,
        color: CraneColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
//            buildImage(R.empty_project, w: 100),
            SizedBox(
              height: 15,
            ),
            buildText(
              errorMsg,
              fontSize: 14,
              color: CraneColors.txt_grey,
            ),
          ],
        ),
      ),
    );
  }

  /// Button
  static Widget buildButton(String txt, Function onClicked,
      {double fontSize = 14,
      Color bgColor = CraneColors.transparent,
      Color color = CraneColors.white,
      int maxLines = 10,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.center,
      double height = 40}) {
    return FlatButton(
      color: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(
              color: CraneColors.white, style: BorderStyle.solid, width: 2)),
      clipBehavior: Clip.antiAlias,
      onPressed: () {
        if (onClicked != null) {
          onClicked();
        }
      },
      child: Container(
        alignment: Alignment.center,
        height: height,
        child: Text('$txt',
            maxLines: maxLines,
            textAlign: textAlign,
            style: TextStyle(
                color: color,
                fontSize: fontSize,
                decoration: TextDecoration.none,
                fontWeight: fontWeight)),
      ),
    );
  }

  /// Button
  static Widget buildButtonSplash(String txt, Function onClicked,
      {double fontSize = 14,
      Color bgColor = CraneColors.transparent,
      int maxLines = 10,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.center,
      double height = 50}) {
    BorderRadius borderRadius = BorderRadius.all(Radius.circular(0));
    return FlatButton(
      padding: EdgeInsets.all(0),
      color: bgColor,
      highlightColor: CraneColors.transparent,
//      shape: RoundedRectangleBorder(
//          borderRadius: borderRadius,
//          side: BorderSide(
//              color: MyColors.text_transparent,
//              style: BorderStyle.solid,
//              width: 2)),
//      clipBehavior: Clip.antiAlias,
      onPressed: () {
        if (onClicked != null) {
          onClicked();
        }
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: CraneColors.black_translucence_88,
            borderRadius: borderRadius,
            border: Border.all(color: CraneColors.line_divider, width: 1)),
        alignment: Alignment.center,
        height: height,
//        child: Container(
//          decoration: DashedDecoration(
//            dashedColor: BaseColors.getTxtTitleColor(),
//            color: MyColors.text_transparent,
//            gap: 3,
//            borderRadius: borderRadius,
//          ),
//          alignment: Alignment.center,
//          height: height,
        child: Text('$txt',
            maxLines: maxLines,
            textAlign: textAlign,
            style: TextStyle(
                color: CraneColors.white,
                fontSize: fontSize,
                decoration: TextDecoration.none,
                fontWeight: fontWeight)),
//        ),
      ),
    );
  }

  /// EditText
  static Widget buildEditText(TextEditingController controller, String hint,
      {Function? onChanged,
      String initTxt = '',
      TextInputType textInputType = TextInputType.text,
      int maxLines = 1,
      FocusNode? focusNode}) {
    bool obscureText = textInputType == TextInputType.visiblePassword;
    double height = maxLines > 1 ? 1.5 : 1.3;
    if (controller != null) {
      controller.addListener(() {
        if (controller.text == 'null') {
          controller.text = '';
        }
      });
    }
    return CupertinoTextField(
      autofocus: false,
      controller: controller,
//      strutStyle: StrutStyle(forceStrutHeight: true, height: 1, leading: 1),

//                      onChanged: onChanged,
      maxLines: maxLines,
      obscureText: obscureText,
      style: TextStyle(
        color: CraneColors.white,
        fontSize: 14,
        fontStyle: FontStyle.normal,
        height: height,
      ),
      placeholderStyle: TextStyle(
          color: Colors.white70,
          fontSize: 14,
          fontStyle: FontStyle.normal,
          height: height),
      cursorWidth: 1.5,
      focusNode: focusNode,
      keyboardType: textInputType,
      cursorRadius: Radius.circular(2),
      cursorColor: CraneColors.white,
//      onChanged: onChanged,
      textAlign: TextAlign.end,
      placeholder: hint,
      decoration: BoxDecoration(color: CraneColors.transparent),

//        decoration: InputDecoration(
//            fillColor: Colors.white,
//            border: OutlineInputBorder(borderSide: BorderSide.none),
//            contentPadding: EdgeInsets.fromLTRB(10.0, 10, 0, 10),
//            hintText: hint,
//            hintStyle: TextStyle(color: MyColors.text_hint))
    );
  }

  static Widget buildRowKeyValue(String key, String value,
      {Color keyColor = CraneColors.txt_black,
      Color valueColor = CraneColors.txt_grey,
      double minKeyWidth = 80,
      Widget rightButton = const SizedBox()}) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: V.buildText('$key', color: keyColor),
            constraints: BoxConstraints(minWidth: minKeyWidth),
          ),
          Expanded(
            flex: 1,
            child: V.buildText('$value', color: valueColor),
          ),
          rightButton,
        ],
      ),
    );
  }

  static Widget buildRowKeyValueEdit(
      String key, String hint, TextEditingController controller,
      {Function? onChanged,
      String value = '',
      TextInputType textInputType = TextInputType.text,
      Color keyColor = CraneColors.white,
      Color valueColor = CraneColors.white,
      double minKeyWidth = 80,
      FocusNode? focusNode}) {
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: V.buildText('$key', color: keyColor),
            constraints: BoxConstraints(minWidth: minKeyWidth),
          ),
          Expanded(
            flex: 1,
            child: V.buildEditText(controller, hint,
                textInputType: textInputType,
                onChanged: onChanged,
//                focusNode: focusNode,
                initTxt: value),
          )
        ],
      ),
    );
  }

  /// 输入备注 多行输入
  static Widget buildRowKeyValueEditBz(
      String key, String hint, TextEditingController controller,
      {Function? onChanged,
      String value = '',
      TextInputType textInputType = TextInputType.text,
      Color keyColor = CraneColors.txt_black,
      Color valueColor = CraneColors.txt_grey}) {
    double minKeyWidth = 80;
    return Container(
      alignment: Alignment.center,
      constraints: BoxConstraints(minHeight: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: V.buildText('$key', color: keyColor),
            constraints: BoxConstraints(minWidth: minKeyWidth),
          ),
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border:
                      Border.all(width: 0.5, color: CraneColors.line_divider)),
              child: V.buildEditText(controller, hint,
                  maxLines: 5,
                  textInputType: textInputType,
                  onChanged: onChanged,
                  initTxt: value),
            ),
          )
        ],
      ),
    );
  }

  static void displayDatePicker(
    BuildContext context,
    DateTime initialDate,
    Function callback, {
    DateTime? startDate,
  }) {
//    _showDatePickerAndroid(context, initialDate, callback,
//        startDate: startDate);
    if (PlatformUtils.isIOS()) {
      _showCupertinoDatePickerIos(context, initialDate, callback,
          startDate: startDate);
    } else {
      _showDatePickerAndroid(context, initialDate, callback,
          startDate: startDate);
    }
  }

  static void _showDatePickerAndroid(
    BuildContext context,
    DateTime initialDate,
    Function callback, {
    DateTime? startDate,
  }) async {
    if (startDate == null) {
      startDate = DateTime(1990);
    }
    if (initialDate == null) {
      initialDate = DateTime.now();
    }
    var result = await showDatePicker(
        initialDatePickerMode: DatePickerMode.day,
        context: context,
        initialDate: initialDate,
        firstDate: startDate,
        lastDate: DateTime.now());
    if (result != null) {
      if (callback != null) {
        callback(result);
      }
    }
  }

  static void _showCupertinoDatePickerIos(
    BuildContext context,
    DateTime initialDate,
    Function callback, {
    DateTime? startDate,
  }) {
    if (startDate == null) {
      startDate = DateTime(2000);
    }
    if (initialDate == null) {
      initialDate = DateTime.now();
    }
    final picker = CupertinoDatePicker(
      onDateTimeChanged: (date) {
        if (callback != null) {
          callback(date);
        }
      },
      mode: CupertinoDatePickerMode.date,
      initialDateTime: initialDate,
      minimumDate: startDate,
      maximumDate: DateTime.now(),
    );

    showCupertinoModalPopup(
        context: context,
        builder: (cxt) {
          return Container(
            color: CraneColors.white,
            height: 200,
            child: picker,
          );
        });
  }

  static Widget buildButtonIcon(IconData icondata, Function onClicked,
      {Color bgColor = CraneColors.transparent, double w = 0}) {
    double size = ConfigUtils.getScaleSize();
    if (w <= 0) {
      w = 30;
    }
    return RaisedButton(
      padding: EdgeInsets.all(10),
      onPressed: () {
        if (onClicked != null) {
          onClicked();
        }
      },
      highlightColor: bgColor,
      color: bgColor,
      child: Icon(
        icondata,
        size: w,
        color: Colors.white,
      ),
      shape: CircleBorder(
        side: BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  static Widget buildLightIcon(IconData icondata, Function onClicked,
      {Color bgColor = CraneColors.transparent, double w = 0}) {
    double size = ConfigUtils.getScaleSize();
    if (w <= 0) {
      w = 30 * size;
    }
    return RaisedButton(
      padding: EdgeInsets.all(2 * size),
      onPressed: () {
        if (onClicked != null) {
          onClicked();
        }
      },
      highlightColor: bgColor,
      color: bgColor,
      child: Icon(
        icondata,
        size: w,
        color: Colors.white,
      ),
      shape: CircleBorder(
        side: BorderSide(color: Colors.white, width: 2),
      ),
    );
  }

  static Widget buildDivider() {
    return Divider(
      color: CraneColors.line_divider,
    );
  }

  static Widget buildLogoView(String icon_path) {
    return Container(
        height: 100,
        width: 100,
        padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        decoration: BoxDecoration(
            border: Border.all(color: CraneColors.txt_hint, width: 1.0),
            borderRadius: BorderRadius.circular(18)),
        child: Image.asset(
          icon_path,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ));
  }

  static Widget buildLargeAView(
      {double w = 300,
      double h = 250,
      String text = '',
      double txtSize = 30,
      bool showAd = true}) {
    return Container(
      padding: EdgeInsets.all(5),
      width: w,
      height: h,
      color: Colors.transparent,
//      decoration:
//          BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
      child: Stack(
        overflow: Overflow.clip,
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
//          Image.asset(
//            '',
//            fit: BoxFit.cover,
//            width: w,
//            height: h,
//          ),
          Text(text,
              style: TextStyle(
                  color: CraneColors.white,
                  fontSize: txtSize,
//                  fontFamily: Const.COMMON_FONT_NAME,
                  fontWeight: FontWeight.w700)),
          (showAd != null && showAd)
              ? AUtils.getAView(size: 'large', maxHeight: h)
              : SizedBox()
        ],
      ),
    );
  }

  /// ImageVIew from url
  static Widget buildNetImageView(String imageUrl, double w,
      {String placeholder = K.ICON_DEFAULT,
      double aspectRatio = 1 / 1,
      double radius = 0}) {
    return Container(
      width: w,
      child: AspectRatio(
          aspectRatio: aspectRatio,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                placeholder: (BuildContext context, String url) =>
                    Image.asset(placeholder),
                fit: BoxFit.cover,
              ))),
    );
  }
}
