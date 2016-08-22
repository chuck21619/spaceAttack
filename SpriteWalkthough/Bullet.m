//
//  Bullet.m
//  SpriteWalkthough
//
//  Created by chuck on 4/28/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Bullet.h"
#import "CategoryBitMasks.h"

@implementation Bullet

- (id)initWithTexture:(SKTexture *)texture
{
    if (self = [super initWithTexture:texture])
    {
        self.name = @"bullet";
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks bulletCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = [CategoryBitMasks asteroidCategory] | [CategoryBitMasks enemyCategory];
    }
    return self;
}

+ (int) baseDamage
{
    return 2;
}

@end
