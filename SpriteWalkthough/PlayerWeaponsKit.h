//
//  PlayerWeaponsKit.h
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotonCannon.h"
#import "MachineGun.h"
#import "LaserCannon.h"
#import "ElectricalGenerator.h"
#import "Missile.h"

@interface PlayerWeaponsKit : NSObject

+ (PlayerWeaponsKit *)sharedInstance;

@property (nonatomic) NSDictionary * weaponTextures;
@property (nonatomic) SKTexture * bulletTexture;
@property (nonatomic) SKTexture * photonTexture;
@property (nonatomic) NSArray * laserFrames;
@property (nonatomic) NSMutableArray * electricityFrames;

- (NSArray *) texturesForPreloading;

- (BOOL) beingUsedForDemoScene;

@end
