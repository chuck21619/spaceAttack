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
}

- (void) reachabilityChanged:(NSNotification *)notification
{
    if ( false )
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
