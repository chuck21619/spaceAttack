//
//  CategoryBitMasks.m
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "CategoryBitMasks.h"

@implementation CategoryBitMasks

static const uint32_t missileCategory     =  0x1 << 0;
static const uint32_t shipCategory        =  0x1 << 1;
static const uint32_t asteroidCategory    =  0x1 << 2;
static const uint32_t photonCategory      =  0x1 << 3;
static const uint32_t bulletCategory      =  0x1 << 4;
static const uint32_t laserCategory       =  0x1 << 5;
static const uint32_t electricityCategory =  0x1 << 6;
static const uint32_t enemyCategory       =  0x1 << 7;
static const uint32_t pelletCategory      =  0x1 << 8;
static const uint32_t powerUpCategory     =  0x1 << 9;
static const uint32_t shieldCategory      =  0x1 << 10;


+ (const uint32_t) shipCategory { return shipCategory; }
+ (const uint32_t) asteroidCategory { return asteroidCategory; }
+ (const uint32_t) enemyCategory { return enemyCategory; }
+ (const uint32_t) missileCategory { return missileCategory; }
+ (const uint32_t) photonCategory { return photonCategory; }
+ (const uint32_t) bulletCategory { return bulletCategory; }
+ (const uint32_t) laserCategory { return laserCategory; }
+ (const uint32_t) electricityCategory { return electricityCategory; }
+ (const uint32_t) pelletCategory { return pelletCategory; }
+ (const uint32_t) powerUpCategory { return powerUpCategory; }
+ (const uint32_t) shieldCategory { return shieldCategory; }

@end
