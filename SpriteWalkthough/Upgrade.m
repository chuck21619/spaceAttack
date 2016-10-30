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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"DoubleWeaponUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 75000;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SmartPhotonUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 250;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ammoUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 750;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"ShieldUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 2800;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"laserUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 17200;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"electrictyUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 25000;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SpeedBoostUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 1500;
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
                self.animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"fourWeaponsUpgrade.gif" ofType:nil]]]];
                self.pointsToUnlock = 500000;
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
    }
    return self;
}

- (void) unlockUpgrade
{
    self.isUnlocked = YES;
}

- (NSString*) description
{
    return self.title;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
