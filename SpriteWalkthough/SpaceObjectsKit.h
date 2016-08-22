//
//  SpaceObjectsKit.h
//  SpriteWalkthough
//
//  Created by chuck on 7/17/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "Asteroid.h"
#import "SpaceBackground.h"
@class SpaceshipScene;


@interface SpaceObjectsKit : NSObject

+ (SpaceObjectsKit *) sharedInstanceWithScene:(SpaceshipScene *)scene;
- (Asteroid *) addAsteroidWithSpeed:(float)speed angle:(float)angle;
- (void) addPlanetToBackgroundWithAlpha:(float)alpha;
//- (void) addStartingBackground;
- (void) addSpaceBackground;

@property (nonatomic) SpaceshipScene * scene;

@property (nonatomic) NSArray * shield1Frames;
@property (nonatomic) NSArray * shield2Frames;
@property (nonatomic) NSArray * shield3Frames;
@property (nonatomic) SKTexture * firstSpaceBackgroundTexture;
@property (nonatomic) NSArray * spaceBackgroundTextures;
@property (nonatomic) NSArray * asteroidTextureAtlas;
@property (nonatomic) NSArray * backgroundPlanetTextures;
@property (nonatomic) NSDictionary * powerUpTextures;
- (NSArray *) texturesForPreloading;

@end
