//
//  Photon.h
//  SpriteWalkthough
//
//  Created by chuck on 4/25/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerProjectile.h"

@interface Photon : PlayerProjectile

@property (nonatomic) BOOL hasTargeted;
@property (nonatomic) BOOL isSmart;
@property (nonatomic) int maxVelocity;
@property (nonatomic) int acceleration;
@property (nonatomic) float targetingFrequency;
@property (nonatomic) float timeSinceLastAttemptedTargeting;
@property (nonatomic, weak) SKNode * target;

- (void) update :(NSTimeInterval)currentTime;
- (void) explode;
+ (int) baseDamage;

@end
