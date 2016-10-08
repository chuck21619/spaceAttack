//
//  AccountManager.h
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpaceshipKit.h"
#import "EnumTypes.h"
#import "GKAchievementHandler.h"
@import StoreKit;

@interface AccountManager : NSObject <SKPaymentTransactionObserver>

+ (AccountManager *) sharedInstance;
@property (nonatomic) NSUserDefaults * userDefaults;
@property (nonatomic) BOOL fullScreenAdIteration;
@property (nonatomic) NSTimer * fullScreenAdTimer;// = [[NSTimer alloc] initWithFireDate:[currentDate dateByAddingTimeInterval:30] interval:0 target:self selector:@selector(endEnergyBooster:) userInfo:nil repeats:NO];
@property (nonatomic) BOOL firstGameplaySinceLaunch;
@property (nonatomic) NSArray * upgrades;
@property (nonatomic) NSArray * spaceships;
@property (nonatomic) BOOL touchControls;
+ (BOOL) firstLaunch;

#pragma mark ships
+ (Spaceship *) lastSelectedShip;
+ (void) setLastSelectedShip:(Spaceship *)spaceship;
+ (NSArray *) unlockedShips;
+ (BOOL) shipIsUnlocked:(Spaceship *)spaceship;
+ (void) unlockShip:(Spaceship *)spaceship;
+ (BOOL) enoughGamePointsToUnlockAShip;

#pragma mark upgrades
+ (void) unlockUpgrade:(UpgradeType)upgrade;
+ (int) numberOfWeaponSlotsUnlocked;
+ (void) setNumberOfWeaponSlots:(int)numberOfWeaponSlots;
+ (BOOL) smartPhotonsUnlocked;
+ (BOOL) machineGunFireRateUpgraded;
+ (BOOL) shieldUnlocked;
+ (BOOL) laserUpgraded;
+ (BOOL) electricityChainUnlocked;
+ (BOOL) energyBoosterUnlocked;
+ (BOOL) enoughGamePointsToUnlockAnUpgrade;

#pragma mark points
+ (int) availablePoints;
+ (void) addPoints:(int)points;
+ (void) subtractPoints:(int)points;

#pragma mark tooltips
+ (BOOL) shouldShowTooltip:(TooltipType)tooltipType;
+ (void) disableTips;
+ (void) resetTooltips;

#pragma mark ads
+ (void) startFullScreenAdTimer;
+ (BOOL) shouldShowFullscreenAd;

#pragma mark metrics
+ (int) numberOfTimesPlayed;
+ (void) incrementNumberOfTimesPlayed;

#pragma mark - game center
+ (NSString *) lastPlayerLoggedIn;
+ (void) setLastPlayerLoggedIn:(NSString *)player;
+ (void) clearPlayerProgress;

#pragma mark achievements
@property (nonatomic) NSArray * cachedAchievements;
+ (NSArray *) achievements;
+ (NSArray *) achievementsCompleted;
+ (void) loadAchievements;
+ (void) submitAchievementsProgress:(NSDictionary *)achievements;
+ (void) submitCompletedAchievement:(Achievement)achievement;
+ (int) bonusPointsForAchievement:(Achievement)achievement;
+ (void) showCompletionBannerForAchievement:(GKAchievement *)achievement;

#pragma mark - settings
#pragma mark sound volume
+ (float) musicVolume;
+ (float) soundEffectsVolume;
+ (void) setMusicVolume:(float)volume;
+ (void) setSoundEffectsVolume:(float)volume;

#pragma mark vibrate
+ (BOOL) isVibrateOn;
+ (void) setVibrate:(BOOL)vibrate;

@end
