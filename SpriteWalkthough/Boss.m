//
//  Boss.m
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Boss.h"
#import "CategoryBitMasks.h"

@implementation Boss

- (id) initWithImageNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:name])
    {
        //self.level = 2;
    }
    
    return self;
}

- (id)init
{
    if (self = [super init])
    {
        self = [[Boss alloc] initWithImageNamed:@"Boss1.png"];
        self.name = @"boss";
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 14 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 2 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, NULL, 40 - offsetX, 142 - offsetY);
        CGPathAddLineToPoint(path, NULL, 54 - offsetX, 142 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, NULL, 79 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 66 - offsetX, 13 - offsetY);
        CGPathAddLineToPoint(path, NULL, 47 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 29 - offsetX, 14 - offsetY);
        CGPathCloseSubpath(path);
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        //[self attachDebugFrameFromPath:path];
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks enemyCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask =  [CategoryBitMasks shipCategory] | [CategoryBitMasks missileCategory];
        
        self.maxHealth = 30;
        self.health = self.maxHealth;
    }
    return self;
}


- (void) explode
{
    //make this explosion bigger
    NSString * explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
    SKEmitterNode * explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.name = @"explosion";
    explosion.position = self.position;
    
    [[self scene] addChild:explosion];
    [self removeFromParent];
}

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

@end
