//
//  EnumTypes.h
//  SpaceAttack
//
//  Created by charles johnston on 8/10/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int, PowerUpType)
{
    kPowerUpTypeMachineGun,
    kPowerUpTypePhotonCannon,
    kPowerUpTypeLaserCannon,
    kPowerUpTypeElectricalGenerator,
    kPowerUpTypeShield,
    kPowerUpTypeEnergyBooster,
    kPowerUpTypeCount
};

typedef NS_ENUM(int, EnemyType)
{
    kEnemyTypeBasic,
    kEnemyTypeFast,
    kEnemyTypeBig,
    kEnemyTypeCount
};

typedef NS_ENUM(int, TooltipType)
{
    kTooltipTypePowerUp,
    kTooltipTypeAvoidObstacles,
    kTooltipTypeMoveSpaceship,
    kTooltipTypeScoringPoints,
    kTooltipTypeScoreMultiplier
};

typedef NS_ENUM(int, Achievement)
{
    kAchievementMaxLevelMachineGun,
    kAchievementMaxLevelPhotonCannon,
    kAchievementMaxLevelElectricalGenerator,
    kAchievementMaxLevelLaserCannon,
    kAchievementPurchasedBabenberg,
    kAchievementPurchasedCaiman,
    kAchievementPurchasedDandolo,
    kAchievementPurchasedEdinburgh,
    kAchievementPurchasedFlandre,
    kAchievementPurchasedGascogne,
    kAchievementPurchasedHabsburg,
    kAchievementPurchasedAllShips,
    kAchievementTwoWeapons,
    kAchievementFourWeapons,
    kAchievementSmartPhotons,
    kAchievementMachineGunFireRate,
    kAchievementShield,
    kAchievementBiggerLaser,
    kAchievementElectricityChain,
    kAchievementEnergyBooster,
    kAchievementAllUpgrades,
    kAchievementBulletsFired100,
    kAchievementBulletsFired1000,
    kAchievementBulletsFired10000,
    kAchievementBulletsFired100000,
    kAchievementPhotonsFired25,
    kAchievementPhotonsFired250,
    kAchievementPhotonsFired2500,
    kAchievementPhotonsFired25000,
    kAchievementLasersFired15,
    kAchievementLasersFired150,
    kAchievementLasersFired1500,
    kAchievementLasersFired15000,
    kAchievementElectricityFired20,
    kAchievementElectricityFired200,
    kAchievementElectricityFired2000,
    kAchievementElectricityFired20000,
    kAchievementEnemiesDestroyed50,
    kAchievementEnemiesDestroyed500,
    kAchievementEnemiesDestroyed5000,
    kAchievementEnemiesDestroyed50000,
    kAchievementPowerUpsCollected3,
    kAchievementPowerUpsCollected30,
    kAchievementPowerUpsCollected300,
    kAchievementPowerUpsCollected3000,
    kAchievementAllAchievements
};

typedef NS_ENUM(int, UpgradeType)
{
    kUpgrade2Weapons,
    kUpgradeSmartPhotons,
    kUpgradeMachineGunFireRate,
    kUpgradeShield,
    kUpgradeBiggerLaser,
    kUpgradeElectricityChain,
    kUpgradeEnergyBooster,
    kUpgrade4Weapons,
    kUpgradeCount
};

typedef NS_ENUM(int, SoundEffect)
{
    kSoundEffectMainMenuButton,
    kSoundEffectBullet,
    kSoundEffectElectricity,
    kSoundEffectLaser,
    kSoundEffectPhoton,
    kSoundEffectPhotonExplosion,
    kSoundEffectExplosionEnemyBasic,
    kSoundEffectExplosionEnemyFast,
    kSoundEffectExplosionEnemyBig,
    kSoundEffectExplosionSpaceship,
    kSoundEffectAsteroidCrumble,
    kSoundEffectShieldDamage,
    kSoundEffectShieldDestroy,
    kSoundEffectShieldEquip,
    kSoundEffectEnergyBoosterStart,
    kSoundEffectEnergyBoosterEnd,
    kSoundEffectEquipMachineGun,
    kSoundEffectEquipLaserCannon,
    kSoundEffectEquipElectricalGenerator,
    kSoundEffectEquipPhotonCannon,
    kSoundEffectEnemyDamage,
    kSoundEffectSpaceshipDamage,
    kSoundEffectMultiplierIncrease,
    kSoundEffectMultiplierLost,
    kSoundEffectToolTip,
    kSoundEffectMenuUnlock,
    kSoundEffectMenuSettings,
    kSoundEffectMenuUpgradeMinimize,
    kSoundEffectMenuUpgradeMaximize,
    kSoundEffectMenuBackButton,
    kSoundEffectMenuHighScoreAchievements,
    kSoundEffectMenuUpgrade,
    kSoundEffectMenuEngage,
    kSoundEffectMenuDidUnlock,
    kSoundEffectMenuSelectShip,
    kSoundEffectMinimizeCell,
    kSoundEffectMaximizeCell,
    kSoundEffectMenuPageTurn
};

@interface EnumTypes : NSObject

+ (NSString *) identifierFromAchievement:(Achievement)achievement;
+ (Achievement) achievementFromIdentifier:(NSString *)identifer;
+ (BOOL) isWeaponPowerUp:(PowerUpType)powerUp;

@end
