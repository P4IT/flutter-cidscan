import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_cidscan/flutter_cidscan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  void handleLicenseEvent(Map event) async {
    if(event["FunctionName"].compareTo('onActivationResult') == 0) {
      String value = await FlutterCidscan.decoderVersion();
      print((value);
      startScanner();
    }
  }

  void handleInit(Map event) async {
    if(event["body"]["FunctionName"].compareTo('initCaptureID') == 0) {
      FlutterCidscan.activateEDKLicense(
        'ZzpC8qfZpYu3Z1hP0mAcb/ux1aCN71JxhT4VaDCNwC88IQ8kyFemwLsZbHDj5XWcKOcAPBb4KTfqUyILjaiMAP8xAANifrfIzFnC9q7pQR+W7llyV7OYN7eCgtVOs7zaHAaQtrHJ16zaALBnVHA2CnyRQwI0Ogc8qBvXSijGRMC9BtKBSCWFsxN4JWtbCBhUxQb8Qrp66DumE6BEukGu5iseafgbTHSm9qQpGURzX2K1xjL0MubHtyomYSdG98G4qzaQ2ZAHq7Z8H1WLRoBOhBJM9si+KqN3lr7ALNRCddlNwxvQE/4Y0R5HX7OhGKEF0jSjI84UjHtPe5+mACDxlsRuooCRC/Y3EYyFgilIxZyReWW2fmsyMYIOgA5VPSFGgtiKsekMwQavFvjzNYj/RQ==',
        'P4I082220190001').listen((event) => { handleLicenseEvent(event) });
    }
  }

  void startScanner() {
    FlutterCidscan.enableAllDecoders(true);
    FlutterCidscan.startCameraPreview();
    FlutterCidscan.startDecoding().listen((event) => { handleDecode(event) });
  }

  void restartScanner() {
    FlutterCidscan.startCameraPreview();
    FlutterCidscan.startDecoding().listen((event) => { handleDecode(event) });
  }

  void handleDecode(Map event) {
    print(event);
    if(event.values.elementAt(1).compareTo('receivedDecodedData') == 0) {
      FlutterCidscan.stopDecoding();
      FlutterCidscan.stopCameraPreview();
    }
  }

  Future<void> init() async {
    FlutterCidscan.initCaptureID('Wir benötigen die Kamera Berechtigung zum Scannen der Barcodes', false, true).listen((event) => { handleInit(event) });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Stack(
            children: <Widget>[
              Column(
            children: <Widget>[
              Row(
                children: <Widget> [FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {init();},
                  child: Text(
                    "Start Scan",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )],
              ),
              Row(
                children: <Widget> [FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(8.0),
                  splashColor: Colors.blueAccent,
                  onPressed: () {restartScanner();},
                  child: Text(
                    "Scan again",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )]
              )
            ]
              )
            ]
          )
        ),
      ),
    );
  }
}
