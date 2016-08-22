//
//  Electricity.h
//  SpriteWalkthough
//
//  Created by chuck on 6/7/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerProjectile.h"

@interface Electricity : PlayerProjectile

- (id) initWithDamageFrequency:(float)damageFrequency;

- (void) update :(NSTimeInterval)currentTime;
@property (nonatomic, weak) SKNode * target;
@property (nonatomic, weak) SKCropNode * myCropNode;
@property (nonatomic) float timeSinceLastDamageDealt;
@property (nonatomic) float damageFrequency;
+ (int) baseDamage;

@end
