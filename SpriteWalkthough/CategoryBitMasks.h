//
//  CategoryBitMasks.h
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryBitMasks : NSObject

+ (const uint32_t) shipCategory;
+ (const uint32_t) asteroidCategory;
+ (const uint32_t) enemyCategory;
+ (const uint32_t) missileCategory;
+ (const uint32_t) photonCategory;
+ (const uint32_t) bulletCategory;
+ (const uint32_t) laserCategory;
+ (const uint32_t) electricityCategory;
+ (const uint32_t) pelletCategory;
+ (const uint32_t) powerUpCategory;
+ (const uint32_t) shieldCategory;

@end
