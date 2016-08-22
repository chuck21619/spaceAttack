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

- (id)init
{
    if (self = [super initWithTexture:[[[PlayerWeaponsKit sharedInstance] weaponTextures] objectForKey:NSStringFromClass([self class])]])
    {
        self.weaponType = kPowerUpTypeLaserCannon;
        self.name = @"laserCannon";
        self.laserFrames = [[PlayerWeaponsKit sharedInstance] laserFrames];
        [self startFiring];
	}
    return self;
}

- (void) startFiring
{
    [self stopFiring];
    float waitDuration = 4.0;
    float waitRange = 2.0;
    
    if ( self.level == 1 )
    {
        waitDuration = 4.0;
        waitRange = 1.0;
    }
    else if ( self.level == 2 )
    {
        waitDuration = 2.0;
        waitRange = .5;
    }
    else if ( self.level == 3 )
    {
        waitDuration = 2.0;
        waitRange = .25;
    }
    else //if ( self.level == 4 )
    {
        waitDuration = 1.0;
        waitRange = .125;
    }
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    SKAction * fireSequence = [SKAction sequence:@[performSelector, [SKAction waitForDuration:waitDuration withRange:waitRange]]];
    SKAction * fireForever = [SKAction repeatActionForever:fireSequence];
    [self runAction:fireForever withKey:@"firing"];
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
