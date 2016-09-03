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
        
        
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.25;
        
        self.size = CGSizeMake(texture.size.width*resizeFactor, texture.size.height*resizeFactor);
        
        //draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (62*resizeFactor) - offsetX, (100*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (108*resizeFactor) - offsetX, (60*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (142*resizeFactor) - offsetX, (61*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (187*resizeFactor) - offsetX, (101*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (150*resizeFactor) - offsetX, (180*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (99*resizeFactor) - offsetX, (177*resizeFactor) - offsetY);

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
    shape.lineWidth = 2.0;
    [self addChild:shape];
}

@end
