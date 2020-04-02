import 'package:craneplugin/generated/i18n.dart';
import 'package:craneplugin/ui/page/BaseState.dart';
import 'package:craneplugin/utils/ConfigUtils.dart';
import 'package:craneplugin/utils/BaseColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TosPage extends StatefulWidget {
  TosPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _TosPageState();
  }
}

class _TosPageState extends BaseState<TosPage> {
  String tosString = '';

  @override
  void initState() {
    super.initState();
    ConfigUtils.loadTOSFromAssets(context).then((tos) {
      setState(() {
        tosString = tos;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: BaseColors.getBgSettingColor(),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: BaseColors.getNavBarBgColor(),
        actionsForegroundColor: BaseColors.getNavBarColor(),
        previousPageTitle: S.of(context).back,
        middle: Text(
          S.of(context).tos,
          style: TextStyle(color: BaseColors.getNavBarColor()),
        ),
      ),
      child: getContentView(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget getContentView() {
    return Material(
        type: MaterialType.transparency,
        child: ListView(
          padding: EdgeInsets.all(15),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(
              tosString,
              style: TextStyle(color: BaseColors.getTxtTitleColor()),
            ),
            Divider(
              height: 60,
              color: Colors.transparent,
            )
          ],
        ));
  }
}
