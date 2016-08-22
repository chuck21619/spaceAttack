//
//  EnemyBasic.m
//  SpriteWalkthough
//
//  Created by chuck on 6/16/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "EnemyBasic.h"
#import "CategoryBitMasks.h"
#import "AudioManager.h"

@implementation EnemyBasic

- (instancetype) initWithTexture:(SKTexture *)texture
{
    if ( self = [super initWithTexture:texture] )
    {
        self.name = @"enemyBasic";
        self.pointValue = 2;
        self.armor = 100;
        
        self.size = CGSizeMake(texture.size.width/4, texture.size.height/4);
        
        //draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path, NULL, 1 - offsetX, 5 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 11 - offsetX, 24 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 31 - offsetX, 24 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 39 - offsetX, 7 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 21 - offsetX, 0 - offsetY);
        CGPathMoveToPoint(path, NULL, 20 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 19 - offsetY);
        CGPathAddLineToPoint(path, NULL, 5 - offsetX, 34 - offsetY);
        CGPathAddLineToPoint(path, NULL, 34 - offsetX, 34 - offsetY);
        CGPathAddLineToPoint(path, NULL, 39 - offsetX, 18 - offsetY);
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
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectExplosionEnemyBasic];
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
