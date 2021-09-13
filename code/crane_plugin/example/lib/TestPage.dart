import 'package:crane_plugin/framwork/router/BaseJumpUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  TestPage({Key? key}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: GestureDetector(
            onTap: () {
              // AUtils.showBanner();
              // AUtils.showPopNow();
              // AUtils.showVideo();
              // BaseJumpUtils.jumpMoreAppPage(context);
              BaseJumpUtils.jumpSettingsPage(context);
            },
            child: Text('Running on: \n'),
          ),
        ));
  }
}
