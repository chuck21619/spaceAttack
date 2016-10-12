//
//  FullScreenAdSingleton.m
//  SpaceAttack
//
//  Created by charles johnston on 2/7/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "FullScreenAdSingleton.h"
#import "Reachability.h"

@implementation FullScreenAdSingleton

static FullScreenAdSingleton * sharedFullScreenAdSingleton = nil;

+ (FullScreenAdSingleton *) sharedInstance
{
    if ( sharedFullScreenAdSingleton == nil )
    {
        sharedFullScreenAdSingleton = [[FullScreenAdSingleton alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:sharedFullScreenAdSingleton selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];

    }
    return sharedFullScreenAdSingleton;
}

- (void)createAndLoadFullScreenAd
{
    self.fullScreenAd = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-6557493854751989/7290189956"];
    GADRequest * request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID, @"07a7fa85e22c195388c46d2c2f90b457", @"19718bc5ab4982560b895c79994e3bd9"];
    [self.fullScreenAd loadRequest:request];
}

- (void) reachabilityChanged:(NSNotification *)notification
{
    if ( ![self.fullScreenAd isReady] )
    {
        Reachability * tmpReachability = notification.object;
        if ( tmpReachability.currentReachabilityStatus != NotReachable )
            [self createAndLoadFullScreenAd];
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
