//
//  Habsburg.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Habsburg.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Habsburg

- (id) init
{
    if ( self = [super init] )
    {
        self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:@"Reg"];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        [self setNumberOfWeaponSlots:[AccountManager numberOfWeaponSlotsUnlocked]];
        
        self.storeKitIdentifier = @"habsburg";
        self.defaultDamage = 18;
        self.damage = self.defaultDamage;
        self.armor = 10;
        self.mySpeed = 14;
        self.pointsToUnlock = 90000;
        
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, 0);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed*1.2;
        exhaust.particleSpeed = 500;
        exhaust.particleLifetime *= .5;
        [self addChild:exhaust];
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (20*resizeFactor) - offsetX, (126*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (250*resizeFactor) - offsetX, (473*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (481*resizeFactor) - offsetX, (125*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (249*resizeFactor) - offsetX, (39*resizeFactor) - offsetY);
        
        CGPathCloseSubpath(path);
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        //[self attachDebugFrameFromPath:path];
        
        self.physicsBody.dynamic = NO;
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks shipCategory];
        self.physicsBody.collisionBitMask = [CategoryBitMasks shipCategory] | [CategoryBitMasks asteroidCategory];
        self.physicsBody.contactTestBitMask = [CategoryBitMasks shipCategory] | [CategoryBitMasks asteroidCategory] | [CategoryBitMasks missileCategory];
    }
    
    return self;
}

- (float) healthPercentage
{
    return self.armor/10.0;
}

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.zPosition = 100;
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:0 green:0 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

- (id) copyWithZone:(NSZone *)zone
{
    Habsburg * another = [[Habsburg alloc] init];
    return another;
}

@end
