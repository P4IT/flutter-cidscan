#import <Flutter/Flutter.h>
#import "CIDScanView.h"

@interface FlutterCIDScanView : NSObject <FlutterPlatformView>

- (instancetype _Nullable )initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>* _Nonnull)messenger;
- (CIDScanView * _Nonnull) view;
@end
