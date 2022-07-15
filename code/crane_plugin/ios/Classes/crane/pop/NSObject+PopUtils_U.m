//
//  NSObject+PopUtils_U.m
//  crane_plugin
//
//  Created by ruifeng yu on 2022/7/15.
//

#import "NSObject+PopUtils_U.h"

@implementation NSObject (PopUtils_U)



@end


- show(){
    [UMSUnityMediation initializeWithGameId:@"YOUR GAME ID HERE" delegate:nil];
       self.interstitialAd = [[UMSInterstitialAd alloc] initWithAdUnitId:@"YOUR ADUNIT ID HERE"];
       [self.interstitialAd loadWithDelegate:self];
}
