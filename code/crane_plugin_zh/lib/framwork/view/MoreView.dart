import 'package:crane_plugin/framwork/bean/app_list_entity.dart';
import 'package:crane_plugin/framwork/page/base/BaseState.dart';
import 'package:crane_plugin/framwork/page/base/V.dart';
import 'package:crane_plugin/framwork/router/CraneJumpUtils.dart';
import 'package:crane_plugin/framwork/theme/CraneColors.dart';
import 'package:crane_plugin/framwork/utils/AUtils.dart';
import 'package:crane_plugin/framwork/utils/ArrayUtils.dart';
import 'package:crane_plugin/framwork/utils/ConfigUtils.dart';
import 'package:crane_plugin/framwork/utils/PlatformUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoreView extends StatefulWidget {
  double itemW = 50;
  double padding = 10;
  Color titleColor = CraneColors.txt_grey;

  MoreView(
      {Key? key,
      this.itemW = 50,
      this.padding = 10,
      this.titleColor = CraneColors.txt_grey})
      : super(key: key);

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends BaseState<MoreView> {
  List<AppItem> appList = [];
  double itemW = 50;
  double padding = 10;

  @override
  void initState() {
    super.initState();
    itemW = widget.itemW;
    padding = widget.padding;
    Future.delayed(Duration(seconds: 0), () {
      loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ArrayUtils.isEmpty(appList)) {
      return SizedBox();
    }
    return Container(
      width: itemW * 5 + padding * 6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          V.buildText('MORE FREE GAMES',
              color: widget.titleColor, fontSize: 14),
          SizedBox(
            width: itemW * 5 + padding * 4,
            child: _buildAppListView(),
          )
        ],
      ),
    );
  }

  Widget _buildAppListView() {
    return GridView.builder(
      padding: EdgeInsets.all(padding),
      itemCount: ArrayUtils.getCount(appList),
      itemBuilder: _buildItem,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          mainAxisSpacing: padding,
          crossAxisSpacing: padding,
          childAspectRatio: 1.0),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    AppItem? item = ArrayUtils.getItem(appList, index);
    if (item != null) {
      return GestureDetector(
          onTap: () {
            CraneJumpUtils.openUrl(item.link);
          },
          child: Container(
            color: CraneColors.line_divider,
            child: Image.network(item.icon, fit: BoxFit.cover),
          ));
    }
    return SizedBox();
  }

  void loadData() {
    // if (PlatformUtils.isMacOS()) {
    //   return;
    // }
    if (PlatformUtils.isIOS()) {
      if (!AUtils.isEnable()) {
        return;
      }
    }
    ConfigUtils.loadAppList(context).then((list) {
      setState(() {
        if (list != null) {
          if (list.length > 10) {
            appList = list.sublist(0, 10);
          } else {
            appList = list;
          }
        }
      });
    });
  }
}
