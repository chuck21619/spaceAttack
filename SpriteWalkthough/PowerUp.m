//
//  PowerUp.m
//  SpaceAttack
//
//  Created by charles johnston on 8/10/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "PowerUp.h"
#import "CategoryBitMasks.h"
#import "SpaceObjectsKit.h"

@implementation PowerUp

- (id) initWithPowerUpType:(PowerUpType)powerUpType
{
    if ( self = [super init] )
    {
        NSString * powerUpTextureKey;
        switch (powerUpType) {
            case kPowerUpTypeMachineGun:
                powerUpTextureKey = @"MachineGun";
                break;
                
            case kPowerUpTypePhotonCannon:
                powerUpTextureKey = @"PhotonCannon";
                break;
                
            case kPowerUpTypeElectricalGenerator:
                powerUpTextureKey = @"ElectricalGenerator";
                break;
                
            case kPowerUpTypeLaserCannon:
                powerUpTextureKey = @"LaserCannon";
                break;
                
            case kPowerUpTypeShield:
                powerUpTextureKey = @"Shield";
                break;
                
            case kPowerUpTypeEnergyBooster:
                powerUpTextureKey = @"EnergyBooster";
                break;
                
            default:
                break;
        }
        
        SKTexture * powerUpTexture = [[[SpaceObjectsKit sharedInstanceWithScene:nil] powerUpTextures] objectForKey:powerUpTextureKey];
        [self setTexture:powerUpTexture];
        self.powerUpType = powerUpType;
        self.name = [NSString stringWithFormat:@"powerUp_%@", powerUpTextureKey];
        
        
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.2;
        self.size = CGSizeMake(135*resizeFactor, 135*resizeFactor);
        
        float physicsBodyRadius = self.size.width;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius];
        //[self attachDebugCircleWithSize:physicsBodyRadius*2];
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = [CategoryBitMasks powerUpCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = [CategoryBitMasks shipCategory] | [CategoryBitMasks shieldCategory];
    }
    return self;
}


- (void)attachDebugCircleWithSize:(int)s
{
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-s/2, -s/2, s, s), nil);
    [self attachDebugFrameFromPath:bodyPath];
    CFRelease(bodyPath);
}

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.zPosition = 100;
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:1 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

@end
