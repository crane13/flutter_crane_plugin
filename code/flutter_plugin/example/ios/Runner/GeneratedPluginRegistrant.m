//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<craneplugin/CranepluginPlugin.h>)
#import <craneplugin/CranepluginPlugin.h>
#else
@import craneplugin;
#endif

#if __has_include(<path_provider_foundation/PathProviderPlugin.h>)
#import <path_provider_foundation/PathProviderPlugin.h>
#else
@import path_provider_foundation;
#endif

#if __has_include(<share/FLTSharePlugin.h>)
#import <share/FLTSharePlugin.h>
#else
@import share;
#endif

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

#if __has_include(<umeng_common_sdk/UmengCommonSdkPlugin.h>)
#import <umeng_common_sdk/UmengCommonSdkPlugin.h>
#else
@import umeng_common_sdk;
#endif

#if __has_include(<url_launcher_ios/FLTURLLauncherPlugin.h>)
#import <url_launcher_ios/FLTURLLauncherPlugin.h>
#else
@import url_launcher_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CranepluginPlugin registerWithRegistrar:[registry registrarForPlugin:@"CranepluginPlugin"]];
  [PathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"PathProviderPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
  [UmengCommonSdkPlugin registerWithRegistrar:[registry registrarForPlugin:@"UmengCommonSdkPlugin"]];
  [FLTURLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTURLLauncherPlugin"]];
}

@end
