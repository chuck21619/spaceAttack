//
//  Dandolo.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Dandolo.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Dandolo

- (id) init
{
    if ( self = [super init] )
    {
        self.menuImageName = @"Dandolo_Menu.png";
        self.size = CGSizeMake(70, 100);
        self.texture = [[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])];
        
        self.defaultDamage = 8;
        self.damage = self.defaultDamage;
        self.armor = 11;
        self.mySpeed = 10;
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, -self.size.height/3);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed;
        [self addChild:exhaust];
        
        self.pointsToUnlock = 450;
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 1 - offsetX, 52 - offsetY);
        CGPathAddLineToPoint(path, NULL, 23 - offsetX, 91 - offsetY);
        CGPathAddLineToPoint(path, NULL, 34 - offsetX, 98 - offsetY);
        CGPathAddLineToPoint(path, NULL, 47 - offsetX, 92 - offsetY);
        CGPathAddLineToPoint(path, NULL, 69 - offsetX, 47 - offsetY);
        CGPathAddLineToPoint(path, NULL, 69 - offsetX, 18 - offsetY);
        CGPathAddLineToPoint(path, NULL, 46 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 28 - offsetX, 4 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 21 - offsetY);
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
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 25)], [NSNumber numberWithInt:2]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(20, -20)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-16, 20)], [NSNumber numberWithInt:2]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(20, -20)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-16, 20)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(20, 25)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(-20, -30)], [NSNumber numberWithInt:-1]]};
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
    Dandolo * another = [[Dandolo alloc] init];
    return another;
}

@end
