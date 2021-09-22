import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef void CIDScanViewCreatedCallback(CIDScanViewController controller);

class CIDScanView extends StatefulWidget {
  final int width;
  final int height;

  const CIDScanView({
    Key key,
    this.width,
    this.height,
    this.onCIDScanViewCreated,
  }): super(key: key);

  final CIDScanViewCreatedCallback onCIDScanViewCreated;

  @override
  State<StatefulWidget> createState() {
    return _CIDScanViewState();
  }
}

class _CIDScanViewState extends State<CIDScanView> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final String viewType = 'app.captureid.captureidlibrary/cidscanview';
    final Map<String, dynamic> creationParams = <String, dynamic>{};
    creationParams['width'] = widget.width;
    creationParams['height'] = widget.height;

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'app.captureid.captureidlibrary/cidscanview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return UiKitView(
        creationParams: creationParams,
        viewType: 'fluttercidscanview',
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onCIDScanViewCreated == null) {
      return;
    }
    widget.onCIDScanViewCreated(new CIDScanViewController._(id));
  }
}

class CIDScanViewController {
  CIDScanViewController._(int id): _channel = new MethodChannel('app.captureid.captureidlibrary/cidscanview_$id');

  final MethodChannel _channel;

  Future<void> startDecode() async {
    return _channel.invokeMethod('startDecode');
  }

  Future<void> startScanner() async {
    return _channel.invokeMethod('startScanner');
  }

}