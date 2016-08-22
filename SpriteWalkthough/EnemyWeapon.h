//
//  EnemyWeapon.h
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol enemyWeaponProtocol
- (void) startFiring;
@end


@interface EnemyWeapon : SKSpriteNode

@property (nonatomic) int level;

@end
