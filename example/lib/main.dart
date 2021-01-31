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

  void handleInit(Map event) async {
    if(event.values.elementAt(1).compareTo('initCaptureID') == 0) {
      FlutterCidscan.activateEDKLicense(
        'xbZBZfevKobN30GQ83U/G/Ou51FDAE4bpPLmh2wWllAhbiAPYyGN1IQ5CQ5LyinVkPM9iaZVRVPzjxoNGTNByOzIcbayZH+aBBSsbZI3xHw2Juq1ulrg8JzbP2eKvfKkNILx7l/RttX7Bjv+b9qRk8jfWz8IU0c4/sJMDewjOGyOZdhHv960oYzJ/DFkpC3Aebm5LsRkXsAU99GZC8fxp0xGP7bsLjn9AvBWMOEOmDjaD4pPrYub1HtLwtjsk5hTa60ofIaipaYqXY0/JgcQ01n9NxjoXJ0+91ekfSDNWSGI1WR6NToH9UvOUxmDa0XJrVhW6z68QV/4OyN4csiSWOwBykCGrhDodtJ3b6galvMzhR+UhIbhqSVHJ8eNXUQMYqEmST7iIICQw9aabVYiRA==',
        'P4I082220190001').listen((event) { });
    } else if(event.values.elementAt(1).compareTo('onActivationResult') == 0) {
      String value = await FlutterCidscan.decoderVersion();
      print(value);
      startScanner();
    }
    print(event);
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
