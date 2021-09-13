import 'package:crane_plugin/framwork/theme/CraneColors.dart';
import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'base/BaseState.dart';
import 'base/V.dart';

class TosPage extends StatefulWidget {
  TosPage({Key? key}) : super(key: key);

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
    return V.buildPage(context, S.of(context).tos, _buildContentView());
  }

  Widget _buildContentView() {
    return Material(
        type: MaterialType.transparency,
        child: ListView(
          padding: EdgeInsets.all(15),
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Text(
              tosString,
              style: TextStyle(color: CraneColors.getTxtTitleColor()),
            ),
            Divider(
              height: 60,
              color: Colors.transparent,
            )
          ],
        ));
  }
}
