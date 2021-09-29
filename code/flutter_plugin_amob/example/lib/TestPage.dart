import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_plugin_amob/flutter_plugin_amob.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  String packageName = 'Plugin example app';

  bool isVideoReady = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('$packageName'),
        ),
        body: _buildContent());
  }

  Widget _buildContent() {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          buildButton('isVideoReady : $isVideoReady', () {
            FlutterPluginAmob.isRewardVideoReady().then((value) {
              setState(() {
                setState(() {
                  isVideoReady = value;
                });
              });
            });
          }),
          buildButton('showRewardAd', () {
            FlutterPluginAmob.showRewardAd();
          }),
          buildButton('pop', () {
            FlutterPluginAmob.showPopAd();
          }),
          buildButton('showBannerAd', () {
            FlutterPluginAmob.showBannerAd();
          }),
          buildButton('setShowBanner true', () {
            FlutterPluginAmob.setShowBanner(true);
          }),
          buildButton('setShowBanner false', () {
            FlutterPluginAmob.setShowBanner(false);
          }),
        ],
      ),
    );
  }

  /// Button
  static Widget buildButton(String txt, Function onClicked,
      {double fontSize = 14,
      Color bgColor = Colors.white,
      Color color = Colors.black12,
      int maxLines = 10,
      FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.center,
      double height = 40}) {
    return FlatButton(
      color: bgColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          side: BorderSide(
              color: Colors.white, style: BorderStyle.solid, width: 2)),
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
}
