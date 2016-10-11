//
//  Gascogne.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Gascogne.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Gascogne

- (id) init
{
    if ( self = [super init] )
    {
        self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:@"Reg"];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        [self setNumberOfWeaponSlots:[AccountManager numberOfWeaponSlotsUnlocked]];
        
        self.storeKitIdentifier = @"gascogne";
        self.defaultDamage = 7;
        self.damage = self.defaultDamage;
        self.armor = 19;
        self.mySpeed = 18;
        self.pointsToUnlock = 55000;
        
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust1 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust1.name = @"exhaust";
        exhaust1.position = CGPointMake(((-self.size.width/6)*2) + self.size.width/2, 0);
        exhaust1.particleBirthRate = exhaust1.particleBirthRate*(self.mySpeed/4);
        [self addChild:exhaust1];
        SKEmitterNode * exhaust2 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust2.name = @"exhaust";
        exhaust2.position = CGPointMake(((-self.size.width/6)*3) + self.size.width/2, -self.size.height/3);
        exhaust2.particleBirthRate = exhaust2.particleBirthRate*(self.mySpeed/2);
        [self addChild:exhaust2];
        SKEmitterNode * exhaust3 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust3.name = @"exhaust";
        exhaust3.position = CGPointMake(((-self.size.width/6)*4) + self.size.width/2, 0);
        exhaust3.particleBirthRate = exhaust3.particleBirthRate*(self.mySpeed/4);
        [self addChild:exhaust3];
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (73*resizeFactor) - offsetX, (110*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (99*resizeFactor) - offsetX, (486*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (419*resizeFactor) - offsetX, (488*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (441*resizeFactor) - offsetX, (105*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (256*resizeFactor) - offsetX, (27*resizeFactor) - offsetY);
        
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
    return self.armor/19.0;
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
    Gascogne * another = [[Gascogne alloc] init];
    return another;
}

@end
