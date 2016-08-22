//
//  Enemy.h
//  SpriteWalkthough
//
//  Created by chuck on 6/12/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "SASpriteNode.h"

@class Enemy;
@protocol EnemyDelegate <SASpriteNodeDelegate>
- (void) enemyExploded:(Enemy *)enemy;
@end


@interface Enemy : SASpriteNode

@property (nonatomic, weak) id <EnemyDelegate> delegate;
@property (nonatomic) int pointValue;
@property (nonatomic) int armor;
@property (nonatomic) NSPointerArray * photonsTargetingMe;
@property (nonatomic) BOOL isBeingElectrocuted;
@property (nonatomic) SKAction * pulseRed;
- (void) takeDamage:(int)damage;
- (void) explode;

@end
