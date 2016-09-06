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
        
        [self setTexture:[SKTexture textureWithImageNamed:@"shield.png"]];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.3;
        int shieldSize = self.texture.size.width*resizeFactor;
        [self setSize:CGSizeMake(shieldSize, shieldSize)];
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(shieldSize*.95)/2];
        //[self attachDebugCircleWithSize:(shieldSize*.95)];
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks shieldCategory];
        self.physicsBody.collisionBitMask = [CategoryBitMasks shieldCategory] | [CategoryBitMasks asteroidCategory];
        self.physicsBody.contactTestBitMask = [CategoryBitMasks shieldCategory] | [CategoryBitMasks asteroidCategory] | [CategoryBitMasks missileCategory];
        self.physicsBody.dynamic = NO;
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

- (void)attachDebugCircleWithSize:(int)s
{
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-s/2, -s/2, s, s), nil);
    [self attachDebugFrameFromPath:bodyPath];
}

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.zPosition = 100;
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:1 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

@end
