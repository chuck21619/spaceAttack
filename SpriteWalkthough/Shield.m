//
//  Shield.m
//  SpaceAttack
//
//  Created by charles johnston on 4/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "Shield.h"
#import "CategoryBitMasks.h"
#import "SpaceObjectsKit.h"
#import "AudioManager.h"

@implementation Shield

- (id)init
{
    if (self = [super init])
    {
        self.name = @"shield";
        self.zPosition = 3;
        self.armor = 3;
        
//        self.shield1Frames = [[SpaceObjectsKit sharedInstanceWithScene:nil] shield1Frames];
//        self.shield2Frames = [[SpaceObjectsKit sharedInstanceWithScene:nil] shield2Frames];
//        self.shield3Frames = [[SpaceObjectsKit sharedInstanceWithScene:nil] shield3Frames];
        
        //[self setTexture:[self.shield1Frames firstObject]];
        [self setTexture:[SKTexture textureWithImageNamed:@"shield.png"]];
        [self setSize:CGSizeMake(self.texture.size.width/2, self.texture.size.height/2)];
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.texture.size.width/3];
        self.physicsBody.categoryBitMask = [CategoryBitMasks shieldCategory];
        self.physicsBody.collisionBitMask = [CategoryBitMasks shieldCategory] | [CategoryBitMasks asteroidCategory];
        self.physicsBody.contactTestBitMask = [CategoryBitMasks shieldCategory] | [CategoryBitMasks asteroidCategory] | [CategoryBitMasks missileCategory];
        self.physicsBody.dynamic = NO;
        
//        NSString * photonParticlePath = [[NSBundle mainBundle] pathForResource:@"ShieldParticle" ofType:@"sks"];
//        SKEmitterNode * particleness = [NSKeyedUnarchiver unarchiveObjectWithFile:photonParticlePath];
//        particleness.name = @"photonParticle";
//        [self addChild:particleness];
        
        //[self animate];
    }
    return self;
}

- (void) takeDamage
{
    [self.delegate shieldTookDamage:self];
    
    self.armor--;
    
    if ( self.armor < 1 )
        [self destroy];
    else
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectShieldDamage];
        //[self animate];
    }
}

- (void) destroy
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectShieldDestroy];
    
    [self.delegate shieldDestroyed:self];
    
    NSString * shieldDestroyPath = [[NSBundle mainBundle] pathForResource:@"ShieldDestroy" ofType:@"sks"];
    SKEmitterNode * shieldDestroy = [NSKeyedUnarchiver unarchiveObjectWithFile:shieldDestroyPath];
    shieldDestroy.name = @"shieldDestroy";
    shieldDestroy.position = self.parent.position;
    [shieldDestroy performSelector:@selector(removeFromParent) withObject:shieldDestroy afterDelay:3];
    [[self scene] addChild:shieldDestroy];
    
    [self runAction:[SKAction fadeAlphaTo:0 duration:.2] completion:^
    {
        [self removeFromParent];
        [self removeAllActions];
    }];
}

//- (void) animate
//{
//    NSArray * atlas;
//    if ( self.armor == 1 )
//        atlas = self.shield3Frames;
//    else if ( self.armor == 2 )
//        atlas = self.shield2Frames;
//    else
//        atlas = self.shield1Frames;
//    
//    [self removeActionForKey:@"animation"];
//    SKAction * animateFrames = [SKAction repeatActionForever:[SKAction animateWithTextures:atlas timePerFrame:0.05]];
//    [self runAction:animateFrames withKey:@"animation"];
//}

@end
