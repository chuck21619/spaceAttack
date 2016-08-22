//
//  PhotonCannon.m
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PhotonCannon.h"
#import "Spaceship.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SpaceshipScene.h"

@implementation PhotonCannon


- (id)init
{
    if (self = [super initWithTexture:[[[PlayerWeaponsKit sharedInstance] weaponTextures] objectForKey:NSStringFromClass([self class])]])
    {
        self.weaponType = kPowerUpTypePhotonCannon;
        self.name = @"photonCannon";
        self.smartPhotons = [AccountManager smartPhotonsUnlocked];
        self.projectileTexture = [[PlayerWeaponsKit sharedInstance] photonTexture];
        
        [self startFiring];
	}
    return self;
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (void) startFiring
{
    [self stopFiring];
    SKAction * wait = [SKAction waitForDuration:-1];
    
    if ( self.level == 1 )
        wait = [SKAction waitForDuration:3];
    else if ( self.level == 2 )
        wait = [SKAction waitForDuration:1.75];
    else if ( self.level == 3 )
        wait = [SKAction waitForDuration:1];
    else //if ( self.level == 4 )
        wait = [SKAction waitForDuration:.5];
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    SKAction * fireSequence = [SKAction sequence:@[performSelector, wait]];
    SKAction * fireForever = [SKAction repeatActionForever:fireSequence];
    [self runAction:fireForever withKey:@"firing"];
}

- (void) fire
{
    Photon * tmpPhoton = [[Photon alloc] initWithTexture:self.projectileTexture];
    tmpPhoton.isSmart = self.smartPhotons;
    if ( tmpPhoton.isSmart )
        tmpPhoton.physicsBody.linearDamping = .5;
    tmpPhoton.position = [[self scene] convertPoint:self.position fromNode:self.parent];
    tmpPhoton.zPosition = self.zPosition;
    
    tmpPhoton.zRotation = self.parent.zRotation;
    CGFloat radianFactor = 0.0174532925;
    CGFloat rotationInDegrees = tmpPhoton.zRotation / radianFactor;
    CGFloat newRotationDegrees = rotationInDegrees + 90;
    CGFloat newRotationRadians = newRotationDegrees * radianFactor;
    CGFloat r = tmpPhoton.maxVelocity;
    CGFloat dx = r * cos(newRotationRadians);
    CGFloat dy = r * sin(newRotationRadians);
    [tmpPhoton.physicsBody setVelocity:CGVectorMake(dx, dy)];
    
    tmpPhoton.delegate = (SpaceshipScene *)[self scene];
    [[self scene] addChild:tmpPhoton];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectPhoton];
}

@end
