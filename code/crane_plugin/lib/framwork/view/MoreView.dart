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

const double itemW = 50;
const double padding = 10;

class MoreView extends StatefulWidget {
  static const double H = itemW * 2 + padding * 2 + 15;

  const MoreView({Key? key}) : super(key: key);

  @override
  _MoreViewState createState() => _MoreViewState();
}

class _MoreViewState extends BaseState<MoreView> {
  List<AppItem> appList = [];

  @override
  void initState() {
    super.initState();
    loadData();
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
              color: CraneColors.txt_grey, fontSize: 14),
          _buildAppListView()
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
          child: V.buildNetImageView(item.icon, itemW));
    }
    return SizedBox();
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
}
