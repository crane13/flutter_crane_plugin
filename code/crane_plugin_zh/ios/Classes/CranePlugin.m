#import "CranePlugin.h"
#if __has_include(<crane_plugin/crane_plugin-Swift.h>)
#import <crane_plugin/crane_plugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "crane_plugin-Swift.h"
#endif

@implementation CranePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCranePlugin registerWithRegistrar:registrar];
}
@end
