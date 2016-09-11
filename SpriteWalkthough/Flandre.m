//
//  Flandre.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Flandre.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Flandre

- (id) init
{
    if ( self = [super init] )
    {
        self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:@"Reg"];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        
        self.storeKitIdentifier = @"flandre";
        self.defaultDamage = 12;
        self.damage = self.defaultDamage;
        self.armor = 15;
        self.mySpeed = 14;
        self.pointsToUnlock = 20500;
        
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust1 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust1.name = @"exhaust";
        exhaust1.position = CGPointMake(((-self.size.width/10)*3) + self.size.width/2, -self.size.height/2.5);
        exhaust1.particleBirthRate = exhaust1.particleBirthRate*self.mySpeed;
        exhaust1.particleSpeed *= .5;
        [self addChild:exhaust1];
        SKEmitterNode * exhaust2 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust2.name = @"exhaust";
        exhaust2.position = CGPointMake(((-self.size.width/10)*7) + self.size.width/2, -self.size.height/2.5);
        exhaust2.particleBirthRate = exhaust2.particleBirthRate*self.mySpeed;
        exhaust2.particleSpeed *= .5;
        [self addChild:exhaust2];
        SKEmitterNode * exhaust3 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust3.name = @"exhaust";
        exhaust3.position = CGPointMake((-self.size.width/6) + self.size.width/2, -self.size.height/3);
        exhaust3.particleBirthRate = exhaust3.particleBirthRate*self.mySpeed;
        exhaust3.particleSpeed *= .3;
        exhaust3.particleScale *= .9;
        [self addChild:exhaust3];
        SKEmitterNode * exhaust4 = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust4.name = @"exhaust";
        exhaust4.position = CGPointMake(((-self.size.width/6)*5) + self.size.width/2, -self.size.height/3);
        exhaust4.particleBirthRate = exhaust4.particleBirthRate*self.mySpeed;
        exhaust4.particleSpeed *= .3;
        exhaust4.particleScale *= .9;
        [self addChild:exhaust4];
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (78*resizeFactor) - offsetX, (108*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (256*resizeFactor) - offsetX, (492*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (439*resizeFactor) - offsetX, (107*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (283*resizeFactor) - offsetX, (26*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (231*resizeFactor) - offsetX, (22*resizeFactor) - offsetY);
        
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

- (void) setNumberOfWeaponSlots:(int)numberOfWeaponSlots
{
    switch ( numberOfWeaponSlots )
    {
        case 1:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 53)], [NSNumber numberWithInt:-1]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 53)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(0, -12)], [NSNumber numberWithInt:2]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 53)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(0, -12)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(31, 22)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(-31, 22)], [NSNumber numberWithInt:-1]]};
            break;
            
        default:
            self.weaponSlotPositions = @{};
    }
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
    Flandre * another = [[Flandre alloc] init];
    return another;
}

@end
