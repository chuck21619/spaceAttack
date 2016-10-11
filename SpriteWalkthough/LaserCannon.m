//
//  LaserCannon.m
//  SpriteWalkthough
//
//  Created by chuck on 4/29/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "LaserCannon.h"
#import "AccountManager.h"
#import "UpgradesViewController.h"
#import "AudioManager.h"
#import "SpaceshipScene.h"

@implementation LaserCannon
{
    float _waitDuration;
    float _waitRange;
}

- (id)init
{
    if (self = [super initWithTexture:[[[PlayerWeaponsKit sharedInstance] weaponTextures] objectForKey:NSStringFromClass([self class])]])
    {
        self.weaponType = kPowerUpTypeLaserCannon;
        self.name = @"laserCannon";
        self.laserFrames = [[PlayerWeaponsKit sharedInstance] currentLaserFrames];
        [self startFiring];
	}
    return self;
}

- (void) startFiring
{
    [self stopFiring];
    _waitDuration = 4.0;
    _waitRange = 2.0;
    
    if ( self.level == 1 )
    {
        _waitDuration = 4.0;
        _waitRange = 1.0;
    }
    else if ( self.level == 2 )
    {
        _waitDuration = 3.0;
        _waitRange = .5;
    }
    else if ( self.level == 3 )
    {
        _waitDuration = 2.0;
        _waitRange = .25;
    }
    else //if ( self.level == 4 )
    {
        _waitDuration = 1.0;
        _waitRange = .125;
    }
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    [self runAction:performSelector withKey:@"firing"];
}

- (UIColor *) rampUpColor
{
    return [UIColor colorWithRed:.85 green:.2 blue:.1 alpha:.5];
}

- (void) fire
{
    Laser * tmpLaser = [[Laser alloc] initWithAtlas:self.laserFrames];
    tmpLaser.position = CGPointMake(0, self.size.height/2);
    tmpLaser.zPosition = self.zPosition;
    tmpLaser.delegate = (SpaceshipScene *)[self scene];
    [self addChild:tmpLaser];
    [self.delegate didAddProjectile:tmpLaser forWeapon:self];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectLaser];
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    double currentWaitDuration = ((double)arc4random() / 0x100000000) * ((_waitDuration+_waitRange) - (_waitDuration-_waitRange)) + (_waitDuration-_waitRange);
    [self rampUpWithDuration:currentWaitDuration];
    SKAction * myAction = [SKAction waitForDuration:currentWaitDuration];
    SKAction * myCompletion = [SKAction runBlock:^
    {
        [self runAction:performSelector withKey:@"firing"];
    }];
    SKAction * mySequence = [SKAction sequence:@[myAction, myCompletion]];
    [self runAction:mySequence withKey:@"firing"];
}

- (void) removeFromParent
{
    //this is to deal with the cached lasers in the spaceshipscene
    for ( SKSpriteNode * node in [self children] )
    {
        [node removeFromParent];
    }
    
    [super removeFromParent];
}

@end
