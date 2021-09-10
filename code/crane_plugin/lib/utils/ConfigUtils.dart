import 'dart:convert';

import 'package:crane_plugin/bean/app_list_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../K.dart';

class ConfigUtils {
  static bool _isPad = false;

  static Locale? _locale;

  static Size? _screenSize;

  static var _isScreenH = false;

  static get isPad => _isPad != null && _isPad;

  static set isPad(value) {
    _isPad = value;
  }

  static get isScreenH => _isScreenH;

  static set isScreenH(value) {
    _isScreenH = value;
  }

  static Locale get locale => _locale!;

  static set locale(Locale value) {
    _locale = value;
  }

  static Size get screenSize => _screenSize!;

  static set screenSize(Size value) {
    _screenSize = value;
  }

  static bool isChinese() {
    return _locale != null && _locale!.languageCode == 'zh';
  }

  static double getScaleSize() {
    return _isPad ? 1.5 : 1.0;
  }

  static Future<List<AppItem>> loadAppList(BuildContext context) async {
    List<AppItem>? list = await _loadAppListfromServer();
    if (list == null || list.length <= 0) {
      list = await _loadAppListFromAssets(context);
    }
    List<AppItem> resultList = [];
    if (list != null && list.length > 0) {
      for (AppItem item in list) {
        if (item != null && item.package != K.getPackage()) {
          resultList.add(item);
        }
      }
    }
    return resultList;
  }

  static Future<List<AppItem>?> _loadAppListFromAssets(
      BuildContext context) async {
    try {
      var configJson =
          await DefaultAssetBundle.of(context).loadString(K.getMoreListLocal());
      print('_loadAppListFromAssets');
      var response = json.decode(
          new Utf8Decoder(allowMalformed: true).convert(configJson.codeUnits));

      return AppListEntity.fromJson(response).appList;
    } catch (e) {
      return null;
    }
  }


  static Future<List<AppItem>?> _loadAppListfromServer() async {
    try {
      var resp = await http.get(K.getMoreListUrlForHttp());
      var response = json.decode(
          new Utf8Decoder(allowMalformed: true).convert(resp.bodyBytes));
      print('_loadAppListfromServer === ${response}');
      return AppListEntity.fromJson(response).appList;
    } catch (e) {
      print(e);
      return null;
    } finally {}
  }

  static Future<String> loadTOSFromAssets(BuildContext context) async {
    try {
      String configJson = await DefaultAssetBundle.of(context).loadString(
          isChinese() ? 'assets/tos/tos_zh.txt' : 'assets/tos/tos.txt');
      return configJson;
    } catch (e) {
      return '';
    }
  }
}
