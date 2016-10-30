//
//  Enemy.m
//  SpriteWalkthough
//
//  Created by chuck on 6/12/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Enemy.h"
#import "AudioManager.h"
#import "EnemyKit.h"

@implementation Enemy

@synthesize delegate = delegate; // interited from SASpriteNode

- (instancetype) initWithTexture:(SKTexture *)texture
{
    if ( self = [super initWithTexture:texture] )
    {
        self.photonsTargetingMe = [NSPointerArray weakObjectsPointerArray];
        self.isBeingElectrocuted = NO;
        self.explosionFrames = [[EnemyKit sharedInstanceWithScene:nil] explosionFrames];
        self.pulseRed = [SKAction sequence:@[[SKAction fadeAlphaTo:.5 duration:.14],
                                             [SKAction waitForDuration:0.15],
                                             [SKAction fadeAlphaTo:1 duration:.14]]];
    }
    return self;
}

- (void) explode
{
    EnemyExplosion * explosion = [[EnemyExplosion alloc] initWithAtlas:self.explosionFrames size:self.size.width*2];
    explosion.position = self.position;
    [[self scene] addChild:explosion];
    [explosion performSelector:@selector(removeFromParent) withObject:explosion afterDelay:1];
    
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
