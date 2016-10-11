//
//  Babenberg.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Babenberg.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Babenberg

- (id) init
{
    if ( self = [super init] )
    {
        self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:@"Reg"];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        [self setNumberOfWeaponSlots:[AccountManager numberOfWeaponSlotsUnlocked]];
        
        self.storeKitIdentifier = @"babenberg";
        self.defaultDamage = 4;
        self.damage = self.defaultDamage;
        self.armor = 7;
        self.mySpeed = 2;
        self.pointsToUnlock = 200;
        
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, -self.size.height/3);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed;
        [self addChild:exhaust];
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (153*resizeFactor) - offsetX, (159*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (257*resizeFactor) - offsetX, (478*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (361*resizeFactor) - offsetX, (162*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (331*resizeFactor) - offsetX, (22*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (256*resizeFactor) - offsetX, (153*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (181*resizeFactor) - offsetX, (20*resizeFactor) - offsetY);
        
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
    return self.armor/7.0;
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
    Babenberg * another = [[Babenberg alloc] init];
    return another;
}

@end
