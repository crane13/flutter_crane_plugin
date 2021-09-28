#import "FlutterPluginIapPlugin.h"
#if __has_include(<flutter_plugin_iap/flutter_plugin_iap-Swift.h>)
#import <flutter_plugin_iap/flutter_plugin_iap-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_plugin_iap-Swift.h"
#endif

@implementation FlutterPluginIapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPluginIapPlugin registerWithRegistrar:registrar];
}
@end
