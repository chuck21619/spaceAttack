//
//  PlayerWeapon.h
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EnumTypes.h"

@class PlayerWeapon;
@protocol PlayerWeaponDelegate <NSObject>
@optional
- (void) didAddProjectile:(SKSpriteNode *)projectile forWeapon:(PlayerWeapon *)weapon;
@end

@interface PlayerWeapon : SKSpriteNode

@property (nonatomic, weak) id <PlayerWeaponDelegate> delegate;
@property (nonatomic) PowerUpType weaponType;
@property (nonatomic) int level;
- (void) upgrade;
- (void) startFiring;
- (void) stopFiring;

@end
