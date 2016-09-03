//
//  Abdul_Kadir.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "Abdul_Kadir.h"
#import "AccountManager.h"
#import "CategoryBitMasks.h"

@implementation Abdul_Kadir

- (id) init
{
    if ( self = [super init] )
    {
        self.menuImageName = @"Abdul_Kadir_Menu.png";
        
        self.texture = [[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])];
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.15;
        self.size = CGSizeMake(self.texture.size.width*resizeFactor, self.texture.size.height*resizeFactor);
        
        self.defaultDamage = 3;
        self.damage = self.defaultDamage;
        self.armor = 2;
        self.mySpeed = 5;
        
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
        
        CGPathMoveToPoint(path, NULL, (153*resizeFactor) - offsetX, (17*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (255*resizeFactor) - offsetX, (489*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (361*resizeFactor) - offsetX, (18*resizeFactor) - offsetY);
        CGPathAddLineToPoint(path, NULL, (258*resizeFactor) - offsetX, (98*resizeFactor) - offsetY);
        
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
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 58)], [NSNumber numberWithInt:-1]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 58)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(0, -1)], [NSNumber numberWithInt:2]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : @[[NSValue valueWithCGPoint:CGPointMake(0, 58)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot2" : @[[NSValue valueWithCGPoint:CGPointMake(0, -1)], [NSNumber numberWithInt:2]],
                                          @"weaponSlot3" : @[[NSValue valueWithCGPoint:CGPointMake(20, 15)], [NSNumber numberWithInt:-1]],
                                          @"weaponSlot4" : @[[NSValue valueWithCGPoint:CGPointMake(-20, 15)], [NSNumber numberWithInt:-1]]};
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
    Abdul_Kadir * another = [[Abdul_Kadir alloc] init];
    return another;
}

@end
