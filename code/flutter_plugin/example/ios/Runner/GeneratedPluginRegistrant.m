//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"

#if __has_include(<craneplugin/CranepluginPlugin.h>)
#import <craneplugin/CranepluginPlugin.h>
#else
@import craneplugin;
#endif

#if __has_include(<flutter_umeng_analytics_fork/FlutterUmengAnalyticsPlugin.h>)
#import <flutter_umeng_analytics_fork/FlutterUmengAnalyticsPlugin.h>
#else
@import flutter_umeng_analytics_fork;
#endif

#if __has_include(<path_provider/FLTPathProviderPlugin.h>)
#import <path_provider/FLTPathProviderPlugin.h>
#else
@import path_provider;
#endif

#if __has_include(<share/SharePlugin.h>)
#import <share/SharePlugin.h>
#else
@import share;
#endif

#if __has_include(<shared_preferences/FLTSharedPreferencesPlugin.h>)
#import <shared_preferences/FLTSharedPreferencesPlugin.h>
#else
@import shared_preferences;
#endif

#if __has_include(<url_launcher/FLTURLLauncherPlugin.h>)
#import <url_launcher/FLTURLLauncherPlugin.h>
#else
@import url_launcher;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [CranepluginPlugin registerWithRegistrar:[registry registrarForPlugin:@"CranepluginPlugin"]];
  [FlutterUmengAnalyticsPlugin registerWithRegistrar:[registry registrarForPlugin:@"FlutterUmengAnalyticsPlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
  [FLTSharePlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharePlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [FLTURLLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTURLLauncherPlugin"]];
}

@end
