//
//  AccountManager.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "AccountManager.h"
#import "FullScreenAdSingleton.h"
#import "Upgrade.h"
#import "AudioManager.h"
#import <GameKit/GameKit.h>
#import <Crashlytics/Crashlytics.h>

@implementation AccountManager

static AccountManager * sharedAccountManager = nil;
+ (AccountManager *)sharedInstance
{
    if ( sharedAccountManager == nil )
    {
        sharedAccountManager = [[AccountManager alloc] init];
        sharedAccountManager.userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"ZinStudio"];
        
//#warning comment out for release builds
//        [sharedAccountManager.userDefaults removePersistentDomainForName:@"ZinStudio"]; //clear all defaults
//        [AccountManager addPoints:5000000];
        
        sharedAccountManager.fullScreenAdIteration = YES;
        sharedAccountManager.firstGameplaySinceLaunch = YES;
        NSDate * bogusDate = [[NSDate date] dateByAddingTimeInterval:5000]; // this date will never get fired
        sharedAccountManager.fullScreenAdTimer = [[NSTimer alloc] initWithFireDate:bogusDate interval:0 target:sharedAccountManager selector:@selector(fullScreenAdTimerFired:) userInfo:nil repeats:NO];
        sharedAccountManager.upgrades = @[[[Upgrade alloc] initWithUpgradeType:kUpgrade2Weapons],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgradeSmartPhotons],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgradeMachineGunFireRate],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgradeShield],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgradeBiggerLaser],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgradeElectricityChain],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgradeEnergyBooster],
                                          [[Upgrade alloc] initWithUpgradeType:kUpgrade4Weapons]];
        
        sharedAccountManager.spaceships = @[[Abdul_Kadir new],
                                            [Babenberg new],
                                            [Caiman new],
                                            [Dandolo new],
                                            [Edinburgh new],
                                            [Flandre new],
                                            [Gascogne new],
                                            [Habsburg new]];
    }
    
    return sharedAccountManager;
}

#pragma mark - store kit
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    NSLog(@"account manager - paymentQueue");
    for (SKPaymentTransaction *transaction in transactions)
    {
        NSLog(@"transaction : %@", transaction);
        NSLog(@"error : %@", transaction.error);
        NSLog(@"payment : %@", transaction.payment);
        NSLog(@"payment.productIdentifier ::: %@", transaction.payment.productIdentifier);
        NSLog(@"identifier : %@", transaction.transactionIdentifier);
        NSLog(@"state : %li", (long)transaction.transactionState);
        
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                break;
            
            case SKPaymentTransactionStateDeferred:
                break;
                
            case SKPaymentTransactionStateFailed:
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SKPaymentTransactionStateFailed" object:nil];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStatePurchased:
                if ( [transaction.payment.productIdentifier isEqualToString:@"TwoWeapons"] )
                    [AccountManager unlockUpgrade:kUpgrade2Weapons];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"SmartPhotons"] )
                    [AccountManager unlockUpgrade:kUpgradeSmartPhotons];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"MachineGunFireRate"] )
                    [AccountManager unlockUpgrade:kUpgradeMachineGunFireRate];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"Shield"] )
                    [AccountManager unlockUpgrade:kUpgradeShield];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"BiggerLaser"] )
                    [AccountManager unlockUpgrade:kUpgradeBiggerLaser];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"ElectricityChain"] )
                    [AccountManager unlockUpgrade:kUpgradeElectricityChain];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"EnergyBooster"] )
                    [AccountManager unlockUpgrade:kUpgradeEnergyBooster];
                else if ( [transaction.payment.productIdentifier isEqualToString:@"FourWeapons"] )
                    [AccountManager unlockUpgrade:kUpgrade4Weapons];
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SKPaymentTransactionStatePurchased" object:nil];
                break;
                
            case SKPaymentTransactionStateRestored:
                break;
                
            default:
                // For debugging
                //NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }
    }
}

#pragma mark - upgrades
+ (void) unlockUpgrade:(UpgradeType)upgrade
{
    //NSLog(@"account manager - unlockUpgrade : %i", upgrade);
    switch (upgrade)
    {
        case kUpgrade2Weapons:
            [AccountManager setNumberOfWeaponSlots:2];
            [AccountManager submitCompletedAchievement:kAchievementTwoWeapons];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementTwoWeapons" object:nil];
            break;
            
        case kUpgradeSmartPhotons:
            [sharedAccountManager.userDefaults setBool:YES forKey:@"smartPhotons"];
            [AccountManager submitCompletedAchievement:kAchievementSmartPhotons];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementSmartPhotons" object:nil];
            break;
            
        case kUpgradeMachineGunFireRate:
            [sharedAccountManager.userDefaults setBool:YES forKey:@"machineGunFireRateUpgraded"];
            [AccountManager submitCompletedAchievement:kAchievementMachineGunFireRate];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementMachineGunFireRate" object:nil];
            break;

        case kUpgradeShield:
            [sharedAccountManager.userDefaults setBool:YES forKey:@"shieldUnlocked"];
            [AccountManager submitCompletedAchievement:kAchievementShield];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementShield" object:nil];
            break;
            
        case kUpgradeBiggerLaser:
            [sharedAccountManager.userDefaults setBool:YES forKey:@"laserUpgraded"];
            [AccountManager submitCompletedAchievement:kAchievementBiggerLaser];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementBiggerLaser" object:nil];
            break;
            
        case kUpgradeElectricityChain:
            [sharedAccountManager.userDefaults setBool:YES forKey:@"electricityChainUnlocked"];
            [AccountManager submitCompletedAchievement:kAchievementElectricityChain];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementElectricityChain" object:nil];
            break;
            
        case kUpgradeEnergyBooster:
            [sharedAccountManager.userDefaults setBool:YES forKey:@"energyBoosterUnlocked"];
            [AccountManager submitCompletedAchievement:kAchievementEnergyBooster];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementEnergyBooster" object:nil];
            break;
            
        case kUpgrade4Weapons:
            [AccountManager setNumberOfWeaponSlots:4];
            [AccountManager submitCompletedAchievement:kAchievementFourWeapons];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unlocked_kAchievementFourWeapons" object:nil];
            break;
            
        default:
            break;
    }
}

+ (int) numberOfWeaponSlotsUnlocked
{
    //NSLog(@"account manager - numberOfweaponSlotsUnlocked");
    int numberOfWeaponSlotsUnlocked = (int)[sharedAccountManager.userDefaults integerForKey:@"numberOfWeaponSlotsUnlocked"];
    if ( ! numberOfWeaponSlotsUnlocked )
    {
        numberOfWeaponSlotsUnlocked = 1;
        [sharedAccountManager.userDefaults setInteger:numberOfWeaponSlotsUnlocked forKey:@"numberOfWeaponSlotsUnlocked"];
    }
    
    return numberOfWeaponSlotsUnlocked;
}

+ (void) setNumberOfWeaponSlots:(int)weaponSlots
{
    //NSLog(@"account manager - setNumberOfWeaponSlots");
    [sharedAccountManager.userDefaults setInteger:weaponSlots forKey:@"numberOfWeaponSlotsUnlocked"];
}

+ (BOOL) smartPhotonsUnlocked
{
    //NSLog(@"account manager - smartPhotonsUnlocked");
    return [sharedAccountManager.userDefaults boolForKey:@"smartPhotons"];
}

+ (BOOL) machineGunFireRateUpgraded
{
    //NSLog(@"account manager - machineGunFireRateUpgraded");
    return [sharedAccountManager.userDefaults boolForKey:@"machineGunFireRateUpgraded"];
}

+ (BOOL) shieldUnlocked
{
    //NSLog(@"account manager - shieldUnlocked");
    return [sharedAccountManager.userDefaults boolForKey:@"shieldUnlocked"];
}

+ (BOOL) laserUpgraded
{
    //NSLog(@"account manager - laserUpgraded");
    return [sharedAccountManager.userDefaults boolForKey:@"laserUpgraded"];
}

+ (BOOL) electricityChainUnlocked
{
    //NSLog(@"account manager - electricityChainUnlocked");
    return [sharedAccountManager.userDefaults boolForKey:@"electricityChainUnlocked"];
}

+ (BOOL) energyBoosterUnlocked
{
    //NSLog(@"account manager - energyBoosterUnlocked");
    return [sharedAccountManager.userDefaults boolForKey:@"energyBoosterUnlocked"];
}

+ (BOOL) enoughGamePointsToUnlockAnUpgrade
{
    for ( Upgrade * upgrade in sharedAccountManager.upgrades )
    {
        if ( !upgrade.isUnlocked && [AccountManager availablePoints] >= upgrade.pointsToUnlock )
            return YES;
    }
    
    return NO;
}

#pragma mark - points
+ (int) availablePoints
{
    //NSLog(@"account manager - availablePoints");
    int availablePoints = (int)[sharedAccountManager.userDefaults integerForKey:@"availablePoints"];
    if ( ! availablePoints )
    {
        availablePoints = 0;
        [sharedAccountManager.userDefaults setInteger:availablePoints forKey:@"availablePoints"];
    }
    
    return availablePoints;
}

+ (void) addPoints:(int)points
{
    //NSLog(@"account manager - addPoints");
    int availablePoints = [AccountManager availablePoints];
    availablePoints += points;
    [sharedAccountManager.userDefaults setInteger:availablePoints forKey:@"availablePoints"];
}

+ (void) subtractPoints:(int)points
{
    //NSLog(@"account manager - subtractPoints");
    int availablePoints = [AccountManager availablePoints];
    availablePoints -= points;
    [sharedAccountManager.userDefaults setInteger:availablePoints forKey:@"availablePoints"];
}

#pragma mark - ships
+ (NSArray *)unlockedShips
{
    //NSLog(@"account manager - unlockedShips");
    NSMutableArray * availableShips = [sharedAccountManager.userDefaults valueForKey:@"availableShips"];
    if ( ! availableShips )
    {
        availableShips = [[NSMutableArray alloc] init];
        [availableShips addObject:NSStringFromClass([Abdul_Kadir class])];
        [sharedAccountManager.userDefaults setObject:availableShips forKey:@"availableShips"];
    }
    
    return availableShips;
}

+ (BOOL) shipIsUnlocked:(Spaceship *)spaceship
{
    //NSLog(@"account manager - shipIsUnlocked");
    if ( [[AccountManager unlockedShips] containsObject:NSStringFromClass([spaceship class])] )
        return YES;
    
    return NO;
}

+ (void)unlockShip:(Spaceship *)spaceship
{
    //NSLog(@"account manager - unlockShip");
    NSString * spaceshipString = NSStringFromClass([spaceship class]);
    NSMutableArray * availableShips = [[AccountManager unlockedShips] mutableCopy];
    
    if ( ![availableShips containsObject:spaceshipString] )
        [availableShips addObject:spaceshipString];
    
    [sharedAccountManager.userDefaults setObject:availableShips forKey:@"availableShips"];
    
    if ( [spaceshipString isEqualToString:@"Babenberg"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedBabenberg];
    else if ( [spaceshipString isEqualToString:@"Caiman"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedCaiman];
    else if ( [spaceshipString isEqualToString:@"Dandolo"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedDandolo];
    else if ( [spaceshipString isEqualToString:@"Edinburgh"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedEdinburgh];
    else if ( [spaceshipString isEqualToString:@"Flandre"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedFlandre];
    else if ( [spaceshipString isEqualToString:@"Gascogne"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedGascogne];
    else if ( [spaceshipString isEqualToString:@"Habsburg"] )
        [AccountManager submitCompletedAchievement:kAchievementPurchasedHabsburg];
}


+ (Spaceship *) lastSelectedShip
{
    //NSLog(@"account manager - lastSelectedShip");
    NSString * lastSelectedShipString = [sharedAccountManager.userDefaults valueForKey:@"lastSelectedShip"];
    if ( ! lastSelectedShipString )
    {
        lastSelectedShipString = NSStringFromClass([Abdul_Kadir class]);
        [sharedAccountManager.userDefaults setObject:lastSelectedShipString forKey:@"lastSelectedShip"];
        return [Abdul_Kadir new];
    }
    
    if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Abdul_Kadir class])] )
        return [Abdul_Kadir new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Babenberg class])] )
        return [Babenberg new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Caiman class])] )
        return [Caiman new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Dandolo class])] )
        return [Dandolo new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Edinburgh class])] )
        return [Edinburgh new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Flandre class])] )
        return [Flandre new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Gascogne class])] )
        return [Gascogne new];
    else if ( [lastSelectedShipString isEqualToString:NSStringFromClass([Habsburg class])] )
        return [Habsburg new];
    else
        return [Abdul_Kadir new];
    
    return nil;
}

+ (void) setLastSelectedShip:(Spaceship *)spaceship
{
    //NSLog(@"account manager - setLastSelectedShip");
    [sharedAccountManager.userDefaults setObject:NSStringFromClass([spaceship class]) forKey:@"lastSelectedShip"];
}

+ (BOOL) enoughGamePointsToUnlockAShip
{
    for ( Spaceship * spaceship in sharedAccountManager.spaceships )
    {
        if ( !spaceship.isUnlocked && [AccountManager availablePoints] >= spaceship.pointsToUnlock )
            return YES;
    }
    
    return NO;
}

#pragma mark - tooltips
+ (BOOL) shouldShowTooltip:(TooltipType)tooltipType
{
    //NSLog(@"account manager - shouldShowTooltip");
    NSMutableArray * tooltipsShown = [[sharedAccountManager.userDefaults valueForKey:@"tooltipsShown"] mutableCopy];
    if ( ! tooltipsShown )
        tooltipsShown = [NSMutableArray new];
    
    BOOL returnValue = NO;
    
    switch (tooltipType)
    {
        case kTooltipTypePowerUp:
            if ( [tooltipsShown containsObject:@"kTooltipTypePowerUp"] )
                returnValue = NO;
            else
            {
                [tooltipsShown addObject:@"kTooltipTypePowerUp"];
                [sharedAccountManager.userDefaults setValue:tooltipsShown forKey:@"tooltipsShown"];
                returnValue = YES;
            }
            break;
        
        case kTooltipTypeMoveSpaceship:
            if ( [tooltipsShown containsObject:@"kTooltipTypeMoveSpaceship"] )
                returnValue = NO;
            else
            {
                [tooltipsShown addObject:@"kTooltipTypeMoveSpaceship"];
                [sharedAccountManager.userDefaults setValue:tooltipsShown forKey:@"tooltipsShown"];
                returnValue = YES;
            }
            break;
            
        case kTooltipTypeScoringPoints:
            if ( [tooltipsShown containsObject:@"kTooltipTypeScoringPoints"] )
                returnValue = NO;
            else
            {
                [tooltipsShown addObject:@"kTooltipTypeScoringPoints"];
                [sharedAccountManager.userDefaults setValue:tooltipsShown forKey:@"tooltipsShown"];
                returnValue = YES;
            }
            break;
            
        case kTooltipTypeAvoidObstacles:
            if ( [tooltipsShown containsObject:@"kTooltipTypeAvoidObstacles"] )
                returnValue = NO;
            else
            {
                [tooltipsShown addObject:@"kTooltipTypeAvoidObstacles"];
                [sharedAccountManager.userDefaults setValue:tooltipsShown forKey:@"tooltipsShown"];
                returnValue = YES;
            }
            break;
            
        case kTooltipTypeScoreMultiplier:
            if ( [tooltipsShown containsObject:@"kTooltipTypeScoreMultiplier"] )
                returnValue = NO;
            else
            {
                [tooltipsShown addObject:@"kTooltipTypeScoreMultiplier"];
                [sharedAccountManager.userDefaults setValue:tooltipsShown forKey:@"tooltipsShown"];
                returnValue = YES;
            }
            break;
    }
    
    if ( returnValue )
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectToolTip];
    
    return returnValue;
}

+ (void) disableTips
{
    //NSLog(@"account manager - disableTips");
    NSArray * tooltipsShown = @[@"kTooltipTypePowerUp", @"kTooltipTypeAvoidObstacles", @"kTooltipTypeMoveSpaceship", @"kTooltipTypeScoringPoints", @"kTooltipTypeScoreMultiplier"];
    
    [sharedAccountManager.userDefaults setValue:tooltipsShown forKey:@"tooltipsShown"];
}

#pragma mark - game center
#pragma mark achievements
+ (NSArray *) achievementsCompleted
{
    //NSLog(@"account manager - achievementsCompleted");
    NSArray * achievementsCompleted = [sharedAccountManager.userDefaults valueForKey:@"achievementsCompleted"];
    if ( !achievementsCompleted )
    {
        achievementsCompleted = @[];
        [sharedAccountManager.userDefaults setValue:achievementsCompleted forKey:@"achievementsCompleted"];
    }
    return achievementsCompleted;
}

+ (NSArray *) achievements
{
    NSArray * cachedAchievements = [[AccountManager sharedInstance] cachedAchievements];
    if ( cachedAchievements )
        return cachedAchievements;
    
    NSData * encodedAchievements = [sharedAccountManager.userDefaults valueForKey:@"achievements"];
    NSArray * achievements = [NSKeyedUnarchiver unarchiveObjectWithData:encodedAchievements];
    if ( !achievements )
    {
        achievements = [AccountManager populateEmptyAchievements:[NSMutableArray new]];
        NSData * encodedAchievements = [NSKeyedArchiver archivedDataWithRootObject:achievements];
        [sharedAccountManager.userDefaults setValue:encodedAchievements forKey:@"achievements"];
    }
    [[AccountManager sharedInstance] setCachedAchievements:achievements];
    return achievements;
}

+ (NSMutableArray *) populateEmptyAchievements:(NSMutableArray *)achievements
{
    BOOL BulletsFired100exists = NO;
    BOOL BulletsFired1000exists = NO;
    BOOL BulletsFired10000exists = NO;
    BOOL BulletsFired100000exists = NO;
    
    BOOL PhotonsFired25exists = NO;
    BOOL PhotonsFired250exists = NO;
    BOOL PhotonsFired2500exists = NO;
    BOOL PhotonsFired25000exists = NO;
    
    BOOL LasersFired15exists = NO;
    BOOL LasersFired150exists = NO;
    BOOL LasersFired1500exists = NO;
    BOOL LasersFired15000exists = NO;
    
    BOOL ElectricityFired20exists = NO;
    BOOL ElectricityFired200exists = NO;
    BOOL ElectricityFired2000exists = NO;
    BOOL ElectricityFired20000exists = NO;
    
    BOOL EnemiesDestroyed50exists = NO;
    BOOL EnemiesDestroyed500exists = NO;
    BOOL EnemiesDestroyed5000exists = NO;
    BOOL EnemiesDestroyed50000exists = NO;
    
    BOOL PowerUpsCollected3exists = NO;
    BOOL PowerUpsCollected30exists = NO;
    BOOL PowerUpsCollected300exists = NO;
    BOOL PowerUpsCollected3000exists = NO;
    
    
    BOOL MaxLevelMachineGun = NO;
    BOOL MaxLevelPhotonCannon = NO;
    BOOL MaxLevelElectricalGenerator = NO;
    BOOL MaxLevelLaserCannon = NO;
    
    BOOL purchasedBabenberg = NO;
    BOOL purchasedCaiman = NO;
    BOOL purchasedDandolo = NO;
    BOOL purchasedEdinburgh = NO;
    BOOL purchasedFlandre = NO;
    BOOL purchasedGascogne = NO;
    BOOL purchasedHabsburg = NO;
    BOOL PurchasedAllShips = NO;
    
    BOOL SmartPhotons = NO;
    BOOL MachineGunFireRate = NO;
    BOOL Shield = NO;
    BOOL BiggerLaser = NO;
    BOOL ElectricityChain = NO;
    BOOL EnergyBooster = NO;
    BOOL TwoWeapons = NO;
    BOOL FourWeapons = NO;
    BOOL AllUpgrades = NO;
    
    
    BOOL AllAchievements = NO;
    
    
    for ( GKAchievement * achievo in achievements )
    {
        if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementBulletsFired100]] )
            BulletsFired100exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementBulletsFired1000]] )
            BulletsFired1000exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementBulletsFired10000]] )
            BulletsFired10000exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementBulletsFired100000]] )
            BulletsFired100000exists = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPhotonsFired25]] )
            PhotonsFired25exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPhotonsFired250]] )
            PhotonsFired250exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPhotonsFired2500]] )
            PhotonsFired2500exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPhotonsFired25000]] )
            PhotonsFired25000exists = YES;

        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementLasersFired15]] )
            LasersFired15exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementLasersFired150]] )
            LasersFired150exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementLasersFired1500]] )
            LasersFired1500exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementLasersFired15000]] )
            LasersFired15000exists = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementElectricityFired20]] )
            ElectricityFired20exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementElectricityFired200]] )
            ElectricityFired200exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementElectricityFired2000]] )
            ElectricityFired2000exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementElectricityFired20000]] )
            ElectricityFired20000exists = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementEnemiesDestroyed50]] )
            EnemiesDestroyed50exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementEnemiesDestroyed500]] )
            EnemiesDestroyed500exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementEnemiesDestroyed5000]] )
            EnemiesDestroyed5000exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementEnemiesDestroyed50000]] )
            EnemiesDestroyed50000exists = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPowerUpsCollected3]] )
            PowerUpsCollected3exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPowerUpsCollected30]] )
            PowerUpsCollected30exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPowerUpsCollected300]] )
            PowerUpsCollected300exists = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPowerUpsCollected3000]] )
            PowerUpsCollected3000exists = YES;
        
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementMaxLevelMachineGun]] )
            MaxLevelMachineGun = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementMaxLevelElectricalGenerator]] )
            MaxLevelElectricalGenerator = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementMaxLevelPhotonCannon]] )
            MaxLevelPhotonCannon = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementMaxLevelLaserCannon]] )
            MaxLevelLaserCannon = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedBabenberg]] )
            purchasedBabenberg = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedCaiman]] )
            purchasedCaiman = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedDandolo]] )
            purchasedDandolo = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedEdinburgh]] )
            purchasedEdinburgh = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedFlandre]] )
            purchasedFlandre = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedGascogne]] )
            purchasedGascogne = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedHabsburg]] )
            purchasedHabsburg = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] )
            PurchasedAllShips = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementSmartPhotons]] )
            SmartPhotons = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementMachineGunFireRate]] )
            MachineGunFireRate = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementShield]] )
            Shield = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementBiggerLaser]] )
            BiggerLaser = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementElectricityChain]] )
            ElectricityChain = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementEnergyBooster]] )
            EnergyBooster = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementTwoWeapons]] )
            TwoWeapons = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementFourWeapons]] )
            FourWeapons = YES;
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementAllUpgrades]] )
            AllUpgrades = YES;
        
        else if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementAllAchievements]] )
            AllAchievements = YES;
    }
    
    if ( ! BulletsFired100exists )
        [AccountManager populateAchievement:kAchievementBulletsFired100 inAchivements:achievements];
    if ( ! BulletsFired1000exists )
        [AccountManager populateAchievement:kAchievementBulletsFired1000 inAchivements:achievements];
    if ( ! BulletsFired10000exists )
        [AccountManager populateAchievement:kAchievementBulletsFired10000 inAchivements:achievements];
    if ( ! BulletsFired100000exists )
        [AccountManager populateAchievement:kAchievementBulletsFired100000 inAchivements:achievements];
    
    if ( ! PhotonsFired25exists )
        [AccountManager populateAchievement:kAchievementPhotonsFired25 inAchivements:achievements];
    if ( ! PhotonsFired250exists )
        [AccountManager populateAchievement:kAchievementPhotonsFired250 inAchivements:achievements];
    if ( ! PhotonsFired2500exists )
        [AccountManager populateAchievement:kAchievementPhotonsFired2500 inAchivements:achievements];
    if ( ! PhotonsFired25000exists )
        [AccountManager populateAchievement:kAchievementPhotonsFired25000 inAchivements:achievements];
    
    if ( ! LasersFired15exists )
        [AccountManager populateAchievement:kAchievementLasersFired15 inAchivements:achievements];
    if ( ! LasersFired150exists )
        [AccountManager populateAchievement:kAchievementLasersFired150 inAchivements:achievements];
    if ( ! LasersFired1500exists )
        [AccountManager populateAchievement:kAchievementLasersFired1500 inAchivements:achievements];
    if ( ! LasersFired15000exists )
        [AccountManager populateAchievement:kAchievementLasersFired15000 inAchivements:achievements];
    
    if ( ! ElectricityFired20exists )
        [AccountManager populateAchievement:kAchievementElectricityFired20 inAchivements:achievements];
    if ( ! ElectricityFired200exists )
        [AccountManager populateAchievement:kAchievementElectricityFired200 inAchivements:achievements];
    if ( ! ElectricityFired2000exists )
        [AccountManager populateAchievement:kAchievementElectricityFired2000 inAchivements:achievements];
    if ( ! ElectricityFired20000exists )
        [AccountManager populateAchievement:kAchievementElectricityFired20000 inAchivements:achievements];
    
    if ( ! EnemiesDestroyed50exists )
        [AccountManager populateAchievement:kAchievementEnemiesDestroyed50 inAchivements:achievements];
    if ( ! EnemiesDestroyed500exists )
        [AccountManager populateAchievement:kAchievementEnemiesDestroyed500 inAchivements:achievements];
    if ( ! EnemiesDestroyed5000exists )
        [AccountManager populateAchievement:kAchievementEnemiesDestroyed5000 inAchivements:achievements];
    if ( ! EnemiesDestroyed50000exists )
        [AccountManager populateAchievement:kAchievementEnemiesDestroyed50000 inAchivements:achievements];
    
    if ( ! PowerUpsCollected3exists )
        [AccountManager populateAchievement:kAchievementPowerUpsCollected3 inAchivements:achievements];
    if ( ! PowerUpsCollected30exists )
        [AccountManager populateAchievement:kAchievementPowerUpsCollected30 inAchivements:achievements];
    if ( ! PowerUpsCollected300exists )
        [AccountManager populateAchievement:kAchievementPowerUpsCollected300 inAchivements:achievements];
    if ( ! PowerUpsCollected3000exists )
        [AccountManager populateAchievement:kAchievementPowerUpsCollected3000 inAchivements:achievements];
    
    
    if ( ! MaxLevelMachineGun )
        [AccountManager populateAchievement:kAchievementMaxLevelMachineGun inAchivements:achievements];
    if ( ! MaxLevelPhotonCannon )
        [AccountManager populateAchievement:kAchievementMaxLevelPhotonCannon inAchivements:achievements];
    if ( ! MaxLevelElectricalGenerator )
        [AccountManager populateAchievement:kAchievementMaxLevelElectricalGenerator inAchivements:achievements];
    if ( ! MaxLevelLaserCannon )
        [AccountManager populateAchievement:kAchievementMaxLevelLaserCannon inAchivements:achievements];
    
    if ( ! purchasedBabenberg )
        [AccountManager populateAchievement:kAchievementPurchasedBabenberg inAchivements:achievements];
    if ( ! purchasedCaiman )
        [AccountManager populateAchievement:kAchievementPurchasedCaiman inAchivements:achievements];
    if ( ! purchasedDandolo )
        [AccountManager populateAchievement:kAchievementPurchasedDandolo inAchivements:achievements];
    if ( ! purchasedEdinburgh )
        [AccountManager populateAchievement:kAchievementPurchasedEdinburgh inAchivements:achievements];
    if ( ! purchasedFlandre )
        [AccountManager populateAchievement:kAchievementPurchasedFlandre inAchivements:achievements];
    if ( ! purchasedGascogne )
        [AccountManager populateAchievement:kAchievementPurchasedGascogne inAchivements:achievements];
    if ( ! purchasedHabsburg )
        [AccountManager populateAchievement:kAchievementPurchasedHabsburg inAchivements:achievements];
    if ( ! PurchasedAllShips )
        [AccountManager populateAchievement:kAchievementPurchasedAllShips inAchivements:achievements];
    
    if ( ! SmartPhotons )
        [AccountManager populateAchievement:kAchievementSmartPhotons inAchivements:achievements];
    if ( ! MachineGunFireRate )
        [AccountManager populateAchievement:kAchievementMachineGunFireRate inAchivements:achievements];
    if ( ! Shield )
        [AccountManager populateAchievement:kAchievementShield inAchivements:achievements];
    if ( ! BiggerLaser )
        [AccountManager populateAchievement:kAchievementBiggerLaser inAchivements:achievements];
    if ( ! ElectricityChain )
        [AccountManager populateAchievement:kAchievementElectricityChain inAchivements:achievements];
    if ( ! EnergyBooster )
        [AccountManager populateAchievement:kAchievementEnergyBooster inAchivements:achievements];
    if ( ! TwoWeapons )
        [AccountManager populateAchievement:kAchievementTwoWeapons inAchivements:achievements];
    if ( ! FourWeapons )
        [AccountManager populateAchievement:kAchievementFourWeapons inAchivements:achievements];
    if ( ! AllUpgrades )
        [AccountManager populateAchievement:kAchievementAllUpgrades inAchivements:achievements];
    
    if ( ! AllAchievements )
        [AccountManager populateAchievement:kAchievementAllAchievements inAchivements:achievements];
    
    return achievements;
}

+ (NSMutableArray *) populateAchievement:(Achievement)achievement inAchivements:(NSMutableArray *)achievements
{
    GKAchievement * tmpAchievement = [[GKAchievement alloc] initWithIdentifier:[EnumTypes identifierFromAchievement:achievement]];
    tmpAchievement.showsCompletionBanner = YES;
    tmpAchievement.percentComplete = 0;
    [achievements addObject:tmpAchievement];
    return achievements;
}

+ (NSMutableArray *) updateAchievement:(GKAchievement *)achievement inAchievements:(NSMutableArray *)achievements
{
    BOOL matchedIdentifier = NO;
    
    for ( GKAchievement __strong * achievo in achievements )
    {
        if ( [achievo.identifier isEqualToString:achievement.identifier] )
        {
            if ( achievement.percentComplete > achievo.percentComplete )
                achievo.percentComplete = achievement.percentComplete;
            
            matchedIdentifier = YES;
        }
    }
    
    if ( ! matchedIdentifier )
        [achievements addObject:achievement];
    
    return achievements;
}

+ (void) loadAchievements
{
    //NSLog(@"account manager - loadAchievements");
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray<GKAchievement *> * _Nullable achievements, NSError * _Nullable error)
    {
        if ( error )
        {
            NSLog(@"loadAchievements error : %@", error);
        }
        else
        {
            //NSLog(@"account manager - achievements loaded : %@", achievements);
            NSMutableArray * completedAchievementsForUserDefaults = [NSMutableArray new];
            NSMutableArray * achievementsForUserDefaults = [[AccountManager achievements] mutableCopy];
            for ( GKAchievement * achievement in achievements )
            {
                if ( achievement.percentComplete == 100.0 )
                    [completedAchievementsForUserDefaults addObject:achievement.identifier];
                
                [AccountManager updateAchievement:achievement inAchievements:achievementsForUserDefaults];
            }
            
            [sharedAccountManager.userDefaults setValue:completedAchievementsForUserDefaults forKey:@"achievementsCompleted"];
            NSData * encodedAchievements = [NSKeyedArchiver archivedDataWithRootObject:achievementsForUserDefaults];
            [sharedAccountManager.userDefaults setValue:encodedAchievements forKey:@"achievements"];
            
            //in case the user logs in using a different device, they will still have their upgrades unlocked
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementSmartPhotons]] )
                [AccountManager unlockUpgrade:kUpgradeSmartPhotons];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementMachineGunFireRate]] )
                [AccountManager unlockUpgrade:kUpgradeMachineGunFireRate];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementShield]] )
                [AccountManager unlockUpgrade:kUpgradeShield];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementBiggerLaser]] )
                [AccountManager unlockUpgrade:kUpgradeBiggerLaser];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementElectricityChain]] )
                [AccountManager unlockUpgrade:kUpgradeElectricityChain];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementEnergyBooster]] )
                [AccountManager unlockUpgrade:kUpgradeEnergyBooster];
            
            //in case the user logs in using a different device, they will still have their weapon slots unlocked
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementTwoWeapons]] )
                [AccountManager unlockUpgrade:kUpgrade2Weapons];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementFourWeapons]] )
                [AccountManager unlockUpgrade:kUpgrade4Weapons];
            
            //in case the user logs in using a different device, they will still have their ships unlocked
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedBabenberg]] )
                [AccountManager unlockShip:[Babenberg new]];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedCaiman]] )
                [AccountManager unlockShip:[Caiman new]];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedDandolo]] )
                [AccountManager unlockShip:[Dandolo new]];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedEdinburgh]] )
                [AccountManager unlockShip:[Edinburgh new]];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedFlandre]] )
                [AccountManager unlockShip:[Flandre new]];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedGascogne]] )
                [AccountManager unlockShip:[Gascogne new]];
            if ( [completedAchievementsForUserDefaults containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedHabsburg]] )
                [AccountManager unlockShip:[Habsburg new]];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"achievementsLoaded" object:nil];
    }];
}

+ (GKAchievement *)savedAchievement:(Achievement)achievement
{
    for ( GKAchievement * achievo in [AccountManager achievements] )
    {
        if ( [achievo.identifier isEqualToString:[EnumTypes identifierFromAchievement:achievement]] )
            return achievo;
    }
    
    return nil;
}

+ (void) submitAchievementsProgress:(NSDictionary *)achievements
{
    NSMutableArray * alreadyCompletedAchievements = [NSMutableArray new];
    NSMutableArray * achievementsToSubmit = [NSMutableArray new];
    for ( NSString * key in [achievements allKeys] )
    {
        Achievement achievement = [key intValue];
        GKAchievement * tmpAchievement = [AccountManager savedAchievement:achievement];
        if ( ! tmpAchievement )
            continue;
        
        if ( tmpAchievement.percentComplete == 100.0 )
            [alreadyCompletedAchievements addObject:tmpAchievement];
        else
            [achievementsToSubmit addObject:tmpAchievement];
        
        int increase = [[achievements valueForKey:key] intValue];
        tmpAchievement.percentComplete = [AccountManager calculatePercentCompleteForAchievement:achievement withIncrease:increase];
    }
    
    NSArray * allAchievements = [alreadyCompletedAchievements arrayByAddingObjectsFromArray:achievementsToSubmit];
    NSData * encodedAchievements = [NSKeyedArchiver archivedDataWithRootObject:allAchievements];
    [sharedAccountManager.userDefaults setValue:encodedAchievements forKey:@"achievements"];
    
    [GKAchievement reportAchievements:achievementsToSubmit withCompletionHandler:^(NSError * _Nullable error)
     {
         if ( error )
             NSLog(@"submitAchievementProgress error : %@", error );
         else
         {
             for ( GKAchievement * achievo in achievementsToSubmit )
             {
                 NSLog(@"submitAchievementProgress reported : %@", achievo.identifier);
                 if ( achievo.percentComplete == 100.0 )
                 {
                     NSLog(@"achievement completed - banner should be displayed : %@", achievo.identifier);
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"achievementCompleted" object:achievo];
                     [Answers logCustomEventWithName:@"Gameplay Achievement" customAttributes:@{@"achievement type" : achievo.identifier}];
                 }
             }
         }
     }];
}

+ (float) calculatePercentCompleteForAchievement:(Achievement)achievement withIncrease:(int)increase
{
    GKAchievement * tmpAchievement = [AccountManager savedAchievement:achievement];
    if ( !tmpAchievement )
    {
        NSLog(@"error - calculatePercentCompleteForAchievement");
        return 0;
    }
    
    float achievementMax = 0;
    
    if ( achievement == kAchievementBulletsFired100 )
        achievementMax = 100;
    else if ( achievement == kAchievementBulletsFired1000 )
        achievementMax = 1000;
    else if ( achievement == kAchievementBulletsFired10000 )
        achievementMax = 10000;
    else if ( achievement == kAchievementBulletsFired100000 )
        achievementMax = 100000;
    
    else if ( achievement == kAchievementPhotonsFired25 )
        achievementMax = 25;
    else if ( achievement == kAchievementPhotonsFired250 )
        achievementMax = 250;
    else if ( achievement == kAchievementPhotonsFired2500 )
        achievementMax = 2500;
    else if ( achievement == kAchievementPhotonsFired25000 )
        achievementMax = 25000;
    
    else if ( achievement == kAchievementLasersFired15 )
        achievementMax = 15;
    else if ( achievement == kAchievementLasersFired150 )
        achievementMax = 150;
    else if ( achievement == kAchievementLasersFired1500 )
        achievementMax = 1500;
    else if ( achievement == kAchievementLasersFired15000 )
        achievementMax = 15000;
    
    else if ( achievement == kAchievementElectricityFired20 )
        achievementMax = 20;
    else if ( achievement == kAchievementElectricityFired200 )
        achievementMax = 200;
    else if ( achievement == kAchievementElectricityFired2000 )
        achievementMax = 2000;
    else if ( achievement == kAchievementElectricityFired20000 )
        achievementMax = 20000;
    
    else if ( achievement == kAchievementEnemiesDestroyed50 )
        achievementMax = 50;
    else if ( achievement == kAchievementEnemiesDestroyed500 )
        achievementMax = 500;
    else if ( achievement == kAchievementEnemiesDestroyed5000 )
        achievementMax = 5000;
    else if ( achievement == kAchievementEnemiesDestroyed50000 )
        achievementMax = 50000;
    
    else if ( achievement == kAchievementPowerUpsCollected3 )
        achievementMax = 3;
    else if ( achievement == kAchievementPowerUpsCollected30 )
        achievementMax = 30;
    else if ( achievement == kAchievementPowerUpsCollected300 )
        achievementMax = 300;
    else if ( achievement == kAchievementPowerUpsCollected3000 )
        achievementMax = 3000;
    
    float currentProgress = (tmpAchievement.percentComplete/100) * achievementMax;
    float updatedProgress = currentProgress + increase;
    float updatedPercent = (updatedProgress / achievementMax) * 100;
    if ( updatedPercent > 100.0 )
        updatedPercent = 100.0;
    
    return updatedPercent;
}

+ (void) submitCompletedAchievement:(Achievement)achievement
{
    //NSLog(@"account manager - submitCompletedAchievement");
    NSString * achievementIdentifier = [EnumTypes identifierFromAchievement:achievement];
    
    if ( ! [[AccountManager achievementsCompleted] containsObject:achievementIdentifier] )
    {
        GKAchievement * tmpAchievement = [[GKAchievement alloc] initWithIdentifier:achievementIdentifier];
        tmpAchievement.showsCompletionBanner = YES;
        tmpAchievement.percentComplete = 100;
        [GKAchievement reportAchievements:@[tmpAchievement] withCompletionHandler:^(NSError * _Nullable error)
        {
            if ( error )
            {
                //NSLog(@"reportAchievements error : %@", error );
            }
            else
            {
                //NSLog(@"achievement reported : %@", tmpAchievement.identifier);
                NSMutableArray * achievements = [[AccountManager achievementsCompleted] mutableCopy];
                [achievements addObject:achievementIdentifier];
                [sharedAccountManager.userDefaults setValue:achievements forKey:@"achievementsCompleted"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"achievementCompleted" object:tmpAchievement];
                NSLog(@"achievement completed - banner should be displayed : %@", tmpAchievement.identifier);
                [sharedAccountManager checkAllUpgradesAchievement];
                [sharedAccountManager checkAllShipsAchievement];
                [sharedAccountManager checkAllAchievementsAchievement];
            }
        }];
    }
    else
    {
        //NSLog(@"achievement already completed : %@", [EnumTypes identifierFromAchievement:achievement]);
    }
}

- (void) checkAllShipsAchievement
{
    NSArray * completedAchievements = [AccountManager achievementsCompleted];
    if ( ![completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedAllShips]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedBabenberg]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedCaiman]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedDandolo]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedEdinburgh]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedFlandre]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedGascogne]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementPurchasedHabsburg]] )
    {
        [AccountManager submitCompletedAchievement:kAchievementPurchasedAllShips];
    }
}

- (void) checkAllUpgradesAchievement
{
    NSArray * completedAchievements = [AccountManager achievementsCompleted];
    if ( ![completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementAllUpgrades]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementTwoWeapons]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementFourWeapons]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementSmartPhotons]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementMachineGunFireRate]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementShield]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementBiggerLaser]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementElectricityChain]] &&
          [completedAchievements containsObject:[EnumTypes identifierFromAchievement:kAchievementEnergyBooster]] )
    {
        [AccountManager submitCompletedAchievement:kAchievementAllUpgrades];
    }
}

- (void) checkAllAchievementsAchievement
{
    NSArray * achievements = [AccountManager achievements];
    
    for ( GKAchievement * achievement in achievements )
    {
        if ( achievement.percentComplete < 100 && ! [achievement.identifier isEqualToString:[EnumTypes identifierFromAchievement:kAchievementAllAchievements]] )
            return;
    }
    
    [AccountManager submitCompletedAchievement:kAchievementAllAchievements];
}

+ (int) bonusPointsForAchievement:(Achievement)achievement
{
    switch (achievement)
    {
        case kAchievementMaxLevelMachineGun:
            return 100;
            
        case kAchievementMaxLevelPhotonCannon:
            return 100;
            
        case kAchievementMaxLevelElectricalGenerator:
            return 100;
            
        case kAchievementMaxLevelLaserCannon:
            return 100;
            
        case kAchievementBulletsFired100:
            return 75;
            
        case kAchievementBulletsFired1000:
            return 250;
            
        case kAchievementBulletsFired10000:
            return 500;
            
        case kAchievementBulletsFired100000:
            return 1000;
            
        case kAchievementPhotonsFired25:
            return 80;
            
        case kAchievementPhotonsFired250:
            return 245;
            
        case kAchievementPhotonsFired2500:
            return 600;
            
        case kAchievementPhotonsFired25000:
            return 1100;
            
        case kAchievementLasersFired15:
            return 70;
            
        case kAchievementLasersFired150:
            return 255;
            
        case kAchievementLasersFired1500:
            return 450;
            
        case kAchievementLasersFired15000:
            return 1250;
            
        case kAchievementElectricityFired20:
            return 65;
            
        case kAchievementElectricityFired200:
            return 230;
            
        case kAchievementElectricityFired2000:
            return 550;
            
        case kAchievementElectricityFired20000:
            return 1300;
            
        case kAchievementEnemiesDestroyed50:
            return 80;
            
        case kAchievementEnemiesDestroyed500:
            return 350;
            
        case kAchievementEnemiesDestroyed5000:
            return 700;
            
        case kAchievementEnemiesDestroyed50000:
            return 2000;
            
        case kAchievementPowerUpsCollected3:
            return 25;
            
        case kAchievementPowerUpsCollected30:
            return 75;
            
        case kAchievementPowerUpsCollected300:
            return 200;
            
        case kAchievementPowerUpsCollected3000:
            return 750;
            
        case kAchievementAllAchievements:
            return 100000;
            
        default:
            return 1;
    }
}

#pragma mark - ads
+ (void) startFullScreenAdTimer
{
    //NSLog(@"account manager - startFullScreenAdTimer");
    sharedAccountManager.fullScreenAdIteration = NO;
    [sharedAccountManager.fullScreenAdTimer invalidate];
    sharedAccountManager.fullScreenAdTimer = [[NSTimer alloc] initWithFireDate:[[NSDate date] dateByAddingTimeInterval:120] interval:0 target:sharedAccountManager selector:@selector(fullScreenAdTimerFired:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:sharedAccountManager.fullScreenAdTimer forMode:NSDefaultRunLoopMode];
}

- (void) fullScreenAdTimerFired:(NSTimer *)timer
{
    //NSLog(@"account manager - fullScreenAdTimerFired");
    self.fullScreenAdIteration = YES;
}

+ (BOOL) shouldShowFullscreenAd
{
    //NSLog(@"account manager - shouldShowFullscreenAd");
    
    if ( sharedAccountManager.firstGameplaySinceLaunch )
        return NO;
    
    return sharedAccountManager.fullScreenAdIteration;
}

+ (int) numberOfTimesPlayed
{
    //NSLog(@"account manager - numberOfTimesPlayed");
    int numberOfTimesPlayed = (int)[sharedAccountManager.userDefaults integerForKey:@"numberOfTimesPlayed"];
    if ( ! numberOfTimesPlayed )
    {
        numberOfTimesPlayed = 0;
        [sharedAccountManager.userDefaults setInteger:numberOfTimesPlayed forKey:@"numberOfTimesPlayed"];
    }
    
    return numberOfTimesPlayed;
}

+ (void) incrementNumberOfTimesPlayed
{
    //NSLog(@"account manager - incrementNumberOfTimesPlayed");
    int numberOfTimesPlayed = [AccountManager numberOfTimesPlayed];
    numberOfTimesPlayed++;
    [sharedAccountManager.userDefaults setInteger:numberOfTimesPlayed forKey:@"numberOfTimesPlayed"];
}

#pragma mark - settings
#pragma mark sound volume
+ (float) musicVolume
{
    //NSLog(@"account manager - musicVolume");
    NSNumber * musicVolume = [sharedAccountManager.userDefaults valueForKey:@"musicVolume"];
    
    if ( !musicVolume )
    {
        musicVolume = [NSNumber numberWithFloat:.5];
        [AccountManager setMusicVolume:[musicVolume floatValue]];
    }
    
    return [musicVolume floatValue];
}

+ (float) soundEffectsVolume
{
    //NSLog(@"account manager - soundEffectsVolume");
    NSNumber * soundEffectsVolume = [sharedAccountManager.userDefaults valueForKey:@"soundEffectsVolume"];
    
    if ( !soundEffectsVolume )
    {
        soundEffectsVolume = [NSNumber numberWithFloat:.5];
        [AccountManager setSoundEffectsVolume:[soundEffectsVolume floatValue]];
    }
    
    return [soundEffectsVolume floatValue];
}

+ (void) setMusicVolume:(float)volume
{
    //NSLog(@"account manager - setMusicVolume");
    [sharedAccountManager.userDefaults setFloat:volume forKey:@"musicVolume"];
}

+ (void) setSoundEffectsVolume:(float)volume
{
    //NSLog(@"account manager - setSoundEffectsVolume");
    [sharedAccountManager.userDefaults setFloat:volume forKey:@"soundEffectsVolume"];
}

#pragma mark vibrate
+ (BOOL) isVibrateOn
{
    BOOL vibrate = [sharedAccountManager.userDefaults boolForKey:@"vibrate"];
    NSNumber * vibrateExistsValue = [sharedAccountManager.userDefaults valueForKey:@"vibrate"];
    //vibrateExistsValue is used becuase i cant check if a BOOL is null
    if ( !vibrateExistsValue )
    {
        vibrate = YES;
        [AccountManager setVibrate:vibrate];
    }
    return vibrate;
}

+ (void) setVibrate:(BOOL)vibrate
{
    [sharedAccountManager.userDefaults setBool:vibrate forKey:@"vibrate"];
}

@end
