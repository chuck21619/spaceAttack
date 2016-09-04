//
//  SpaceshipScene.h
//  SpriteWalkthough
//
//  Created by chuck on 3/25/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SpaceshipKit.h"
#import "Enemy.h"
#import "Asteroid.h"
#import "GameplayControls.h"
#import "SpaceObjectsKit.h"
#import "EnemyKit.h"
#import "SASpriteNode.h"

@protocol SpaceshipSceneDelegate <NSObject>
- (void) gameOver:(int)pointsScored;
@end

@interface SpaceshipScene : SKScene <SKPhysicsContactDelegate, EnemyDelegate, AsteroidDelegate, SpaceshipDelegate, GameplayControlsDelegate, ShieldDelegate, PlayerWeaponDelegate, SASpriteNodeDelegate>

@property (nonatomic, weak) id <SpaceshipSceneDelegate> customDelegate;
@property (nonatomic) BOOL contentCreated;
@property (nonatomic) Spaceship * mySpaceship;
@property (nonatomic) GameplayControls * sharedGameplayControls;
@property (nonatomic) SpaceObjectsKit * spaceObjectKit;
@property (nonatomic) EnemyKit * enemyKit;
@property (nonatomic) BOOL showingTooltip;

//asteroids
@property (nonatomic) float makeAsteroidsInterval;
@property (nonatomic) float asteroidSpeedCoefficient;
@property (nonatomic) float minimumAsteroidDegree;
@property (nonatomic) float maximumAsteroidDegree;
- (void) moreAsteroids;
@property (nonatomic) NSTimer * asteroidTimer;
@property (nonatomic) NSArray * asteroidTextureAtlas; //i dont think i need this
@property (nonatomic) BOOL resumeAsteroidTimer;

//enemies
@property (nonatomic) int rangeOfEnemiesToAdd;
@property (nonatomic) float makeEnemiesInterval;
@property (nonatomic) float enemySpeedCoefficient;
@property (nonatomic) NSTimer * enemyTimer;
@property (nonatomic) BOOL resumeEnemyTimer;

//background
@property (nonatomic) NSTimer * backgroundPlanetsTimer;
@property (nonatomic) BOOL resumeBackgroundPlanetsTimer;
@property (nonatomic) NSTimer * changeCloudDensityTimer;
@property (nonatomic) BOOL resumeChangeCloudDensityTimer;
@property (nonatomic) float lastSpaceBackgroundDuration;

//achievements'
@property (nonatomic) NSTimer * periodicAchievementUpdatingTimer;
@property (nonatomic) BOOL resumePeriodicAchievementUpdatingTimer;
@property (nonatomic) int bulletsFired;
@property (nonatomic) int photonsFired;
@property (nonatomic) int lasersFired;
@property (nonatomic) int electricityFired;
@property (nonatomic) int enemiesDestroyed;
@property (nonatomic) int powerUpsCollected;

//HUD
@property (nonatomic) int pointsScored;
@property (nonatomic) SKLabelNode * pointsScoredLabel;
@property (nonatomic) int enemiesDestroyedWithoutTakingDamage;
@property (nonatomic) int scoreMultiplier;
@property (nonatomic) SKLabelNode * scoreMultiplierLabel;


- (SKNode *) nextPriorityTargetForElectricity:(Electricity *)electricity;
- (SKNode *) nextPriorityTargetForPhoton:(Photon *)photon;
- (float) distanceBetweenNodeA:(SKNode *)nodeA andNodeB:(SKNode *)nodeB;

- (void) pauseGame;
- (void) resumeGame;

@end
