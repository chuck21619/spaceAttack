//
//  PlayerWeapon.m
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerWeapon.h"
#import "PlayerWeaponsKit.h"
#import "UpgradeScene.h"
#import "AccountManager.h"

@implementation PlayerWeapon

- (id) initWithTexture:(SKTexture *)texture
{
    if (self = [super initWithTexture:texture])
    {
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*1;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        self.level = 1;
        self.zPosition = -1;
    }
    
    return self;
}

- (void) upgrade
{
    self.level++;
    [self startFiring];
    if ( self.level == 4 && [[self scene] class] != [UpgradeScene class] )
    {
        if ( [self class] == [MachineGun class])
            [AccountManager submitCompletedAchievement:kAchievementMaxLevelMachineGun];
        else if ( [self class] == [PhotonCannon class] )
            [AccountManager submitCompletedAchievement:kAchievementMaxLevelPhotonCannon];
        else if ( [self class] == [LaserCannon class] )
            [AccountManager submitCompletedAchievement:kAchievementMaxLevelLaserCannon];
        else if ( [self class] == [ElectricalGenerator class] )
            [AccountManager submitCompletedAchievement:kAchievementMaxLevelElectricalGenerator];
    }
}

- (void) startFiring
{
    NSAssert(NO, @"Subclasses need to overwrite startFiring method");
}

- (void) stopFiring
{
    [self removeActionForKey:@"firing"];
}

@end
