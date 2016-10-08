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
        
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.25;
        
        self.size = CGSizeMake(texture.size.width*resizeFactor, texture.size.height*resizeFactor);
        
        //draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        
        CGPathMoveToPoint(path, NULL, (19*resizeFactor) - offsetX, (73*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (45*resizeFactor) - offsetX, (130*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (20*resizeFactor) - offsetX, (186*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (50*resizeFactor) - offsetX, (203*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (218*resizeFactor) - offsetX, (199*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (234*resizeFactor) - offsetX, (180*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (212*resizeFactor) - offsetX, (135*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (242*resizeFactor) - offsetX, (81*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (221*resizeFactor) - offsetX, (59*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (125*resizeFactor) - offsetX, (47*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (31*resizeFactor) - offsetX, (63*resizeFactor) - offsetY);
        
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
    shape.lineWidth = 2.0;
    [self addChild:shape];
}

@end
