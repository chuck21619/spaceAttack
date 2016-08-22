//
//  FullScreenAdSingleton.h
//  SpaceAttack
//
//  Created by charles johnston on 2/7/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMobileAds;


@interface FullScreenAdSingleton : NSObject

+ (FullScreenAdSingleton *) sharedInstance;

@property (nonatomic) GADInterstitial * fullScreenAd;
- (void) createAndLoadFullScreenAd;

@end
