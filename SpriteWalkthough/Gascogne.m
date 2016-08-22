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
        self.menuImageName = @"Gascogne_Menu.png";
        self.size = CGSizeMake(100, 64);
        self.texture = [[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])];
        
        self.defaultDamage = 7;
        self.damage = self.defaultDamage;
        self.armor = 19;
        self.mySpeed = 18;
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
        
        self.pointsToUnlock = 4500;
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 1 - offsetX, 19 - offsetY);
        CGPathAddLineToPoint(path, NULL, 45 - offsetX, 62 - offsetY);
        CGPathAddLineToPoint(path, NULL, 56 - offsetX, 63 - offsetY);
        CGPathAddLineToPoint(path, NULL, 99 - offsetX, 23 - offsetY);
        CGPathAddLineToPoint(path, NULL, 49 - offsetX, 0 - offsetY);
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
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 30)], [NSNumber numberWithInt:2]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(20, -10)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-20, -10)], [NSNumber numberWithInt:-1]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(20, -10)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-20, -10)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(0, 30)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(0, -20)], [NSNumber numberWithInt:-1]]};
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
    Gascogne * another = [[Gascogne alloc] init];
    return another;
}

@end
