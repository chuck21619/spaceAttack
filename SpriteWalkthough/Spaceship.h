//
//  Spaceship.h
//  SpriteWalkthough
//
//  Created by chuck on 4/2/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PlayerWeaponsKit.h"
#import "EnumTypes.h"
#import "Shield.h"
@import StoreKit;

@class Spaceship;
@protocol SpaceshipDelegate <NSObject>
- (void) spaceshipExploded:(Spaceship *)spaceship;
- (void) spaceshipTookDamage:(Spaceship *)spaceship;
- (void) spaceshipEquippedWeapon:(PlayerWeapon *)weapon;
- (void) energyBoosterChanged:(Spaceship *)spaceship;
@end


@interface Spaceship : SKSpriteNode

@property (nonatomic, weak) id <SpaceshipDelegate> delegate;

@property (nonatomic) NSString * storeKitIdentifier;
@property (nonatomic) SKProduct * storeKitProduct;
@property (nonatomic) BOOL isValidForMoneyPurchase;
@property (nonatomic) NSString * priceString;

@property (nonatomic) int defaultDamage;
@property (nonatomic) int damage;
@property (nonatomic) int armor;
@property (nonatomic) int mySpeed; //'speed' is a reserved keyword
@property (nonatomic) int pointsToUnlock;
@property (nonatomic) BOOL energyBoosterActive;
@property (nonatomic) NSTimer * energyBoosterTimer;
@property (nonatomic) NSMutableDictionary * equippedWeapons;
@property (nonatomic) NSDictionary * weaponSlotPositions;
@property (nonatomic) Shield * equippedShield;
@property (nonatomic) SKAction * pulseRed;

- (BOOL)isUnlocked;
//- (BOOL) fireMissile;
- (void) takeDamage;
- (void) explode;
- (void) powerUpCollected:(PowerUpType)powerUp;
- (void) setExhaustTargetNode:(SKNode *)node;
- (void) setNumberOfWeaponSlots:(int)numberOfWeaponSlots;
- (void) increaseExhaustSpeed;

@end
