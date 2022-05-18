#import "FlutterCidscanPlugin.h"
#import "CIDScanViewFactory.h"
#import "CaptureIDLibrary.h"
//#if __has_include(<flutter_cidscan/flutter_cidscan-Swift.h>)
//#import <flutter_cidscan/flutter_cidscan-Swift.h>
//#else
//// Support project import fallback if the generated compatibility header
///Users/uhoppe/test/flutter/flutter_cidscan// is not copied when this plugin is created as a library.
//// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
//#import "SwiftFlutterCidscanPlugin.h"
//#endif

@interface InitStreamHandler: NSObject<FlutterStreamHandler>
    

@end

@implementation InitStreamHandler
FlutterEventSink _sink;
NSDictionary *_data;

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _sink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _sink = events;
    if(_data != nil) {
        _sink(_data);
    }
    return nil;
}

-(void)send:(NSString*)channel event:(NSString*)event data:(NSDictionary*)data {
    _data = data;
    if(_sink != nil) {
        _sink(_data);
        _data = nil;
    }
}
@end

@interface LicenseStreamHandler: NSObject<FlutterStreamHandler>
@end

@implementation LicenseStreamHandler
FlutterEventSink _sink;
NSDictionary *_data;

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _sink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _sink = events;
    if(_data != nil) {
        _sink(_data);
    }
    return nil;
}

-(void)send:(NSString*)channel event:(NSString*)event data:(NSDictionary*)data {
    _data = data;
    _data[@"body"][@"FunctionName"] = event;
    if(_sink != nil) {
        _sink(_data);
        _data = nil;
    }
}
@end

@interface DecodeStreamHandler: NSObject<FlutterStreamHandler>
@end

@implementation DecodeStreamHandler
FlutterEventSink _sink;
NSDictionary *_data;

- (FlutterError * _Nullable)onCancelWithArguments:(id _Nullable)arguments {
    _sink = nil;
    return nil;
}

- (FlutterError * _Nullable)onListenWithArguments:(id _Nullable)arguments eventSink:(nonnull FlutterEventSink)events {
    _sink = events;
    if(_data != nil) {
        _sink(_data);
    }
    return nil;
}

-(void)send:(NSString*)channel event:(NSString*)event data:(NSDictionary*)data {
    _data = data;
    _data[@"body"][@"FunctionName"] = event;
    if(_sink != nil) {
        _sink(_data);
        _data = nil;
    }
}
@end

@implementation FlutterCidscanPlugin

CaptureIDLibrary * _library;
UIView * _previewView;
FlutterCidscanPlugin *instance;

FlutterEventChannel * _initChannel;
FlutterEventChannel * _licenseChannel;
FlutterEventChannel * _decodeChannel;

FlutterMethodChannel * _channel;

InitStreamHandler * _initHandler;
LicenseStreamHandler * _licenseHandler;
DecodeStreamHandler * _decodeHandler;


//    private let INITHANDLER_ID = "cidscan_init"
//    private let LICENSEHANDLER_ID = "cidscan_license"
//    private let DECODEHANDLER_ID = "cidscan_decode"


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    instance = [[FlutterCidscanPlugin alloc]init];
    [instance initialize: registrar.messenger];
    CIDScanViewFactory * factory = [[CIDScanViewFactory alloc]initWithMessenger:registrar.messenger];
      [registrar registerViewFactory:factory withId:@"fluttercidscanview"];
}

-(void)initialize:(NSObject<FlutterBinaryMessenger>*)messenger {
    _initHandler = [[InitStreamHandler alloc]init];
    _licenseHandler = [[LicenseStreamHandler alloc]init];
    _decodeHandler = [[DecodeStreamHandler alloc]init];

    _initChannel = [FlutterEventChannel eventChannelWithName:@"cidscan_init" binaryMessenger:messenger];
    [_initChannel setStreamHandler:_initHandler];
    _licenseChannel = [FlutterEventChannel eventChannelWithName:@"cidscan_license" binaryMessenger:messenger];
    [_licenseChannel setStreamHandler:_licenseHandler];
    _decodeChannel = [FlutterEventChannel eventChannelWithName:@"cidscan_decode" binaryMessenger:messenger];
    [_decodeChannel setStreamHandler:_decodeHandler];
    _channel = [FlutterMethodChannel methodChannelWithName:@"flutter_cidscan" binaryMessenger:messenger];
    [_channel setMethodCallHandler:^(FlutterMethodCall * call, FlutterResult result) {
        [self handle:call result:result];
    }];
}

-(void) handle:(FlutterMethodCall*) call result:(FlutterResult) result {
    NSDictionary * args = [[call arguments] mutableCopy];
    if([call.method isEqual:@"initCaptureID"]) {
        [self initCaptureID];
    } else if([call.method isEqual:@"activateEDKLicense"]) {
        [self activateEDKLicense:args[@"key"] customerID:args[@"customerID"]];
    } else if([call.method isEqual:@"changeBeepPlayerSound"]) {

    }  else if([call.method isEqual:@"closeCamera"]) {

    }  else if([call.method isEqual:@"closeSharedObject"]) {

    }  else if([call.method isEqual:@"currentSizeOfDecoderVideo"]) {

    }  else if([call.method isEqual:@"decoderTimeLimitInMilliseconds"]) {

    }  else if([call.method isEqual:@"decoderVersion"]) {
        NSString *ver = [self decoderVersion];
        result(ver);
    }  else if([call.method isEqual:@"decoderVersionLevel"]) {

    }  else if([call.method isEqual:@"enableFixedExposureMode"]) {

    }  else if([call.method isEqual:@"enableScannedImageCapture"]) {

    }  else if([call.method isEqual:@"ensureRegionOfInterest"]) {

    }  else if([call.method isEqual:@"enableAllDecoders"]) {
//        let enable = args!["enable"] as! Bool
//        self.enableDecoder(symbology: "SymbologyType_Pharmaode", enable: false)
//        result(self.enableAllDecoders(enable: enable))
    }  else if([call.method isEqual:@"startCameraPreview"]) {
        [self startCameraPreview];
    }  else if([call.method isEqual:@"setTorch"]) {
        if([[args valueForKey:@"enable"] isEqual:[NSNumber numberWithBool:NO]]) {
            [self setTorch:NO];
        } else {
            [self setTorch:YES];
        }
    }  else if([call.method isEqual:@"startDecoding"]) {
        [self startDecoding];
    }  else if([call.method isEqual:@"stopCameraPreview"]) {
        [self stopCameraPreview];
    }  else if([call.method isEqual:@"stopDecoding"]) {
        [self stopDecoding];
    } else {
//        result("iOS " + UIDevice.current.systemVersion)
    }
}

-(void) initCaptureID {
    int width = UIScreen.mainScreen.bounds.size.width;
    int height = UIScreen.mainScreen.bounds.size.height;
    
    UIView *vc = UIApplication.sharedApplication.keyWindow.rootViewController.view;
    _previewView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    [self init:vc];
}

-(void) init:(UIView *) view {
    _library = [[CaptureIDLibrary alloc]initWithUIview:view resultBlock:^(BOOL res) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"initCaptureID" forKey:@"FunctionName"];
        [dict setValue:@0 forKey:@"error"];
        [dict setObject:@YES forKey:@"boolValue"];
        [dict setValue:@0L forKey:@"longValue"];
        [dict setValue:@0 forKey:@"floatValue"];
        [dict setValue:@"" forKey:@"stringValue"];
        [dict setValue:@"" forKey:@"objValue"];
        NSMutableDictionary * data = [[NSMutableDictionary alloc]init];
        [data setValue:@"cidscan_init" forKey:@"channel"];
        [data setValue:@"initCaptureID" forKey:@"event"];
        [data setObject:dict forKey:@"body"];
        [_initHandler send:@"cidscan_init" event:@"initCaptureID" data:data];
    }];
}

-(void)activateEDKLicense:(NSString*)filename customerID:(NSString*)customerID {
    [_library activateEDKLicenseWithKey:filename customerID:customerID resultHandler:^(NSArray* res) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"onActivationResult" forKey:@"FunctionName"];
        [dict setValue:@0 forKey:@"error"];
        [dict setObject:@YES forKey:@"boolValue"];
        [dict setValue:@0L forKey:@"longValue"];
        [dict setValue:@0 forKey:@"floatValue"];
        [dict setValue:res[0][@"message"] forKey:@"stringValue"];
        [dict setValue:@"" forKey:@"objValue"];
        NSMutableDictionary * data = [[NSMutableDictionary alloc]init];
        [data setValue:@"cidscan_license" forKey:@"channel"];
        [data setValue:@"onActivationResult" forKey:@"event"];
        [data setObject:dict forKey:@"body"];
        [_licenseHandler send:@"cidscan_license" event:@"onActivationResult" data:dict];
    }];
}

-(void)changeBeepPlayerSound:(NSString*)name {
    [_library changeSound:name];
}

-(void)closeCamer {
    [_library closeCamera];
}

-(void)closeSharedObject {
    [_library closeSharedObject];
}

-(CGSize*)currentSizeOfDecoderVideo {
    return (__bridge CGSize *)([_library currentSizeOfDecoderVideo]);
}

-(void)decoderTimeLimitInMilliseconds:(int)milliseconds {
    [_library decoderTimeLimitInMilliseconds:milliseconds];
}

-(NSString*)decoderVersion {
    return [_library decoderVersion][0][@"stringValue"];
}

-(NSString*)decoderVersionLevel {
    return [_library decoderVersionLevel][0][@"stringValue"];
}

-(void)enableFixedExposureMode:(BOOL)enabled exposureValue:(long)exposureValue {
    [_library enableFixedExposureMode:enabled];
}

-(void)enableScannedImageCapture:(BOOL)enable {
    [_library enableScannedImageCapture:enable];
}

-(void)ensureRegionOfInterest:(BOOL)enable {
    [_library ensureRegionOfInterest:enable];
}

-(UIView*)getCameraPreview {
    return [_library getCameraPreview];
}

-(UInt32)getFocusDistance {
    return [_library getFocusDistance];
}

-(CGFloat)getMaxZoom {
    NSArray* arr = [_library getMaxZoom];
    return 0;
}

-(NSString*)getSdkVersion {
    return [_library getSdkVersion][0][@"string Value"];
}

-(BOOL)enableAllDecoders:(BOOL)enable {
    [_library enableAllDecoders:enable];
    return YES;
}

-(BOOL)enableDecoder:(NSString*)symbology enable:(BOOL)enable {
    [_library enableDecoder:symbology enable:enable];
    return YES;
}

-(BOOL)startCameraPreview {
    return [_library startCameraPreview:^(NSArray* res) {
        
    }];
}

-(void)startDecoding {
    [_library startDecoder:^(NSArray* res) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
        [dict setValue:@"receivedDecodedData" forKey:@"FunctionName"];
        [dict setValue:@0 forKey:@"error"];
        [dict setObject:@YES forKey:@"boolValue"];
        [dict setValue:@0L forKey:@"longValue"];
        [dict setValue:@0 forKey:@"floatValue"];
        [dict setValue:res[0][@"stringValue"] forKey:@"stringValue"];
        [dict setValue:res[0][@"decodes"] forKey:@"objValue"];
        NSMutableDictionary * data = [[NSMutableDictionary alloc]init];
        [data setValue:@"cidscan_decode" forKey:@"channel"];
        [data setValue:@"receivedDecodedData" forKey:@"event"];
        [data setObject:dict forKey:@"body"];
        [_decodeHandler send:@"cidscan_decode" event:@"receivedDecodedData" data:dict];
    }];
}

-(void)setTorch:(BOOL)enable {
    [_library setTorch:enable];
}

-(void)stopCameraPreview {
    [_library stopCameraPreview];
}

-(void)stopDecoding {
    [_library stopDecoding];
}










//    let args = call.arguments as? NSDictionary
//    if(call.method.elementsEqual("initCaptureID")) {
//        initCaptureID()
//    } else if(call.method.elementsEqual("activateEDKLicense")) {
//        let customer = args!["customerID"]
//        let key = args!["key"]
//        activateEDKLicense(filename: key as! String, customerID: customer as! String)
//    } else if(call.method.elementsEqual("changeBeepPlayerSound")) {
//    } else if(call.method.elementsEqual("closeCamera")) {
//    } else if(call.method.elementsEqual("closeSharedObject")) {
//    } else if(call.method.elementsEqual("currentSizeOfDecoderVideo")) {
//    } else if(call.method.elementsEqual("decoderTimeLimitInMilliseconds")) {
//    } else if(call.method.elementsEqual("decoderVersion")) {
//        result(self.decoderVersion())
//    } else if(call.method.elementsEqual("decoderVersionLevel")) {
//        result(self.decoderVersionLevel())
//    } else if(call.method.elementsEqual("enableFixedExposureMode")) {
//    } else if(call.method.elementsEqual("enableScannedImageCapture")) {
//    } else if(call.method.elementsEqual("ensureRegionOfInterest")) {
//    } else if(call.method.elementsEqual("enableAllDecoders")) {
//        let enable = args!["enable"] as! Bool
//        self.enableDecoder(symbology: "SymbologyType_Pharmaode", enable: false)
//        result(self.enableAllDecoders(enable: enable))
//    } else if(call.method.elementsEqual("startCameraPreview")) {
//        self.startCameraPreview()
//    } else if(call.method.elementsEqual("setTorch")) {
//        self.setTorch(enable: args!["enable"] as! Bool);
//    } else if(call.method.elementsEqual("startDecoding")) {
//        self.startDecoding()
//    } else if(call.method.elementsEqual("stopCameraPreview")) {
//        self.stopCameraPreview()
//    } else if(call.method.elementsEqual("stopDecoding")) {
//        self.stopDecoding()
//    } else {
//        result("iOS " + UIDevice.current.systemVersion)
//    }
// }



//    public static func register(with registrar: FlutterPluginRegistrar) {
//        let instance = SwiftFlutterCidscanPlugin()
//        instance.initialize(messenger: registrar.messenger())
////        registrar.addMethodCallDelegate(instance, channel: _channel)
//    }

//    private func initialize(messenger: FlutterBinaryMessenger) {
//        self._initChannel = FlutterEventChannel(name: self.INITHANDLER_ID, binaryMessenger: messenger);
//        self._initChannel?.setStreamHandler(self._inithandler)
//        self._licenseChannel = FlutterEventChannel(name: self.LICENSEHANDLER_ID, binaryMessenger: messenger)
//        self._licenseChannel?.setStreamHandler(self._licensehandler)
//        self._decodeChannel = FlutterEventChannel(name: self.DECODEHANDLER_ID, binaryMessenger: messenger)
//        self._decodeChannel?.setStreamHandler(self._decodehandler)
//        let _channel = FlutterMethodChannel(name: "flutter_cidscan", binaryMessenger: messenger)
//        _channel.setMethodCallHandler(handle)
//    }






@end
