//
//  BlastGun.h
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "EnemyWeapon.h"
#import "Pellet.h"

@interface BlastGun : EnemyWeapon <enemyWeaponProtocol>

@property (nonatomic) SKTexture * projectileTexture;

@end