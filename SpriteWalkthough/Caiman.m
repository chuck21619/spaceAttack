//
//  Caiman.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Caiman.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Caiman

- (id) init
{
    if ( self = [super init] )
    {
        self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:@"Reg"];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        
        self.storeKitIdentifier = @"caiman";
        self.defaultDamage = 9;
        self.damage = self.defaultDamage;
        self.armor = 4;
        self.mySpeed = 5;
        self.pointsToUnlock = 550;
        
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, -self.size.height/3);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed;
        exhaust.particleScale = 1;
        [self addChild:exhaust];
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (72*resizeFactor) - offsetX, (324*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (253*resizeFactor) - offsetX, (489*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (432*resizeFactor) - offsetX, (322*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (460*resizeFactor) - offsetX, (179*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (321*resizeFactor) - offsetX, (316*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (254*resizeFactor) - offsetX, (20*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (185*resizeFactor) - offsetX, (317*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (46*resizeFactor) - offsetX, (179*resizeFactor) - offsetY);
        
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
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, -8)], [NSNumber numberWithInt:2]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(33, -21)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-33, -21)], [NSNumber numberWithInt:2]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(33, -21)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(-33, -21)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(20, 25)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(-20, 25)], [NSNumber numberWithInt:-1]]};
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
    Caiman * another = [[Caiman alloc] init];
    return another;
}

@end
