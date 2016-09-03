//
//  EnemyBig.m
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "EnemyBig.h"
#import "CategoryBitMasks.h"
#import "AudioManager.h"

@implementation EnemyBig

- (id)initWithTexture:(SKTexture *)texture
{
    if ( self = [super initWithTexture:texture] )
    {
        self.name = @"enemyBig";
        self.pointValue = 8;
        self.armor = 350;
        self.zPosition = -2;
        
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.7;
        
        self.size = CGSizeMake(texture.size.width*resizeFactor, texture.size.height*resizeFactor);
    
        float physicsBodyRadius = (self.size.width*.8)/2;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius];
        //[self attachDebugCircleWithSize:physicsBodyRadius*2];
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks enemyCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask =  [CategoryBitMasks shipCategory] | [CategoryBitMasks shieldCategory] | [CategoryBitMasks missileCategory];
	}
    return self;
}

- (void) explode
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectExplosionEnemyBig];
    [super explode];
}

- (void)attachDebugCircleWithSize:(int)s
{
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-s/2, -s/2, s, s), nil);
    [self attachDebugFrameFromPath:bodyPath];
}

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:1 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

@end
