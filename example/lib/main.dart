import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_cidscan/cidscanview.dart';
import 'package:flutter_cidscan/flutter_cidscan.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var activeTL = false;
  var _visible = false;

  @override
  void initState() {
    super.initState();
  }

  void handleLicenseEvent(Map event) async {
    if(event["body"]["FunctionName"].compareTo('onActivationResult') == 0) {
      String value = await FlutterCidscan.decoderVersion();
      print(value);
//      startScanner();
    }
  }

  void handleInit(Map event) async {
    if(event["body"]["FunctionName"].compareTo('initCaptureID') == 0) {
      FlutterCidscan.activateEDKLicense(
        'xrUJifzGeEwsQj/v6tb4CQ1GDC6/Hc7j4Qp25+nfNCpg85oCBkh7cGqyAJ5TO3HUJA/S58tSx0jZmSV1h9twrBqDfRj10hb6fxHoJiw30Zt2qEM0px+S9rZw0W45C0RtR0yBRDfaR4br4N0L6/P0CV7u9zqm8KJxrAthm9uS7Q0gQlsgnz3C84speRj8pEDUoaq7SAb2W/0KmBSOMGffxkNlrcZU4RoR4XtGmKu+bDGQaN/m1rGran1SrO0l0pZS7BXa7QewHk8K42RAWT3hLrQhwvXc7smiLGnwtFmhHoxNAj7fPrH3DxbPGnJNV3ijdpTyb8FUzL7sxbjp6nXJF/GkSgfrVfEtnOPoSu1W5OmoqP7TZvIxGRJDieTayvGncBBiC0nNj6BzOxGd4uFsAA==',
        'P4I082220190001').listen((event) => { handleLicenseEvent(event) });
    }
  }

  void torchlight() {
    if (!activeTL) {
      activeTL = true;
      FlutterCidscan.setTorch(true);
    } else {
      activeTL = false;
      FlutterCidscan.setTorch(false);
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
    if(event["body"]["FunctionName"].compareTo('receivedDecodedData') == 0) {
      FlutterCidscan.stopDecoding();
      FlutterCidscan.stopCameraPreview();
    }
  }

  void _toggle() {
    if (_visible) {
      FlutterCidscan.stopDecoding();
    } else {
      startDecode();
    }
    setState(() {
      _visible = !_visible;
    });
  }

  void startDecode() {
    FlutterCidscan.startDecoding().listen((event) => {handleDecode(event)});
  }

  Future<void> init() async {
    FlutterCidscan.initCaptureID('Wir benötigen die Kamera Berechtigung zum Scannen der Barcodes', false, true).listen((event) => { handleInit(event) });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Container(
          color: Color(0xff619ff9),
        ),
        Visibility(
          visible: _visible,
          child: Container(
            height: 200.0,
            child: new Directionality(
              textDirection: TextDirection.ltr,
              child: CIDScanView(
                height: 200,
                width: 400,
                onCIDScanViewCreated: null,
              ),
            ),
          ),
        ),
        Positioned(
          top: 70,
          left: 30,
          child: Container(
            alignment: Alignment.topCenter,
            height: 50,
            width: 50,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: TextButton(
                    onPressed: _toggle,
                    child: Image(
                      alignment: Alignment.center,
                      matchTextDirection: true,
                      image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    ),
                  )),
            ),
          ),
        ),
        Positioned(
          top: 70,
          right: 30,
          child: Container(
            alignment: Alignment.topCenter,
            height: 50,
            width: 50,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: TextButton(
                    onPressed: torchlight,
                    child: Image(
                      alignment: Alignment.center,
                      matchTextDirection: true,
                      image: NetworkImage(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    ),
                  )),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 50,
            width: 150,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: TextButton(
                  onPressed: init,
                  child: Text(
                    'Init',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 50,
            width: 150,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: ConstrainedBox(
                constraints: BoxConstraints.expand(),
                child: TextButton(
                  onPressed: _toggle,
                  child: Text(
                    'Starten',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }




// Widget build(BuildContext context) {
  //   return MaterialApp(
  //     home: Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Plugin example app'),
  //       ),
  //       body: Center(
  //         child: Stack(
  //           children: <Widget>[
  //             Column(
  //           children: <Widget>[
  //             Row(
  //               children: <Widget> [FlatButton(
  //                 color: Colors.blue,
  //                 textColor: Colors.white,
  //                 padding: EdgeInsets.all(8.0),
  //                 splashColor: Colors.blueAccent,
  //                 onPressed: () {init();},
  //                 child: Text(
  //                   "Start Scan",
  //                   style: TextStyle(fontSize: 20.0),
  //                 ),
  //               )],
  //             ),
  //             Row(
  //               children: <Widget> [FlatButton(
  //                 color: Colors.blue,
  //                 textColor: Colors.white,
  //                 padding: EdgeInsets.all(8.0),
  //                 splashColor: Colors.blueAccent,
  //                 onPressed: () {restartScanner();},
  //                 child: Text(
  //                   "Scan again",
  //                   style: TextStyle(fontSize: 20.0),
  //                 ),
  //               )]
  //             )
  //           ]
  //             )
  //           ]
  //         )
  //       ),
  //     ),
  //   );
  // }
}
