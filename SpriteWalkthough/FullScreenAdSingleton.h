//
//  FullScreenAdSingleton.h
//  SpaceAttack
//
//  Created by charles johnston on 2/7/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FullScreenAdSingleton : NSObject

+ (FullScreenAdSingleton *) sharedInstance;

- (void) createAndLoadFullScreenAd;

@end
