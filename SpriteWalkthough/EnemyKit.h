//
//  EnemyKit.h
//  SpriteWalkthough
//
//  Created by chuck on 6/16/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnemyBasic.h"
#import "EnemyFast.h"
#import "EnemyBig.h"
#import "Boss1.h"
#import "EnemyExplosion.h"
@class SpaceshipScene;

@interface EnemyKit : NSObject

+ (EnemyKit *)sharedInstanceWithScene:(SKScene *)scene;
@property (nonatomic, weak) SKScene * scene;
@property (nonatomic) SKTexture * enemyTextureBasic;
@property (nonatomic) SKTexture * enemyTextureFast;
@property (nonatomic) SKTexture * enemyTextureBig;
@property (nonatomic) NSArray * explosionFrames;
- (NSArray *) texturesForPreloading;

- (NSArray *) addEnemiesBasic:(int)count toScene:(SKScene *)scene withSpeed:(float)enemySpeedCoefficient;
- (NSArray *) addEnemiesFast:(int)count toScene:(SKScene *)scene withSpeed:(float)enemySpeedCoefficient;
- (NSArray *) addEnemiesBig:(int)count toScene:(SKScene *)scene withSpeed:(float)enemySpeedCoefficient;
//- (void) addBossToScene:(SKScene *)scene;

@end
