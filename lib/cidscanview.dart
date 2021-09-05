import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

typedef void CIDScanViewCreatedCallback(CIDScanViewController controller);

class CIDScanView extends StatefulWidget {
  const CIDScanView({
    Key key,
    this.onCIDScanViewCreated,
  }): super(key: key);

  final CIDScanViewCreatedCallback onCIDScanViewCreated;

  @override
  State<StatefulWidget> createState() => _CIDScanViewState();
}

class _CIDScanViewState extends State<CIDScanView> {
  Widget build(BuildContext context) {
    final String viewType = 'app.captureid.captureidlibrary/cidscanview';
    final Map<String, dynamic> creationParams = <String, dynamic>{};

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'app.captureid.captureidlibrary/cidscanview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return UiKitView(
        viewType: 'cidscanview',
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