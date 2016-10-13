//
//  Boss1.m
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Boss1.h"
#import "CategoryBitMasks.h"

@implementation Boss1

- (id)init
{
    if (self = [super initWithImageNamed:@"Boss1.png"])
    {
		self = [[Boss1 alloc] initWithImageNamed:@"Boss1.png"];
        self.name = @"boss";
    
        self.maxHealth = 30;
        self.health = self.maxHealth;
        
        //draw the physics body
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
        CFRelease(path);
        //[self attachDebugFrameFromPath:path];
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks enemyCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask =  [CategoryBitMasks shipCategory] | [CategoryBitMasks missileCategory];
	}
    return self;
}


- (void) startFighting
{
    [self equipBlastGun];
    
    SKAction * moveY1 = [SKAction moveByX:0 y:-30 duration:1];
    [moveY1 setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction * moveY2 = [SKAction moveByX:0 y:30 duration:1];
    [moveY2 setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction * sequenceY = [SKAction repeatActionForever:[SKAction sequence:@[moveY1, moveY2]]];
    SKAction * firstMoveX1 = [SKAction moveToX:self.size.width/2 duration:3];
    [firstMoveX1 setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction * moveX1 = [SKAction moveToX:((-self.size.width/2)+self.scene.size.width) duration:6];
    [moveX1 setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction * moveX2 = [SKAction moveToX:self.size.width/2 duration:6];
    [moveX2 setTimingMode:SKActionTimingEaseInEaseOut];
    SKAction * sequenceX = [SKAction sequence:@[firstMoveX1 ,[SKAction repeatActionForever:[SKAction sequence:@[moveX1, moveX2]]]]];
    SKAction * roam = [SKAction group:@[sequenceX, sequenceY]];
    [self runAction:[SKAction repeatActionForever:roam]];
}


- (void) equipBlastGun
{
    BlastGun * myBlastGun = [[BlastGun alloc] init];
    myBlastGun.position = CGPointMake(0, -100);
    [self addChild:myBlastGun];
}

- (void) takeDamage:(int) damage
{
    self.health -= damage;
    
    if ( self.health <= 0 )
        [super explode];
    else
    {
        SKAction * pulseOrange = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor orangeColor] colorBlendFactor:0.5 duration:0.15],
                                                   [SKAction waitForDuration:0.1],
                                                   [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
        [self runAction: pulseOrange];
    }
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
