import 'package:craneplugin/bean/app_list_entity.dart';
import 'package:craneplugin/generated/i18n.dart';
import 'package:craneplugin/ui/view/CommonViews.dart';
import 'package:craneplugin/utils/CommonUtils.dart';
import 'package:craneplugin/utils/ConfigUtils.dart';
import 'package:craneplugin/utils/BaseColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BaseState.dart';

class MoreGamePage extends StatefulWidget {
  MoreGamePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MoreGamePageState();
  }
}

class _MoreGamePageState extends BaseState<MoreGamePage> {
  List<AppItem> appList = [];

  @override
  void initState() {
    super.initState();
    loadData();
//    AUtils.showBanner();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: BaseColors.getNavBarBgColor(),
      navigationBar: CupertinoNavigationBar(
        backgroundColor: BaseColors.getNavBarBgColor(),
        actionsForegroundColor: BaseColors.getNavBarColor(),
        previousPageTitle: S.of(context).back,
        middle: Text('More', style: TextStyle(color: BaseColors.getNavBarColor()),),
      ),
      child: getContentView(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget getContentView() {
    if (appList == null || appList.length <= 0) {
      return Center(
        child: CommonViews.getLoadingView(),
      );
    }
    return Material(
      type: MaterialType.transparency,
      child: ListView.builder(
        itemCount: appList.length,

//        padding: EdgeInsets.all(15),
        itemBuilder: (BuildContext context, int index) {
          return getItem(index, appList[index]);
        },
//        shrinkWrap: true,
      ),
    );
  }

  Widget getItem(int index, AppItem appItem) {
    double paddingBottom = index == appList.length - 1 ? 60 : 0;
    String iconUrl =
        CommonUtils.isStringEmpty(appItem.icon) ? '' : appItem.icon;
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(15, 15, 15, paddingBottom),
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.network(
          iconUrl,
          height: 50,
          width: 50,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(appItem.getName(),
          overflow: TextOverflow.clip,
          style: TextStyle(
              color: BaseColors.getTxtTitleColor(),
              fontSize: 20,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
      onTap: () {
        CommonUtils.openUrl(appItem.link);
      },
      trailing: Icon(CupertinoIcons.forward, color: BaseColors.getTxtDetailColor()),
//              subtitle: Icon(CupertinoIcons.forward),
//              leading: Text('Contact us'),
    );
  }

  List<Widget> getBtnList() {
    List<Widget> wigetList = [];

    wigetList.add(GestureDetector(
      child: ListBody(
        children: <Widget>[
          Text('More Games'),
          Icon(CupertinoIcons.right_chevron),
        ],
      ),
    ));
    return wigetList;
  }

  void loadData() {
    ConfigUtils.loadAppList(context).then((list) {
      setState(() {
        appList = list;
      });
    });
  }
}
