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
        'BNX9965QNM3ahzCaE514DD2zcGruYvEAJw2Aet6zYmxSW20x97BcZyWuzY/m+kckR3zIQB3DucWcvsHLuJK4/+z+lA/0YYf7x9zcwvxxkxr5NYMKl+MtPzoGeOtq+cTv0ThTapUOCsd2tLKzivOd52Y+gVStOJuD1mJchvjMX16Jzk8U/BFvRbuZBLEd6u7FvVzWNAS4tUNXPGvpU8zQNJDlvicgmELUu6dK4wr1VcbxepSpaAC6OW2g9L3Efq8ZTX9PtdAS3SRw4seuwpk5CDo5cS9dQ3vriY+AZVbIaqfkIN0OkbXgJIIAmYIBTgTDP9B2AqXSwYYNgbguOLCGGjrer9oZgpN+SgkhParPOX9ihr81jDMtNKvvDRYYDk5JjZj5e6cerRO1/sPtZ8dofg==',
        'P4I082220190001')!.listen((event) => { handleLicenseEvent(event) });
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
    FlutterCidscan.startDecoding()!.listen((event) => { handleDecode(event) });
  }

  void restartScanner() {
    FlutterCidscan.startCameraPreview();
    FlutterCidscan.startDecoding()!.listen((event) => { handleDecode(event) });
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
    FlutterCidscan.startDecoding()!.listen((event) => {handleDecode(event)});
  }

  Future<void> init() async {
    FlutterCidscan.initCaptureID('Wir benötigen die Kamera Berechtigung zum Scannen der Barcodes', false, true)!.listen((event) => { handleInit(event) });
  }

  void onCreated(CIDScanViewController ctrl) {

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
                onCIDScanViewCreated: onCreated,
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
