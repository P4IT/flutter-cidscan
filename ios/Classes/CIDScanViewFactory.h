#import <Flutter/Flutter.h>

@interface CIDScanViewFactory: NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
