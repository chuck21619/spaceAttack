//
//  ElectricalGenerator.m
//  SpriteWalkthough
//
//  Created by chuck on 6/7/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "ElectricalGenerator.h"
#import "AccountManager.h"
#import "Asteroid.h"
#import "EnemyKit.h"
#import "AudioManager.h"
#import "SpaceshipScene.h"

@implementation ElectricalGenerator

- (id)init
{
    if (self = [super initWithTexture:[[[PlayerWeaponsKit sharedInstance] weaponTextures] objectForKey:NSStringFromClass([self class])]])
    {
        self.weaponType = kPowerUpTypeElectricalGenerator;
        self.name = @"electricalGenerator";
        self.electricityChainUnlocked = [AccountManager electricityChainUnlocked];
        
        self.electricityFrames = [[PlayerWeaponsKit sharedInstance] electricityFrames];
        
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
    float waitDuration = 4.0;
    float waitRange = 2.0;
    
    if ( self.level == 1 )
    {
        waitDuration = 4.0;
        waitRange = 2.0;
        self.electricityDamageFrequency = .12;
    }
    else if ( self.level == 2 )
    {
        waitDuration = 3.0;
        waitRange = 1.5;
        self.electricityDamageFrequency = .12;
    }
    else if ( self.level == 3 )
    {
        waitDuration = 2.0;
        waitRange = 1.0;
        self.electricityDamageFrequency = .12;
    }
    else //if ( self.level == 4 )
    {
        waitDuration = 1.0;
        waitRange = .5;
        self.electricityDamageFrequency = .12;
    }
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    SKAction * fireSequence = [SKAction sequence:@[performSelector, [SKAction waitForDuration:waitDuration withRange:waitRange]]];
    SKAction * fireForever = [SKAction repeatActionForever:fireSequence];
    [self runAction:fireForever withKey:@"firing"];
}


- (void) fire
{
    Electricity * tmpElectricity = [[Electricity alloc] initWithDamageFrequency:self.electricityDamageFrequency];
    tmpElectricity.delegate = (SpaceshipScene *)[self scene];
    tmpElectricity.position = CGPointMake(0, 0);
    tmpElectricity.zPosition = self.zPosition;
    
    SKCropNode * cropNode = [SKCropNode node];
    cropNode.name = @"electricityCropNode";
    [cropNode addChild:tmpElectricity];
    tmpElectricity.myCropNode = cropNode;
    [self addChild:cropNode];
    [self.delegate didAddProjectile:tmpElectricity forWeapon:self];
    
    [self shuffleElectricityFrames];
    [tmpElectricity update:0];
    
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectElectricity];
    [tmpElectricity runAction:[SKAction animateWithTextures:self.electricityFrames timePerFrame:0.05 resize:NO restore:YES] completion:^
    {
        if ( [tmpElectricity.target class] == [Asteroid class] )
            [(Asteroid *)tmpElectricity.target setIsBeingElectrocuted:NO];
        else if ( [tmpElectricity.target isKindOfClass:[Enemy class]] )
            [(Enemy *)tmpElectricity.target setIsBeingElectrocuted:NO];
        
        [tmpElectricity.delegate SASpriteNodeRemovingFromParent:tmpElectricity];
        [cropNode removeFromParent];
    }];
    
    if ( self.electricityChainUnlocked )
    {
        //chain electricity
        Electricity * chainElectricity = [[Electricity alloc] initWithDamageFrequency:self.electricityDamageFrequency];
        chainElectricity.delegate = (SpaceshipScene *)[self scene];
        chainElectricity.position = CGPointMake(0, 0);
        chainElectricity.zPosition = self.zPosition;
        
        SKCropNode * chainCropNode = [SKCropNode node];
        chainCropNode.name = @"chainElectricityCropNode";
        [chainCropNode addChild:chainElectricity];
        chainElectricity.myCropNode = chainCropNode;
        [self addChild:chainCropNode];
        [self.delegate didAddProjectile:chainElectricity forWeapon:self];
        
        [chainElectricity update:0];
        
        [chainElectricity runAction:[SKAction animateWithTextures:self.electricityFrames timePerFrame:0.05 resize:NO restore:YES] completion:^
        {
            if ( [tmpElectricity.target class] == [Asteroid class] )
                [(Asteroid *)tmpElectricity.target setIsBeingElectrocuted:NO];
            else if ( [tmpElectricity.target isKindOfClass:[Enemy class]] )
                [(Enemy *)tmpElectricity.target setIsBeingElectrocuted:NO];
            
            [chainElectricity.delegate SASpriteNodeRemovingFromParent:chainElectricity];
            [chainCropNode removeFromParent];
        }];
    }
}

- (void) firstElectricityTargetUpdate:(SKNode *)target
{
    if ( target == nil )
        return;
    
    SKCropNode * chainCropNode = (SKCropNode *)[self childNodeWithName:@"chainElectricityCropNode"];
    if ( !chainCropNode )
        return;
    
    chainCropNode.position = [self convertPoint:target.position fromNode:target.parent];
}

- (void) shuffleElectricityFrames
{
    for (int i = 0; i < [self.electricityFrames count]; i++)
    {
        int randInt = (arc4random() % ([self.electricityFrames count] - i)) + i;
        [self.electricityFrames exchangeObjectAtIndex:i withObjectAtIndex:randInt];
    }
}

- (void) removeFromParent
{
    //this is to deal with the cached electricity in the spaceshipscene
    for ( SKSpriteNode * node in [self children] )
    {
        for ( SKSpriteNode * node1 in [node children] )
        {
            [node1 removeFromParent];
        }
        [node removeFromParent];
    }
    
    [super removeFromParent];
}

@end
