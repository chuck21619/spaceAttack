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
        self.menuImageName = @"Habsburg_Menu.png";
        self.size = CGSizeMake(81, 100);
        self.texture = [[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])];
        
        self.defaultDamage = 18;
        self.damage = self.defaultDamage;
        self.armor = 10;
        self.mySpeed = 14;
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, 0);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed*1.2;
        exhaust.particleSpeed = 500;
        exhaust.particleLifetime *= .5;
        [self addChild:exhaust];
        
        self.pointsToUnlock = 10000;
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 1 - offsetX, 3 - offsetY);
        CGPathAddLineToPoint(path, NULL, 9 - offsetX, 55 - offsetY);
        CGPathAddLineToPoint(path, NULL, 41 - offsetX, 98 - offsetY);
        CGPathAddLineToPoint(path, NULL, 72 - offsetX, 55 - offsetY);
        CGPathAddLineToPoint(path, NULL, 80 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, NULL, 42 - offsetX, 50 - offsetY);
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
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 40)], [NSNumber numberWithInt:-1]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(15, 27)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-15, 27)], [NSNumber numberWithInt:-1]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(15, 27)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-15, 27)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(30, -17)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(-30, -17)], [NSNumber numberWithInt:-1]]};
            break;
            
        default:
            self.weaponSlotPositions = @{};
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

- (id) copyWithZone:(NSZone *)zone
{
    Habsburg * another = [[Habsburg alloc] init];
    return another;
}

@end
