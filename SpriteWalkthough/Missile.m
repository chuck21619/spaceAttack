//
//  Missle.m
//  SpriteWalkthough
//
//  Created by chuck on 4/2/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Missile.h"
#import "CategoryBitMasks.h"

@implementation Missile

- (id)init
{
    if (self = [super init])
    {
		self = [[Missile alloc] initWithImageNamed:@"missile.png"];
        self.name = @"missile";
        self.isLaunched = NO;
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 12 - offsetY);
        CGPathAddLineToPoint(path, NULL, 6 - offsetX, 67 - offsetY);
        CGPathAddLineToPoint(path, NULL, 13 - offsetX, 66 - offsetY);
        CGPathAddLineToPoint(path, NULL, 18 - offsetX, 14 - offsetY);
        CGPathCloseSubpath(path);
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        CFRelease(path);
        self.physicsBody.dynamic = NO;
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks missileCategory];
        self.physicsBody.collisionBitMask = [CategoryBitMasks missileCategory] | [CategoryBitMasks asteroidCategory];
        self.physicsBody.contactTestBitMask = [CategoryBitMasks missileCategory] | [CategoryBitMasks asteroidCategory] | [CategoryBitMasks shipCategory];
	}
    return self;
}

- (void) launch
{
    self.isLaunched = YES;
    SKAction * shrink = [SKAction scaleBy:.9 duration:.25];
    [self runAction:shrink];
    NSString * firePath = [[NSBundle mainBundle] pathForResource:@"FireParticle" ofType:@"sks"];
    SKEmitterNode * fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.position = CGPointMake(0, -25);
    [self addChild:fire];
    self.physicsBody.dynamic = YES;
    self.position = [[self scene] convertPoint:self.position fromNode:self.parent];
    [self.physicsBody applyImpulse:CGVectorMake(0, 15)];
    
    [[self scene] addChild:[self copy]];
    [self removeFromParent];
    
    /*
    self.isLaunched = YES;
    SKAction * shrink = [SKAction scaleBy:.9 duration:.25];
    [self runAction:shrink];
    NSString * firePath = [[NSBundle mainBundle] pathForResource:@"FireParticle" ofType:@"sks"];
    SKEmitterNode * fire = [NSKeyedUnarchiver unarchiveObjectWithFile:firePath];
    fire.position = CGPointMake(0, -25);
    [self addChild:fire];
    self.physicsBody.dynamic = YES;
     */
}

- (id) copyWithZone:(NSZone *)zone
{
    Missile * missileCopy = [super copyWithZone:zone];
    missileCopy.isLaunched = self.isLaunched;
    
    return missileCopy;
}

- (void) update
{
    if ( self.isLaunched )
        [self.physicsBody applyForce:CGVectorMake(0, 60)];
}

- (void) explode
{
    NSString * explosionPath = [[NSBundle mainBundle] pathForResource:@"ExplosionParticle" ofType:@"sks"];
    SKEmitterNode * explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.name = @"explosion";
    
    // not sure if i need convert the position yet
    //explosion.position = [[self scene] convertPoint:explosion.position fromNode:self];
    explosion.position = self.position;
    
    [[self scene] addChild:explosion];
    [self removeFromParent];
}

@end
