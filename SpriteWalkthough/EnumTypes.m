//
//  EnumTypes.m
//  SpaceAttack
//
//  Created by charles johnston on 8/10/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "EnumTypes.h"

@implementation EnumTypes

+ (NSString *) identifierFromAchievement:(Achievement)achievement
{
    switch (achievement)
    {
        case kAchievementMaxLevelMachineGun:
            return @"MaxLevelMachineGun";
        
        case kAchievementMaxLevelPhotonCannon:
            return @"MaxLevelPhotonCannon";
            
        case kAchievementMaxLevelElectricalGenerator:
            return @"MaxLevelElectricalGenerator";
            
        case kAchievementMaxLevelLaserCannon:
            return @"MaxLevelLaserCannon";
            
        case kAchievementPurchasedBabenberg:
            return @"purchasedBabenberg";
            
        case kAchievementPurchasedCaiman:
            return @"purchasedCaiman";
            
        case kAchievementPurchasedDandolo:
            return @"purchasedDandolo";
            
        case kAchievementPurchasedEdinburgh:
            return @"purchasedEdinburgh";
            
        case kAchievementPurchasedFlandre:
            return @"purchasedFlandre";
            
        case kAchievementPurchasedGascogne:
            return @"purchasedGascogne";
            
        case kAchievementPurchasedHabsburg:
            return @"purchasedHabsburg";
            
        case kAchievementPurchasedAllShips:
            return @"PurchasedAllShips";
            
        case kAchievementTwoWeapons:
            return @"TwoWeapons";
            
        case kAchievementFourWeapons:
            return @"FourWeapons";
            
        case kAchievementSmartPhotons:
            return @"SmartPhotons";
            
        case kAchievementMachineGunFireRate:
            return @"MachineGunFireRate";
            
        case kAchievementShield:
            return @"Shield";
            
        case kAchievementBiggerLaser:
            return @"BiggerLaser";
            
        case kAchievementElectricityChain:
            return @"ElectricityChain";
            
        case kAchievementEnergyBooster:
            return @"EnergyBooster";
            
        case kAchievementAllUpgrades:
            return @"AllUpgrades";
        
        case kAchievementBulletsFired100:
            return @"BulletsFired100";
            
        case kAchievementBulletsFired1000:
            return @"BulletsFired1000";
            
        case kAchievementBulletsFired10000:
            return @"BulletsFired10000";
            
        case kAchievementBulletsFired100000:
            return @"BulletsFired100000";
            
        case kAchievementPhotonsFired25:
            return @"PhotonsFired25";
            
        case kAchievementPhotonsFired250:
            return @"PhotonsFired250";
            
        case kAchievementPhotonsFired2500:
            return @"PhotonsFired2500";
            
        case kAchievementPhotonsFired25000:
            return @"PhotonsFired25000";
            
        case kAchievementLasersFired15:
            return @"LasersFired15";
            
        case kAchievementLasersFired150:
            return @"LasersFired150";
            
        case kAchievementLasersFired1500:
            return @"LasersFired1500";
            
        case kAchievementLasersFired15000:
            return @"LasersFired15000";
            
        case kAchievementElectricityFired20:
            return @"ElectricityFired20";
            
        case kAchievementElectricityFired200:
            return @"ElectricityFired200";
            
        case kAchievementElectricityFired2000:
            return @"ElectricityFired2000";
            
        case kAchievementElectricityFired20000:
            return @"ElectricityFired20000";
            
        case kAchievementEnemiesDestroyed50:
            return @"EnemiesDestroyed50";
            
        case kAchievementEnemiesDestroyed500:
            return @"EnemiesDestroyed500";
            
        case kAchievementEnemiesDestroyed5000:
            return @"EnemiesDestroyed5000";
            
        case kAchievementEnemiesDestroyed50000:
            return @"EnemiesDestroyed50000";
            
        case kAchievementPowerUpsCollected3:
            return @"PowerUpsCollected3";
            
        case kAchievementPowerUpsCollected30:
            return @"PowerUpsCollected30";
            
        case kAchievementPowerUpsCollected300:
            return @"PowerUpsCollected300";
            
        case kAchievementPowerUpsCollected3000:
            return @"PowerUpsCollected3000";
            
        case kAchievementAllAchievements:
            return @"AllAchievements";
            
        default:
            return @"";
    }
}

+ (Achievement) achievementFromIdentifier:(NSString *)identifer
{
    for ( int i = 0; i < kAchievementAllAchievements; i++ )
    {
        if ( [identifer isEqualToString:[EnumTypes identifierFromAchievement:i]] )
            return i;
    }
    
    return -1;
}

+ (BOOL) isWeaponPowerUp:(PowerUpType)powerUp
{
    if ( powerUp == kPowerUpTypeMachineGun ||
         powerUp == kPowerUpTypePhotonCannon ||
         powerUp == kPowerUpTypeLaserCannon ||
         powerUp == kPowerUpTypeElectricalGenerator )
        return YES;
    
    return NO;
}

@end
