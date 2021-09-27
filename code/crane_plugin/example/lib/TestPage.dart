import 'package:crane_plugin/framwork/page/base/V.dart';
import 'package:crane_plugin/framwork/router/CraneJumpUtils.dart';
import 'package:crane_plugin/framwork/utils/AUtils.dart';
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
        body: _buildContent());
  }

  Widget _buildContent() {
    return Container(
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        children: [
          V.buildButton('tos', () {
            CraneJumpUtils.jumpTOSPage(context);
          }),
          V.buildButton('more', () {
            CraneJumpUtils.jumpMoreAppPage(context);
          }),
          V.buildButton('settings', () {
            CraneJumpUtils.jumpSettingsPage(context);
          }),
          V.buildButton('loading', () {
            CraneJumpUtils.jumpLoadingPage(context);
          }),
          V.buildButton('rank', () {
            CraneJumpUtils.jumpRankPage(context);
          }),
          V.buildButton('pop', () {
            AUtils.showPopNow();
          }),
        ],
      ),
    );
  }
}
