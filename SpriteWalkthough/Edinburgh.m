//
//  Edinburgh.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Edinburgh.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Edinburgh

- (id) init
{
    if ( self = [super init] )
    {
        self.menuImageName = @"Edinburgh_Menu.png";
        self.size = CGSizeMake(100, 79);
        self.texture = [[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])];
        
        self.defaultDamage = 16;
        self.damage = self.defaultDamage;
        self.armor = 6;
        self.mySpeed = 4;
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, -self.size.height/3);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed;
        [self addChild:exhaust];
        
        self.pointsToUnlock = 1100;
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0 - offsetX, 43 - offsetY);
        CGPathAddLineToPoint(path, NULL, 27 - offsetX, 78 - offsetY);
        CGPathAddLineToPoint(path, NULL, 71 - offsetX, 78 - offsetY);
        CGPathAddLineToPoint(path, NULL, 99 - offsetX, 37 - offsetY);
        CGPathAddLineToPoint(path, NULL, 86 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 14 - offsetX, 0 - offsetY);
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
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 35)], [NSNumber numberWithInt:-1]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(-20, -15)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(20, -15)], [NSNumber numberWithInt:2]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(-20, -15)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(20, -15)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(40, 15)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(-40, 15)], [NSNumber numberWithInt:-1]]};
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
    Edinburgh * another = [[Edinburgh alloc] init];
    return another;
}

@end
