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
        'avQGpsFFs5pKam7OyN8VjIdqeCv/lyU1lqQQ73lOdnfv/4VQHAotVJlBLcmAu180U7ix7n6XYZBdXEea2TnCsZOYuP8kiHcC/E9DLt1DJEh/65gr75Onj8CZ1HP0X2nRipGMgyEyqYfy9VA03USSYC3k51KXzYQosF19j4HKXyf32Jl47Aaw5FRPxZIbK3QLKDtqCtEq1PmRxY42ceLoEncQsHBRQa2niIcRQ+asvOb//4+hSCpJidqTwHhaLZs4SdjuzJIJRIDKB45mFVOnO/2S3kobKvTR48+h3ZQOS+eyVOFicwCByZ2D9Oqg/pTQQtZkLNwX31wdwE0QzoaJ8JX/N2jtM0vthbyIYizCj/XQb53d+t2spu0PTpt4gLWl2pJokOmK1OteQDtTzK4SzA==',
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
      setState(() {
        _visible = !_visible;
      });
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
