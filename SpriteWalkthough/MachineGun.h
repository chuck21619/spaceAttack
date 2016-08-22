//
//  MachineGun.h
//  SpriteWalkthough
//
//  Created by chuck on 4/28/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerWeapon.h"
#import "Bullet.h"

@interface MachineGun : PlayerWeapon

@property (nonatomic) SKTexture * projectileTexture;
@property (nonatomic) BOOL fireRateUpgraded;

@end
