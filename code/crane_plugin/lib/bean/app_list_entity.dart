import 'package:crane_plugin/utils/ConfigUtils.dart';

class AppListEntity {
  List<AppItem> appList = [];

  AppListEntity({this.appList = const []});

  AppListEntity.fromJson(Map<String, dynamic> json) {
    if (json['appList'] != null) {
      appList = [];
      (json['appList'] as List).forEach((v) {
        appList.add(new AppItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appList != null) {
      data['appList'] = this.appList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AppItem {
  String nameZh = '';
  String package = '';
  String name = '';
  String icon = '';
  String link = '';

  AppItem(
      {this.nameZh = '',
      this.package = '',
      this.name = '',
      this.icon = '',
      this.link = ''});

  AppItem.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      nameZh = json['name_zh'];
      package = json['package'];
      name = json['name'];
      icon = json['icon'];
      link = json['link'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name_zh'] = this.nameZh;
    data['package'] = this.package;
    data['name'] = this.name;
    data['icon'] = this.icon;
    data['link'] = this.link;
    return data;
  }

  String getName() {
    if (ConfigUtils.isChinese()) {
      return nameZh;
    }
    return name;
  }
}
