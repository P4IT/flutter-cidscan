
import 'dart:async';
import 'package:flutter/services.dart';

typedef void MultiUseCallback(dynamic msg);
typedef void CancelListening();

class FlutterCidscan {
  static const MethodChannel _channel = const MethodChannel('flutter_cidscan');
  static const EventChannel _initChannel = EventChannel('cidscan_init');
  static const EventChannel _licenseChannel = EventChannel('cidscan_license');
  static const EventChannel _decodeChannel = EventChannel('cidscan_decode');

  static Stream _initCallback;
  static Stream _licenseCallback;
  static Stream _decodeCallback;

  static Stream initCaptureID(String message, bool useCallback, bool requestPermsOnInit) {
    _channel.invokeMethod('initCaptureID', <String, dynamic> {
      'message': message,
      'useCallback': useCallback,
      'requestPermsOnInit': requestPermsOnInit
    });
    _initCallback = _initChannel.receiveBroadcastStream();
    return _initCallback;
  }

  static Stream activateEDKLicense(String key, String customerID) {
    _channel.invokeMethod('activateEDKLicense', <String, dynamic> {
      'key': key,
      'customerID': customerID
    });
    _licenseCallback = _licenseChannel.receiveBroadcastStream();
    return _licenseCallback;
  }

  static void changeBeepPlayerSound(String sound) {
    _channel.invokeMethod('changeBeepPlayerSound', <String, dynamic> {
      'sound': sound
    });
  }

  static void  closeCamera() {
    _channel.invokeMethod('closeCamera');
  }

  static void closeSharedObject() {
    _channel.invokeMethod('closeSharedLibrary');
  }

  static Future<Map> currentSizeOfDecoderVideo() async {
    return await _channel.invokeMapMethod('currentSizeOfDecoderVideo');
  }

  static void decoderTimeLimitInMilliseconds(int milliseconds) {
    _channel.invokeMethod('decoderTimeLimitInMilliseconds', <String, dynamic> {
      'millisecconds': milliseconds
    });
  }

  static void setTorch(bool enable) {
    _channel.invokeMethod('setTorch', <String, dynamic> {
      'enable': enable
    });
  }

  static Future<String> decoderVersion() async {
    return await _channel.invokeMethod('decoderVersion');
  }

  static Future<String> decoderVersionLevel() async {
    return _channel.invokeMethod('decoderVersionLevel');
  }

  static void enableFixedExposureMode(bool enabled, int exposureValue) {
    _channel.invokeMethod('enableFixedExposureMode', <String, dynamic> {
      'enabled': enabled,
      'exposureValue': exposureValue
    });
  }

  static void enableScannedImageCapture(bool enable) {
    _channel.invokeMethod('enableScannedImageCapture', <String, dynamic> {
      'enable': enable
    });
  }

  static void ensureRegionOfInterest(bool enable) {
    _channel.invokeMethod('ensureRegionOfInterest', <String, dynamic> {
      'enable': enable
    });
  }

  static void enableAllDecoders(bool enable) {
    _channel.invokeMethod('enableAllDecoders', <String, dynamic> {
      'enable': enable
    });
  }

  static Future<bool> startCameraPreview() async {
    return await _channel.invokeMethod('startCameraPreview');
  }

  static Stream startDecoding() {
    _channel.invokeMethod('startDecoding');
    _decodeCallback = _decodeChannel.receiveBroadcastStream();
    return _decodeCallback;
  }

  static void stopCameraPreview() async {
    await _channel.invokeMethod('stopCameraPreview');
  }

  static void stopDecoding() async {
    await _channel.invokeMethod('stopDecoding');
  }
}
