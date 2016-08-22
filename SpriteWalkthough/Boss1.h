//
//  Boss1.h
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Boss.h"
#import "EnemyWeaponsKit.h"

@interface Boss1 : Boss <bossProtocol>

- (void) startFighting;
- (void) takeDamage:(int)damage;

@end
