#import <Flutter/Flutter.h>
#import "SimpleScanner.h"

@interface FlutterCIDScanView : NSObject <FlutterPlatformView, SimpleScannerEventListener>

- (instancetype _Nullable )initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>* _Nonnull)messenger;
- (SimpleScanner* _Nonnull) view;
@end
