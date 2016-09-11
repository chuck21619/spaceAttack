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
        self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:@"Reg"];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        
        self.storeKitIdentifier = @"dandolo";
        self.defaultDamage = 8;
        self.damage = self.defaultDamage;
        self.armor = 11;
        self.mySpeed = 10;
        self.pointsToUnlock = 1700;
        
        NSString * exhaustPath = [[NSBundle mainBundle] pathForResource:@"Exhaust" ofType:@"sks"];
        SKEmitterNode * exhaust = [NSKeyedUnarchiver unarchiveObjectWithFile:exhaustPath];
        exhaust.name = @"exhaust";
        exhaust.position = CGPointMake(0, -self.size.height/5);
        exhaust.particleBirthRate = exhaust.particleBirthRate*self.mySpeed;
        [self addChild:exhaust];
        
        // draw the physics body
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, (75*resizeFactor) - offsetX, (476*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (260*resizeFactor) - offsetX, (359*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (445*resizeFactor) - offsetX, (472*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (449*resizeFactor) - offsetX, (199*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (296*resizeFactor) - offsetX, (42*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (229*resizeFactor) - offsetX, (42*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (79*resizeFactor) - offsetX, (199*resizeFactor) - offsetY);
        
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
    shape.zPosition = 100;
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:0 green:0 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

- (id) copyWithZone:(NSZone *)zone
{
    Dandolo * another = [[Dandolo alloc] init];
    return another;
}

@end
