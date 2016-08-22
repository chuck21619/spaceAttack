//
//  UpgradeScene.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "EnumTypes.h"
#import "EnemyKit.h"
#import "SpaceshipKit.h"

@interface UpgradeScene : SKScene <SKPhysicsContactDelegate, PlayerWeaponDelegate, SASpriteNodeDelegate>

- (instancetype) initWithUpgradeType:(UpgradeType)upgradeType;
@property (nonatomic) UpgradeType upgradeType;
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) Spaceship * mySpaceship;
@property (nonatomic) EnemyKit * enemyKit;
@property (nonatomic) NSTimer * moveShipTimer;
- (SKNode *) nextPriorityTargetForPhoton:(Photon *)photon;

@end
