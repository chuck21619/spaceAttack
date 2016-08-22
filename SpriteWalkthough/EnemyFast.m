//
//  EnemyFast.m
//  SpriteWalkthough
//
//  Created by chuck on 7/14/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "EnemyFast.h"
#import "CategoryBitMasks.h"
#import "AudioManager.h"

@implementation EnemyFast

- (instancetype) initWithTexture:(SKTexture *)texture
{
    if ( self = [super initWithTexture:texture] )
    {
        self.name = @"enemyFast";
        self.pointValue = 3;
        self.armor = 50;
        
        self.size = CGSizeMake(texture.size.width/4, texture.size.height/4);
        
        //draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path, NULL, 8 - offsetX, 2 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 13 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 16 - offsetX, 25 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 31 - offsetX, 14 - offsetY);
//        CGPathAddLineToPoint(path, NULL, 24 - offsetX, 3 - offsetY);
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, NULL, 15 - offsetX, 25 - offsetY);
        CGPathAddLineToPoint(path, NULL, 28 - offsetX, 4 - offsetY);

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
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectExplosionEnemyFast];
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
