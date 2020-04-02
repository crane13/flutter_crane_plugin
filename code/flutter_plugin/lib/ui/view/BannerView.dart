import 'dart:async';
import 'dart:io';

import 'package:craneplugin/utils/ConfigUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const PLUGIN_VIEW = 'plugins.crane.view/GGView';
const PLUGIN_EVENT = 'plugins.crane.view/GGEvent';

class BannerView extends StatefulWidget {
  void Function(String) listener;

  String title;

  dynamic params;

  double padding_h = 0;
  double maxHeight = 0;

  BannerView(
      {Key key,
      this.title,
      this.params,
      this.padding_h,
      this.maxHeight = 0,
      this.listener})
      : super(key: key);

  BannerViewState createState() => new BannerViewState();
}

class BannerViewState extends State<BannerView> {
  var _eventChannel = const EventChannel(PLUGIN_VIEW);

  StreamSubscription _subscription = null;

  @override
  void initState() {
    super.initState();
    if (_subscription == null) {
      _subscription = _eventChannel
          .receiveBroadcastStream()
          .listen(_onEvent, onError: _onError);
    }
  }

  void _onEvent(Object value) {
    String event = value.toString();
    if (event != null && event.length > 0) {
      print('_onEvent == $event');
      widget.listener(event);
    }
  }

  void _onError(dynamic) {}

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return getAdViewAndroid();
    } else if (Platform.isIOS) {
      return getAdViewIOS();
    }
    return null;
  }

  bool isLarge() {
    return 'large' == widget.params['size'];
  }

  Widget getAdViewAndroid() {
    return new ConstrainedBox(
      constraints: BoxConstraints(maxHeight: getHeight()),
      child: Padding(
          padding:
              EdgeInsets.fromLTRB(widget.padding_h, 0, widget.padding_h, 0),
          child: new AndroidView(
            viewType: PLUGIN_VIEW,
            creationParams: widget.params,
            creationParamsCodec: const StandardMessageCodec(),
          )),
    );
  }

  double getHeight() {
    if (widget.maxHeight > 0) {
      return widget.maxHeight;
    }
    double height = isLarge() ? 250 : 60;
    if (ConfigUtils.isPad && isLarge()) {
      height = height * 1.5;
    }
    return height;
  }

  Widget getAdViewIOS() {
    return new ConstrainedBox(
      constraints: BoxConstraints(maxHeight: getHeight()),
      child: Padding(
          padding:
              EdgeInsets.fromLTRB(widget.padding_h, 0, widget.padding_h, 0),
          child: new UiKitView(
            viewType: PLUGIN_VIEW,
            creationParams: widget.params,
            creationParamsCodec: const StandardMessageCodec(),
          )),
    );
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription.cancel();
    }
    super.dispose();
  }
}
