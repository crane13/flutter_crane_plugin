#import "CranepluginPlugin.h"
#if __has_include(<craneplugin/craneplugin-Swift.h>)
#import <craneplugin/craneplugin-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "craneplugin-Swift.h"
#endif

@implementation CranepluginPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCranepluginPlugin registerWithRegistrar:registrar];
}
@end
