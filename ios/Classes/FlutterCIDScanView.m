#import "FlutterCIDScanView.h"

@implementation FlutterCIDScanView {
   SimpleScanner* _view;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if (self = [super init]) {
        int width = [[(NSDictionary*)args valueForKey:@"width"] intValue];
        int height = [[(NSDictionary*)args valueForKey:@"height"] intValue];
        CGRect rc = CGRectMake(frame.origin.x, frame.origin.y, width, height);
        _view = [SimpleScanner getSharedObject: rc];
    }
    FlutterMethodChannel *_viewChannel = [FlutterMethodChannel methodChannelWithName:[NSString stringWithFormat:@"fluttercidscanview_%i", viewId] binaryMessenger:messenger];
    [_viewChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if ([@"startScanner"  isEqualToString:call.method]) {
            [self->_view startScanner:self];
        } else if([@"startDecode" isEqualToString:call.method]) {
            [self->_view startDecode];
        }
    }];
    [self->_view startScanner:self];
    return self;
}

- (UIView*)view {
  return _view;
}

- (void)onScannerStarted {
    [_view startDecode];
}

@end
