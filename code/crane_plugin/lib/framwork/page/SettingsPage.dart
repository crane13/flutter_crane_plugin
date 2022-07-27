import 'dart:async';

import 'package:crane_plugin/framwork/bean/app_list_entity.dart';
import 'package:crane_plugin/framwork/router/CraneJumpUtils.dart';
import 'package:crane_plugin/framwork/theme/CraneColors.dart';
import 'package:crane_plugin/framwork/theme/ThemeType.dart';
import 'package:crane_plugin/framwork/utils/AUtils.dart';
import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/framwork/utils/FlutterGG.dart';
import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
import 'package:crane_plugin/framwork/utils/TextUtils.dart';
import 'package:crane_plugin/framwork/utils/track/TrackUtils.dart';
import 'package:crane_plugin/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../K.dart';
import 'base/BaseState.dart';
import 'base/V.dart';

class SettingsPage extends StatefulWidget {
  String share_content;
  String share_image;
  String icon_path;

  SettingsPage(
      {Key? key,
      this.share_content = '',
      this.share_image = '',
      this.icon_path = K.ICON_DEFAULT})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SettingsPageState();
  }
}

class SettingsPageState extends BaseState<SettingsPage> {
  List<AppItem> appList = [];

  String appVersion = '';

  Timer? timer;

  IconData iconTheme = Icons.brightness_4;

  int lastPressDown = 0;
  int clickTimes = 0;

  @override
  void initState() {
    super.initState();

    loadData();
    AUtils.showBanner(isTop: false);

    timer = new Timer(const Duration(milliseconds: 300), () {
      FlutterGG.getplatformVersion().then((version) {
        setState(() {
          if (version != null && version.length > 0) {
            appVersion = '  v$version';
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return V.buildPage(context, S.of(context).settings, _buildContent());
  }

  Widget _buildContent() {
    List<Widget> arrWidgets = [];

    arrWidgets.add(Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Divider(
          height: 50,
          color: Colors.transparent,
        ),
        // GestureDetector(
        //   onLongPressDown: (LongPressDownDetails details){
        //     lastPressDown = DateTime.now().millisecondsSinceEpoch;
        //   },
        //   onLongPressUp: (){
        //     int duration = DateTime.now().millisecondsSinceEpoch - lastPressDown;
        //     if(duration > 10 * 1000){
        //         AUtils.aClosed = true;
        //         AUtils.showBannerEnable(false);
        //     }
        //   },
        //   child: V.buildLogoView(widget.icon_path),)
        // ,
        GestureDetector(
            child: V.buildLogoView(widget.icon_path),
            onTap: () {
              if (clickTimes <= 0) {
                lastPressDown = DateTime.now().millisecondsSinceEpoch;
              }
              int duration =
                  DateTime.now().millisecondsSinceEpoch - lastPressDown;
              if (duration > 60 * 1000) {
                clickTimes = 0;
                lastPressDown = DateTime.now().millisecondsSinceEpoch;
              }
              clickTimes++;
              if (clickTimes >= 10) {
                AUtils.aClosed = true;
                AUtils.showBannerEnable(false);
              }
            }),
        Divider(
          height: 30,
          color: Colors.transparent,
        ),
        V.buildText('${S.of(context).app_name} $appVersion',
            color: ThemeType.isDarkMode() ? Colors.white54 : Colors.grey[350]!,
            fontSize: 15),
        Divider(
          height: 20,
          color: Colors.transparent,
        ),
      ],
    ));

    if (isSupportDark()) {
      arrWidgets.add(buildItem(S.of(context).theme, iconTheme, () {
        selectTheme();
      }, value: ThemeType.getThemeStr(context)));
    }

    if (PlatformUtils.isApple()) {
      arrWidgets.add(buildItem(S.of(context).rank, null, () {
        CraneJumpUtils.jumpRankPage(context);
      }, imagePath: 'packages/crane_plugin/assets/images/rank.png'));
    }
    List<Widget> custormWidgets = buildCustormWidgets();
    if (custormWidgets != null && custormWidgets.length > 0) {
      arrWidgets.addAll(custormWidgets);
    }
//    if (Platform.isIOS) {
//      arrWidgets.add(getItem(S.of(context).restore, Icons.refresh, () {
//        BaseJumpUtils.jumpLoadingPage(context);
//        FlutterGG.restoreByPage(context).then((complete) {
//          Navigator.of(context).pop();
//          CommonUtils.showToast(context, S.of(context).complete);
//        });
//      }));
//    }

    arrWidgets.add(buildItem(S.of(context).rate, Icons.star, () async {
      CraneJumpUtils.openUrl(await K.getRateUrl());
    }));

//    arrWidgets.add(getItem(S.of(context).share, Icons.share, () {
//      CommonUtils.shareApp(context, widget.app_name, widget.share_content,
//          widget.download_url, widget.share_image);
//    }));

//    arrWidgets.add(getItem(S.of(context).feedback, Icons.feedback, () {
//      CommonUtils.feedback();
//    }));

    arrWidgets.add(buildItem(S.of(context).tos, Icons.library_books, () {
      CraneJumpUtils.jumpTOSPage(context);
    }));

    if (appList == null || appList.length <= 0) {
      arrWidgets.add(buildItem(S.of(context).more_games, Icons.more_horiz, () {
        CraneJumpUtils.jumpMoreAppPage(context);
      }));
    }

    List<Widget> arrCustorms = getCustormWidgets();

    if (arrCustorms != null && arrCustorms.length > 0) {
      arrWidgets.addAll(arrCustorms);
    }

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

      arrWidgets.add(_buildAppListView());
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

  List<Widget> buildCustormWidgets() {
    return [];
  }

  Widget _buildAppListView() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: appList.length,
//        padding: EdgeInsets.all(15),
      itemBuilder: (BuildContext context, int index) {
        return _buildAppItemView(index, appList[index]);
      },
      separatorBuilder: (context, position) {
        return Divider(height: 1, color: CraneColors.getDividerColor());
      },
//        shrinkWrap: true,
    );
  }

  Widget buildItem(String title, IconData? icon, onPress,
      {String value = '', String imagePath = ''}) {
    return Column(children: <Widget>[
      ListTile(
        leading: icon != null
            ? Icon(icon, color: CraneColors.getSettingIconColor())
            : V.buildImage(imagePath,
                w: 25, color: CraneColors.getSettingIconColor()),
        title: V.buildText(title,
            color: CraneColors.getTxtTitleColor(),
            fontSize: 15,
            fontWeight: FontWeight.normal),
        onTap: onPress,
        trailing: Wrap(
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            V.buildText('$value', color: CraneColors.getTxtDetailColor()),
            Icon(CupertinoIcons.forward, color: CraneColors.getTxtDetailColor())
          ],
        ),
      ),
      Divider(
        height: 1,
        color: CraneColors.getDividerColor(),
      )
    ]);
  }

  void selectTheme() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          backgroundColor: CraneColors.getBgDialogColor(),
//          title: new Text('选择'),
          children: <Widget>[
            _buildDialogOption(Icons.brightness_high, S.of(context).theme_light,
                ThemeType.THEME_LIGHT),
            _buildDialogOption(Icons.brightness_4, S.of(context).theme_dark,
                ThemeType.THEME_DARK),
            _buildDialogOption(Icons.brightness_auto,
                S.of(context).theme_systerm, ThemeType.THEME_SYSTERM),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }

  Widget _buildDialogOption(IconData icon, String title, int theme) {
    return SimpleDialogOption(
      child: Row(
        children: <Widget>[
          Icon(icon, color: CraneColors.getTxtDetailColor()),
          VerticalDivider(color: Colors.transparent, width: 10),
          V.buildText(title, color: CraneColors.white)
        ],
      ),
      onPressed: () {
        ThemeType.setThemeType(theme);
        refreshUI();
        Navigator.of(context).pop();
      },
    );
  }

  void refreshUI() {
    setState(() {
      iconTheme = ThemeType.getThemeIcon();
    });
  }

  Widget _buildAppItemView(int index, AppItem appItem) {
    double paddingBottom = index == appList.length - 1 ? 60 : 5;
    String iconUrl = TextUtils.isEmpty(appItem.icon) ? '' : appItem.icon;
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(15, 5, 15, paddingBottom),
      leading: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: V.buildNetImageView(iconUrl, 40)),
      title: V.buildText(appItem.getName(),
          color: CraneColors.getTxtTitleColor(),
          fontSize: 15,
          fontWeight: FontWeight.normal),
      onTap: () {
        CraneJumpUtils.openUrl(appItem.link);
        TrackUtils.trackEvent('jumpAppPage==${appItem.package}');
      },
      trailing:
          Icon(CupertinoIcons.forward, color: CraneColors.getTxtDetailColor()),
    );
  }

  void loadData() {
    if (PlatformUtils.isMacOS()) {
      return;
    }
    if (PlatformUtils.isIOS()) {
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

  List<Widget> getCustormWidgets() {
    return [];
  }

  bool isSupportDark() {
    return true;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
