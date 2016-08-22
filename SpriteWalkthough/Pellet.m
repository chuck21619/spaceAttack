//
//  Pellet.m
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Pellet.h"
#import "CategoryBitMasks.h"

@implementation Pellet

- (id)initWithTexture:(SKTexture *)texture
{
    if (self = [super initWithTexture:texture])
    {
        self.name = @"pellet";
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:(self.size.width/2)];
        
        self.physicsBody.linearDamping = 0;
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks pelletCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = [CategoryBitMasks shipCategory];
    }
    return self;
}


- (void) explode
{
    NSString * explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
    SKEmitterNode * explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.name = @"explosion";
    explosion.position = self.position;
    
    [[self scene] addChild:explosion];
    [self removeFromParent];
}

@end
