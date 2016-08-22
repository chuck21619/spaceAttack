//
//  Asteroid.h
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "SASpriteNode.h"

@class Asteroid;
@protocol AsteroidDelegate <SASpriteNodeDelegate>
- (void) asteroidCrumbled:(Asteroid *)asteroid;
@end


@interface Asteroid : SASpriteNode

- (instancetype) initWithAtlas:(NSArray *)textureAtlas;

@property (nonatomic, weak) id <AsteroidDelegate> delegate;
@property (nonatomic) int maxHealth;
@property (nonatomic) int health;
@property (nonatomic) int pointValue;
@property (nonatomic) NSArray * crumbleFrames;
@property (nonatomic) NSPointerArray * photonsTargetingMe;
@property (nonatomic) BOOL isBeingElectrocuted;

- (void) crumble;
- (void) takeDamage:(int)damage;

@end
