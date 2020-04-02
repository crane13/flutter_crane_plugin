import 'dart:async';
import 'dart:io';

import 'package:craneplugin/bean/app_list_entity.dart';
import 'package:craneplugin/generated/i18n.dart';
import 'package:craneplugin/ui/page/BaseState.dart';
import 'package:craneplugin/utils/AUtils.dart';
import 'package:craneplugin/utils/BaseColors.dart';
import 'package:craneplugin/utils/BaseJumpUtils.dart';
import 'package:craneplugin/utils/CommonUtils.dart';
import 'package:craneplugin/utils/ConfigUtils.dart';
import 'package:craneplugin/utils/FlutterGG.dart';
import 'package:craneplugin/utils/theme/ThemeType.dart';
import 'package:craneplugin/utils/track/TrackUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  String app_name;
  String share_content;
  String download_url;
  String rate_url;
  String icon_path;

  SettingsPage(
      {Key key,
      this.app_name,
      this.share_content,
      this.download_url,
      this.rate_url,
      this.icon_path = ''})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _SettingsPageState();
  }
}

class _SettingsPageState extends BaseState<SettingsPage> {
  List<AppItem> appList = [];

  String appVersion = '';

  Timer timer;

  IconData iconTheme = Icons.brightness_4;

  @override
  void initState() {
    super.initState();
    loadData();
    AUtils.showBanner();

    timer = new Timer(const Duration(milliseconds: 300), () {
      FlutterGG.getplatformVersion().then((version) {
        setState(() {
          if (version != null && version.length > 0) {
            appVersion = '  v${version}';
          }
        });
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
//        middle: Text(S.of(context).add_success_diary),
//        trailing: GestureDetector(
//          child: Text(
//            S.of(context).choose_color,
//            style: TextStyle(color: CusColors.whiteColor),
//          ),
//          onTap: chooseColor,
//        ),
      ),
      child: getContentView(),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget getContentView() {
    List<Widget> arrWidgets = [];

    arrWidgets.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Divider(
          height: 50,
          color: Colors.transparent,
        ),
        Image.asset(
          widget.icon_path,
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Divider(
          height: 30,
          color: Colors.transparent,
        ),
        Text(
          widget.app_name + '${appVersion}',
          style: TextStyle(
              color: ThemeType.isDarkMode() ? Colors.white54 : Colors.grey[350],
              fontSize: 15),
        ),
        Divider(
          height: 20,
          color: Colors.transparent,
        ),
      ],
    ));

    arrWidgets.add(buildThemeView(S.of(context).theme, iconTheme, () {}));

    if (appList == null || appList.length <= 0) {
      arrWidgets.add(getItem(S.of(context).more_games, Icons.more_horiz, () {
        BaseJumpUtils.jumpMoreAppPage(context);
      }));
    }

    arrWidgets.add(getItem(S.of(context).rate, Icons.star, () {
      CommonUtils.openUrl(widget.rate_url);
    }));

    arrWidgets.add(getItem(S.of(context).share, Icons.share, () {
      CommonUtils.shareApp(
          context, widget.app_name, widget.share_content, widget.download_url);
    }));

//    arrWidgets.add(getItem(S.of(context).feedback, Icons.feedback, () {
//      CommonUtils.feedback();
//    }));

    arrWidgets.add(getItem(S.of(context).tos, Icons.library_books, () {
      BaseJumpUtils.jumpTOSPage(context);
    }));

    if (appList != null && appList.length > 0) {
      arrWidgets.add(Container(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
        alignment: Alignment.centerLeft,
        color: ThemeType.isDarkMode() ? Colors.white12 : Colors.grey[200],
        height: 40,
        child: Text(
          S.of(context).other_works,
          style: TextStyle(
              fontSize: 12,
              color: ThemeType.isDarkMode() ? Colors.white54 : Colors.black38),
        ),
      ));

      arrWidgets.add(getAppListView());
    }

    return Material(
        type: MaterialType.transparency,
        child: ListView(
          scrollDirection: Axis.vertical,
//      mainAxisAlignment: MainAxisAlignment.start,
//      crossAxisAlignment: CrossAxisAlignment.center,
          children: arrWidgets,
        ));
  }

  Widget getAppListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: appList.length,
//        padding: EdgeInsets.all(15),
      itemBuilder: (BuildContext context, int index) {
        return getAppItemView(index, appList[index]);
      },
      separatorBuilder: (context, position) {
        return Divider(
          height: 1,
          color: BaseColors.getDividerColor(),
        );
      },
//        shrinkWrap: true,
    );
  }

  Widget getItem(String title, IconData icon, onPress) {
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(
            icon,
            color: BaseColors.getSettingIconColor(),
          ),
          title: Text(title,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  color: BaseColors.getTxtTitleColor(),
                  fontSize: 15,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.normal)),
          onTap: onPress,
          trailing: Icon(
            CupertinoIcons.forward,
            color: BaseColors.getTxtDetailColor(),
          ),
//              subtitle: Icon(CupertinoIcons.forward),
//              leading: Text('Contact us'),
        ),
        Divider(
          height: 1,
          color: BaseColors.getDividerColor(),
        )
      ],
    );
  }

  Widget buildThemeView(String title, IconData icon, onPress) {
    return GestureDetector(
      onTap: () {
        selectTheme();
      },
      child: Column(children: <Widget>[
        Container(
          height: 50,
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: BaseColors.getSettingIconColor(),
              ),
              VerticalDivider(
                width: 30,
                color: Colors.transparent,
              ),
              Expanded(
                child: Text(title,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        color: BaseColors.getTxtTitleColor(),
                        fontSize: 15,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal)),
              ),
              Text(
                ThemeType.getThemeStr(context),
                style: TextStyle(color: BaseColors.getTxtDetailColor()),
              ),
              Icon(
                CupertinoIcons.forward,
                color: BaseColors.getTxtDetailColor(),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: BaseColors.getDividerColor(),
        )
      ]),
    );
  }

  void selectTheme() {
    bool isDark = ThemeType.isDarkMode();
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          backgroundColor: isDark ? Color(0xff3c3935) : Colors.white,
//          title: new Text('选择'),
          children: <Widget>[
            new SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.brightness_high,
                    color: BaseColors.getTxtDetailColor(),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 10,
                  ),
                  Text(
                    S.of(context).theme_light,
                    style: TextStyle(
                      color: BaseColors.getTxtTitleColor(),
                    ),
                  )
                ],
              ),
              onPressed: () {
                ThemeType.setThemeType(ThemeType.THEME_LIGHT);
                refreshUI();
                Navigator.of(context).pop();
              },
            ),
            new SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.brightness_4,
                    color: BaseColors.getTxtDetailColor(),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 10,
                  ),
                  Text(S.of(context).theme_dark,
                      style: TextStyle(
                        color: BaseColors.getTxtTitleColor(),
                      ))
                ],
              ),
              onPressed: () {
                ThemeType.setThemeType(ThemeType.THEME_DARK);
                refreshUI();
                Navigator.of(context).pop();
              },
            ),
            new SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.brightness_auto,
                    color: BaseColors.getTxtDetailColor(),
                  ),
                  VerticalDivider(
                    color: Colors.transparent,
                    width: 10,
                  ),
                  Text(S.of(context).theme_systerm,
                      style: TextStyle(
                        color: BaseColors.getTxtTitleColor(),
                      ))
                ],
              ),
              onPressed: () {
                ThemeType.setThemeType(ThemeType.THEME_SYSTERM);
                refreshUI();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }

  void refreshUI() {
    setState(() {
      iconTheme = ThemeType.getThemeIcon();
    });
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

  Widget getAppItemView(int index, AppItem appItem) {
    double paddingBottom = index == appList.length - 1 ? 60 : 5;
    String iconUrl =
        CommonUtils.isStringEmpty(appItem.icon) ? '' : appItem.icon;
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(15, 5, 15, paddingBottom),
      leading: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Image.network(
          iconUrl,
          height: 40,
          width: 40,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(appItem.getName(),
          overflow: TextOverflow.clip,
          style: TextStyle(
              color: BaseColors.getTxtTitleColor(),
              fontSize: 15,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.normal)),
      onTap: () {
        CommonUtils.openUrl(appItem.link);
        TrackUtils.trackEvent('jumpAppPage==${appItem.package}');
      },
      trailing:
          Icon(CupertinoIcons.forward, color: BaseColors.getTxtDetailColor()),
    );
  }

  void loadData() {
    if (Platform.isIOS) {
      if (!AUtils.isEnable()) {
        return;
      }
    }
    ConfigUtils.loadAppList(context).then((list) {
      setState(() {
        appList = list;
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
