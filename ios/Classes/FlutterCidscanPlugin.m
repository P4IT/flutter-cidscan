#import "FlutterCidscanPlugin.h"
#if __has_include(<flutter_cidscan/flutter_cidscan-Swift.h>)
#import <flutter_cidscan/flutter_cidscan-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_cidscan-Swift.h"
#endif

@implementation FlutterCidscanPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterCidscanPlugin registerWithRegistrar:registrar];
}
@end
