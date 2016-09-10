//
//  Enemy.m
//  SpriteWalkthough
//
//  Created by chuck on 6/12/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Enemy.h"
#import "AudioManager.h"

@implementation Enemy

@synthesize delegate = delegate; // interited from SASpriteNode

- (instancetype) initWithTexture:(SKTexture *)texture
{
    if ( self = [super initWithTexture:texture] )
    {
        self.photonsTargetingMe = [NSPointerArray weakObjectsPointerArray];
        self.isBeingElectrocuted = NO;
        self.pulseRed = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor whiteColor] colorBlendFactor:1.0 duration:0.14],
                                                   [SKAction waitForDuration:0.15],
                                                   [SKAction colorizeWithColorBlendFactor:0.0 duration:0.14]]];
    }
    return self;
}

- (void) explode
{
    NSString * explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
    SKEmitterNode * explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.name = @"explosion";
    explosion.position = self.position;
    
    [[self scene] addChild:explosion];
    [explosion performSelector:@selector(removeFromParent) withObject:explosion afterDelay:3]; //i dont remember why i did this
    [self removeFromParent];
    [self removeAllActions];
    [self.delegate enemyExploded:self];
}

- (void) takeDamage:(int)damage
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEnemyDamage];
    self.armor -= damage;
    
    if ( self.armor <= 0 )
        [self explode];
    else
    {
        [self removeActionForKey:@"pulseRed"];
        [self runAction:self.pulseRed withKey:@"pulseRed"];
    }
}

@end
