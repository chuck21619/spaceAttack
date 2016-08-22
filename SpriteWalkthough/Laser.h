//
//  Laser.h
//  SpriteWalkthough
//
//  Created by chuck on 4/29/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerProjectile.h"

@interface Laser : PlayerProjectile

- (id) initWithAtlas:(NSArray *)atlas;
+ (int) baseDamage;

@end
