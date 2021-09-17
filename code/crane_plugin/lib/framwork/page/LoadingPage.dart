import 'dart:async';

import 'package:crane_plugin/framwork/theme/CraneColors.dart';
import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'base/BaseState.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _LoadingPageState();
  }
}

class _LoadingPageState extends BaseState<LoadingPage> {
  Color bgColor = Colors.black54;

  double size = ConfigUtils.isPad ? 1.5 : 1.0;

  Timer? timer;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.transparent,
//      appBar: new AppBar(
//        title: const Text('New entry'),
//        actions: [
//          new FlatButton(
//              onPressed: () {
//                //TODO: Handle save
//              },
//              child: new Text('SAVE',
//                  style: Theme.of(context)
//                      .textTheme
//                      .subhead
//                      .copyWith(color: Colors.white))),
//        ],
//      ),
      body: getContentView(),
    );
  }

  Widget getContentView() {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          color: Colors.transparent,
          height: size.height,
          width: size.width,
          child: Center(
            child: Container(
              height: 80,
              width: 80,
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.black87,
//                    shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(6))),
//          decoration:
//              BoxDecoration(border: Border.all(style: BorderStyle.solid)),
              child: getLoadingView(),
            ),
          ),
        ));
  }

  static getLoadingView() {
    return SpinKitFadingCircle(
      color: CraneColors.txt_black,
      size: 60,
      duration: Duration(seconds: 1),
    );
  }

  @override
  void onPause() {
    super.onPause();
  }

  @override
  void onResume() {
    super.onResume();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void onHomeClicked() {
    popWithOption(0);
  }

  void onReplayClicked() {
    popWithOption(1);
  }

  void onNextClicked() {
    popWithOption(2);
  }

  void popWithOption(int option) {
    Navigator.of(context).pop(option);
  }
}
