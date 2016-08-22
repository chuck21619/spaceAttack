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
        
        self.size = CGSizeMake(texture.size.width/2, texture.size.height/2);
        
        //draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path, NULL, 1 - offsetX, 13 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 21 - offsetX, 42 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 57 - offsetX, 42 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 79 - offsetX, 12 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 61 - offsetX, 0 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 19 - offsetX, 0 - offsetY);
        CGPathMoveToPoint(path, NULL, 41 - offsetX, 3 - offsetY);
        CGPathAddLineToPoint(path, NULL, 3 - offsetX, 71 - offsetY);
        CGPathAddLineToPoint(path, NULL, 35 - offsetX, 108 - offsetY);
        CGPathAddLineToPoint(path, NULL, 63 - offsetX, 108 - offsetY);
        CGPathAddLineToPoint(path, NULL, 96 - offsetX, 71 - offsetY);
        CGPathAddLineToPoint(path, NULL, 60 - offsetX, 3 - offsetY);
        CGPathCloseSubpath(path);
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        //[self attachDebugFrameFromPath:path];
        
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

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

@end
