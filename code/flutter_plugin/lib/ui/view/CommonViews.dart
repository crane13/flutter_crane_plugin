import 'package:craneplugin/utils/AUtils.dart';
import 'package:craneplugin/utils/ConfigUtils.dart';
import 'package:craneplugin/utils/BaseColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommonViews {
  static getLoadingView() {
    return SpinKitFadingCircle(
      color: BaseColors.txtblackColor,
      size: 60,
      duration: Duration(seconds: 1),
    );
  }

  static getCommonBack(BuildContext context) {
//    return Text('');

    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: 40,
        height: 40,
        child: RaisedButton(
          padding: EdgeInsets.all(0.0),
          color: BaseColors.getBgColor(),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          shape: CircleBorder(
            side: BorderSide(color: Colors.white, width: 3),
          ),
        ),
      ),
    );
  }

  static getCommonButton(
      BuildContext context, IconData iconData, Function onPress) {
//    return Text('');

    return Padding(
      padding: EdgeInsets.all(20),
      child: SizedBox(
        width: 45,
        height: 45,
        child: RaisedButton(
          padding: EdgeInsets.all(0.0),
          color: Colors.transparent,
          elevation: 0,
          onPressed: () {
            onPress();
          },
          child: Icon(
            iconData,
            color: Colors.white,
            size: 45,
          ),
//          shape: CircleBorder(
//            side: BorderSide(color: Colors.white, width: 2),
//          ),
        ),
      ),
    );
  }

  static Widget getDialogImageView({String imagePath = ''}) {
    return Container(
      width: 300.0 * ConfigUtils.getScaleSize(),
      height: 250.0 * ConfigUtils.getScaleSize(),
      decoration:
          BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
      child: Stack(
        // overflow: Overflow.clip,
        fit: StackFit.loose,
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            imagePath,
            fit: BoxFit.cover,
            width: 300.0 * ConfigUtils.getScaleSize(),
            height: 250.0 * ConfigUtils.getScaleSize(),
          ),
          AUtils.getAView(size: 'large')
        ],
      ),
    );
  }

  static Widget getBtnBottom(IconData icondata, var callback,
      {double iconSize = 30}) {
    Color bgColor = Colors.transparent;
    return RaisedButton(
      padding: EdgeInsets.all(10 * ConfigUtils.getScaleSize()),
      onPressed: callback,
      highlightColor: bgColor,
      color: bgColor,
      child: Icon(
        icondata,
        size: iconSize * ConfigUtils.getScaleSize(),
        color: Colors.white,
      ),
      shape: CircleBorder(
        side: BorderSide(
            color: Colors.white, width: 2 * ConfigUtils.getScaleSize()),
      ),
    );
  }

//  static Widget getWidgetTrue(double itemW) {
////    return Text(
////      '1',
////      style: TextStyle(color: Colors.black87),
////    );
//    return Image.asset(
//      'assets/image_dance.gif',
//      fit: BoxFit.contain,
//      width: itemW,
//    );
//  }
//
//  static Widget getWidgetFalse(double itemW) {
////    return Text('-1', style: TextStyle(color: Colors.black87));
//
//    return Image.asset(
//      'assets/img_normal.jpg',
//      fit: BoxFit.contain,
//      width: itemW,
//    );
//  }
}
