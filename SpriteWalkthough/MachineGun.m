//
//  MachineGun.m
//  SpriteWalkthough
//
//  Created by chuck on 4/28/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "MachineGun.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SpaceshipScene.h"

@implementation MachineGun

- (id)init
{
    if (self = [super initWithTexture:[[[PlayerWeaponsKit sharedInstance] weaponTextures] objectForKey:NSStringFromClass([self class])]])
    {
        self.weaponType = kPowerUpTypeMachineGun;
        self.name = @"machineGun";
        //self.zPosition = -1;
        //self.position = CGPointMake(0, 60);
        self.fireRateUpgraded = [AccountManager machineGunFireRateUpgraded];
        self.projectileTexture = [[PlayerWeaponsKit sharedInstance] bulletTexture];
        
        [self startFiring];
	}
    return self;
}

- (void) upgrade
{
    [super upgrade];
    [[AudioManager sharedInstance] machineGunLevelChanged:self];
}

- (void) startFiring
{
    [self stopFiring];
    SKAction * wait;// = [SKAction waitForDuration:-1];
    
    float waitDuration = -1;
    if ( self.level == 1 )
        waitDuration = .86;
    else if ( self.level == 2 )
        waitDuration = .57;
    else if ( self.level == 3 )
        waitDuration = .285; // .2
    else //if ( self.level == 4 )
        waitDuration = .14; // .098
    
    float upgradeFactor = 1;
    if ( self.fireRateUpgraded )
        upgradeFactor = .7;
    
    wait = [SKAction waitForDuration:waitDuration*upgradeFactor];
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    SKAction * fireSequence = [SKAction sequence:@[performSelector, wait]];
    SKAction * fireForever = [SKAction repeatActionForever:fireSequence];
    [self runAction:fireForever withKey:@"firing"];
}

- (void) fire
{
    Bullet * tmpBullet = [[Bullet alloc] initWithTexture:self.projectileTexture];
    tmpBullet.position = [[self scene] convertPoint:self.position fromNode:self.parent];
    tmpBullet.zPosition = self.zPosition;
    
    float rotation;
    if ( self.level == 1 )
        rotation = skRand(-.04, .04);
    else if ( self.level == 2 )
        rotation = skRand(-.06, .06);
    else if ( self.level == 3 )
        rotation = skRand(-.08, .08);
    else //if ( self.level == 4 )
        rotation = skRand(-.1, .1);
    tmpBullet.zRotation = rotation;
    
    tmpBullet.delegate = (SpaceshipScene *)[self scene];
    [[self scene] addChild:tmpBullet];
    
    CGFloat radianFactor = 0.0174532925;
    CGFloat rotationInDegrees = tmpBullet.zRotation / radianFactor;
    CGFloat newRotationDegrees = rotationInDegrees + 90;
    CGFloat newRotationRadians = newRotationDegrees * radianFactor;
    
    CGFloat r = 10;
    CGFloat dx = r * cos(newRotationRadians);
    CGFloat dy = r * sin(newRotationRadians);
    [tmpBullet.physicsBody applyImpulse:CGVectorMake(dx, dy)];
    
    if ( self.level == 1 || self.level == 2 )
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectBullet];
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

- (void) dealloc
{
    [[AudioManager sharedInstance] removeMachineGun:self];
}

@end
