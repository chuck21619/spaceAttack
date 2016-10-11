//
//  PlayerWeapon.m
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerWeapon.h"
#import "PlayerWeaponsKit.h"
#import "AccountManager.h"

@implementation PlayerWeapon
{
    SKSpriteNode * _rampUpSprite;
}

- (id) initWithTexture:(SKTexture *)texture
{
    if (self = [super initWithTexture:texture])
    {
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*1;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        self.level = 1;
        self.zPosition = -1;
        
        _rampUpSprite = [[SKSpriteNode alloc] initWithImageNamed:@"spark.png"];
        _rampUpSprite.alpha = 0;
        _rampUpSprite.position = CGPointMake(0, 0);
        [_rampUpSprite runAction:[SKAction colorizeWithColor:[self rampUpColor] colorBlendFactor:1 duration:0]];
        _rampUpSprite.size = CGSizeMake((_rampUpSprite.size.width/3) * resizeFactor, (_rampUpSprite.size.height/3) * resizeFactor);
        [self addChild:_rampUpSprite];
    }
    
    return self;
}

- (void) upgrade
{
    self.level++;
    [self startFiring];
    if ( self.level == 4 )
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

- (void) rampUpWithDuration:(float)duration
{
    [_rampUpSprite runAction:[SKAction fadeInWithDuration:duration] completion:^
    {
        _rampUpSprite.alpha = 0;
    }];
}

- (UIColor *) rampUpColor
{
    return [UIColor whiteColor];
}

- (void) startFiring
{
    NSAssert(NO, @"Subclasses need to overwrite startFiring method");
}

- (void) stopFiring
{
    [self removeActionForKey:@"firing"];
    _rampUpSprite.alpha = 0;
}

@end
