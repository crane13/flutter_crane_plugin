import 'dart:convert';

import 'package:craneplugin/K.dart';
import 'package:craneplugin/bean/app_list_entity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const LOCAL_CONFIG_PATH = 'assets/configs_sudoku_online.json';

class ConfigUtils {
  static var isPad = false;

  static Locale _locale;

  static setLocale(Locale locale) {
    _locale = locale;
  }

  static bool isChinese() {
    return _locale != null && _locale.languageCode == 'zh';
  }

  static double getScaleSize() {
    return isPad ? 1.5 : 1.0;
  }

  static Future<List<AppItem>> loadAppList(BuildContext context) async {
    List<AppItem> list = await _loadAppListfromServer();
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

  static Future<List<AppItem>> _loadAppListFromAssets(
      BuildContext context) async {
    try {
      var configJson = await DefaultAssetBundle.of(context)
          .loadString(K.getMoreListLocal());
      print('_loadAppListFromAssets');
      var response = json.decode(
          new Utf8Decoder(allowMalformed: true).convert(configJson.codeUnits));

      return AppListEntity.fromJson(response).appList;
    } catch (e) {
      return null;
    }
  }

  static Future<List<AppItem>> _loadAppListfromServer() async {
    try {
      var resp = await http.get(K.getMoreListUrl());
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
      String configJson = await DefaultAssetBundle.of(context)
          .loadString(isChinese() ? 'assets/tos_zh.txt' : 'assets/tos.txt');
      return configJson;
    } catch (e) {
      return '';
    }
  }
}
