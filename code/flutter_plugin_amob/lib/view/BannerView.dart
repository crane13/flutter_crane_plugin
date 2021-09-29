import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const PLUGIN_VIEW = 'plugins.crane.view/GGView';
const PLUGIN_EVENT = 'plugins.crane.view/GGEvent';

class BannerView extends StatefulWidget {
  void Function(String)? listener;

  String title;

  dynamic params;

  double padding_h = 0;
  double maxHeight = 0;

  final BannerController? controller;

  BannerView(
      {Key? key,
      this.title = '',
      this.params,
      this.controller,
      this.padding_h = 0,
      this.maxHeight = 0,
      this.listener})
      : super(key: key);

  BannerViewState createState() => new BannerViewState();
}

class BannerViewState extends State<BannerView> {
  var _eventChannel = const EventChannel(PLUGIN_VIEW);

  StreamSubscription? _subscription;

  MethodChannel? _channel;

  @override
  void initState() {
    super.initState();
    if (_subscription == null) {
      _subscription = _eventChannel
          .receiveBroadcastStream()
          .listen(_onEvent, onError: _onError);
    }
  }

  void _onEvent(Object? value) {
    String event = value.toString();
    if (event != null && event.length > 0) {
      print('_onEvent == $event');
      widget.listener!(event);
    }
  }

  void _onError(dynamic) {}

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: getHeight()),
      child: Padding(
          padding:
              EdgeInsets.fromLTRB(widget.padding_h, 0, widget.padding_h, 0),
          child: _buildNativeView()),
    );
  }

  Widget _buildNativeView() {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: PLUGIN_VIEW,
        creationParams: widget.params,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    } else if (Platform.isAndroid) {
      return AndroidView(
        viewType: PLUGIN_VIEW,
        creationParams: widget.params,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          _onPlatformViewCreated(id);
        },
      );
    }
    return SizedBox();
  }

  void _onPlatformViewCreated(int id) {
    _channel = MethodChannel('${PLUGIN_VIEW}_$id');
    _channel?.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCaptured') {
        // if (widget.onCapture != null)
        //   widget.onCapture!(call.arguments.toString());
      }
    });
    widget.controller?._channel = _channel;
  }

  bool isLarge() {
    return 'large' == widget.params['size'];
  }

  double getHeight() {
    if (widget.maxHeight > 0) {
      return widget.maxHeight;
    }
    double height = isLarge() ? 250 : 60;
    if (isPad() && isLarge()) {
      height = height * 1.5;
    }
    return height;
  }

  bool isPad() {
    return false;
  }

  @override
  void dispose() {
    if (_subscription != null) {
      _subscription!.cancel();
    }
    super.dispose();
  }
}

class BannerController {
  MethodChannel? _channel;

  BannerController();

  void load() {
    _channel?.invokeMethod("load");
  }

  void setSize(String size) {
    _channel?.invokeMethod("setSize", {'size': size});
  }
}
