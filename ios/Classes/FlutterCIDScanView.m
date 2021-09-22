#import "FlutterCIDScanView.h"

@implementation FlutterCIDScanView {
   CIDScanView *_view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
      _view = [CIDScanView getSharedObject: frame];
    }
    FlutterMethodChannel *_viewChannel = [FlutterMethodChannel
                                          methodChannelWithName: [NSString stringWithFormat:@"app.captureid.captureidlibrary/cidscanview_%i", viewId]
                                          binaryMessenger: messenger];
    [_viewChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"startScanner"  isEqualToString:call.method]) {
            [self->_view startScanner];
        }
    }];

  return self;
}

- (UIView*)view {
  return _view;
}

@end
