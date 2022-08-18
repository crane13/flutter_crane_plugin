import 'dart:convert';

import 'package:crane_plugin/framwork/bean/app_list_entity.dart';
import 'package:crane_plugin/framwork/utils/ArrayUtils.dart';
import 'package:crane_plugin/framwork/utils/CacheUtils.dart';
import 'package:crane_plugin/framwork/utils/FlutterGG.dart';
import 'package:crane_plugin/framwork/utils/L.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../K.dart';

class ConfigUtils {
  static const APP_LIST_CACHE_NAME = "app_list_name";
  static const APP_LIST_LAST_LOAD = "app_list_last_load";
  static bool _isPad = false;

  static Locale? _locale;

  static Size? _screenSize;

  static var _isScreenH = false;

  static get isPad => _isPad != null && _isPad;

  static set isPad(value) {
    _isPad = value;
  }

  static setScreenSize(Size size) {
    screenSize = size;
  }

  static get isScreenH => _isScreenH;

  static set isScreenH(value) {
    _isScreenH = value;
  }

  static Locale get locale => _locale!;

  static set locale(Locale value) {
    _locale = value;
  }

  // static Size? get screenSize => _screenSize != null ? _screenSize : null;

  static Size? getScreenSize() {
    return _screenSize;
  }

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
    List<AppItem>? list = await _loadAppListfromCache();
    if (list == null || list.length <= 0) {
      list = await _loadAppListFromAssets(context);
    }
    String packageName = await FlutterGG.getPackageName();
    List<AppItem> resultList = [];
    if (list != null && list.length > 0) {
      for (AppItem item in list) {
        if (item != null && item.package != packageName) {
          resultList.add(item);
        }
      }
    }
    _checkLoadServer();
    return resultList;
  }

  static Future<void> _checkLoadServer() async {
    DateTime now = DateTime.now();
    now = now.add(Duration(days: -3));
    DateTime? last;
    String? lastTime = await CacheUtils.getStringByKey(APP_LIST_LAST_LOAD);
    if (lastTime != null) {
      last = DateTime.parse(lastTime);
    }
    if (last == null || now.isAfter(last)) {
      _loadAppListfromServer();
    }
  }

  static Future<List<AppItem>?> _loadAppListFromAssets(
      BuildContext context) async {
    try {
      var configJson =
          await DefaultAssetBundle.of(context).loadString(K.getMoreListLocal());
      L.log('_loadAppListFromAssets');
      var response = jsonDecode(configJson);

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
      L.log('_loadAppListfromServer === ${response}');
      var list = AppListEntity.fromJson(response).appList;
      if (!ArrayUtils.isEmpty(list)) {
        CacheUtils.setStringWithKey(APP_LIST_CACHE_NAME, resp.body);
        CacheUtils.setStringWithKey(APP_LIST_LAST_LOAD, DateTime.now().toIso8601String());
      }
      return list;
    } catch (e) {
      L.log(e);
      return null;
    } finally {}
  }

  static Future<List<AppItem>?> _loadAppListfromCache() async {
    try {
      String? cache = await CacheUtils.getStringByKey(APP_LIST_CACHE_NAME);
      if (cache != null) {
        var response = json.decode(
            new Utf8Decoder(allowMalformed: false).convert(cache.codeUnits));
        // var response = jsonDecode(cache);

        L.log('_loadAppListfromCache === ${response}');
        return AppListEntity.fromJson(response).appList;
      }
    } catch (e) {
      L.log(e);
      return null;
    } finally {}
  }

  static Future<String> loadTOSFromAssets(BuildContext context) async {
    try {
      String configJson = await DefaultAssetBundle.of(context).loadString(
          isChinese()
              ? 'packages/crane_plugin/assets/tos/tos_zh.txt'
              : 'packages/crane_plugin/assets/tos/tos.txt');
      L.log('loadTOSFromAssets : $configJson');
      return configJson;
    } catch (e) {
      L.log(e);
      return '';
    }
  }
}
