//
//  Upgrade.m
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "Upgrade.h"
#import "AccountManager.h"

@implementation Upgrade

- (instancetype) initWithUpgradeType:(UpgradeType)upgradeType
{
    if ( self = [super init] )
    {
        switch (upgradeType)
        {
            case kUpgrade2Weapons:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementTwoWeapons" object:nil];
                self.storeKitIdentifier = @"TwoWeapons";
                self.title = NSLocalizedString(@"Two Weapons", nil);
                self.upgradeDescription = NSLocalizedString(@"Your spaceships will be able to equip two different weapons!", nil);
                self.icon = [UIImage imageNamed:@"Double Weapon.png"];
                self.pointsToUnlock = 50000;
                self.priceToUnlock = 2.99;
                if ( [AccountManager numberOfWeaponSlotsUnlocked] >= 2)
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
                
            case kUpgradeSmartPhotons:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementSmartPhotons" object:nil];
                self.storeKitIdentifier = @"SmartPhotons";
                self.title = NSLocalizedString(@"Smart Photons", nil);
                self.upgradeDescription = NSLocalizedString(@"Increases Photon Targeting IQ", nil);
                self.icon = [UIImage imageNamed:@"Smart Photon.png"];
                self.pointsToUnlock = 15000;
                self.priceToUnlock = 1.99;
                if ( [AccountManager smartPhotonsUnlocked] )
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
            
            case kUpgradeMachineGunFireRate:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementMachineGunFireRate" object:nil];
                self.storeKitIdentifier = @"MachineGunFireRate";
                self.title = NSLocalizedString(@"More Bullets", nil);
                self.upgradeDescription = NSLocalizedString(@"Increases rate of fire for the Machine Gun", nil);
                self.icon = [UIImage imageNamed:@"Bullets.png"];
                self.pointsToUnlock = 10000;
                self.priceToUnlock = .99;
                if ( [AccountManager machineGunFireRateUpgraded] )
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
            
            case kUpgradeShield:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementShield" object:nil];
                self.storeKitIdentifier = @"Shield";
                self.title = NSLocalizedString(@"Shield", nil);
                self.upgradeDescription = NSLocalizedString(@"Unlocks the Shield Power Up", nil);
                self.icon = [UIImage imageNamed:@"Shields.png"];
                self.pointsToUnlock = 20000;
                self.priceToUnlock = 1.99;
                if ( [AccountManager shieldUnlocked] )
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
                
            case kUpgradeBiggerLaser:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementBiggerLaser" object:nil];
                self.storeKitIdentifier = @"BiggerLaser";
                self.title = NSLocalizedString(@"Bigger Laser", nil);
                self.upgradeDescription = NSLocalizedString(@"Increases the size of Laser Cannon Beams", nil);
                self.icon = [UIImage imageNamed:@"Lasers.png"];
                self.pointsToUnlock = 12500;
                self.priceToUnlock = .99;
                if ( [AccountManager laserUpgraded] )
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
                
            case kUpgradeElectricityChain:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementElectricityChain" object:nil];
                self.storeKitIdentifier = @"ElectricityChain";
                self.title = NSLocalizedString(@"Electricity Chain", nil);
                self.upgradeDescription = NSLocalizedString(@"Powers up the Electrical Generator to send volts through to a second target", nil);
                self.icon = [UIImage imageNamed:@"Electricity.png"];
                self.pointsToUnlock = 15000;
                self.priceToUnlock = .99;
                if ( [AccountManager electricityChainUnlocked] )
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
                
            case kUpgradeEnergyBooster:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementEnergyBooster" object:nil];
                self.storeKitIdentifier = @"EnergyBooster";
                self.title = NSLocalizedString(@"Energy Booster", nil);
                self.upgradeDescription = NSLocalizedString(@"Unlocks the Energy Booster Power Up. Doubles Points and Damage for 30 seconds", nil);
                self.icon = [UIImage imageNamed:@"Energy.png"];
                self.pointsToUnlock = 12500;
                self.priceToUnlock = 1.99;
                if ( [AccountManager energyBoosterUnlocked] )
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
                
            case kUpgrade4Weapons:
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unlockUpgrade) name:@"unlocked_kAchievementFourWeapons" object:nil];
                self.storeKitIdentifier = @"FourWeapons";
                self.title = NSLocalizedString(@"Four Weapons", nil);
                self.upgradeDescription = NSLocalizedString(@"Your spaceships will be able to equip four different weapons!", nil);
                self.icon = [UIImage imageNamed:@"Questionmark.png"];
                self.pointsToUnlock = 500000;
                self.priceToUnlock = 9.99;
                if ( [AccountManager numberOfWeaponSlotsUnlocked] >= 4)
                    self.isUnlocked = YES;
                else
                    self.isUnlocked = NO;
                break;
                
            default:
                break;
        }
        
        self.isMaximized = NO;
        self.isValidForMoneyPurchase = NO;
        self.upgradeType = upgradeType;
        self.demoScene = [[UpgradeScene alloc] initWithUpgradeType:upgradeType];
    }
    return self;
}

- (void) unlockUpgrade
{
    self.isUnlocked = YES;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
