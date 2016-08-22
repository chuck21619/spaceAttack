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
        [self setSize:CGSizeMake(powerUpTexture.size.width/10, powerUpTexture.size.height/10)];
        self.powerUpType = powerUpType;
        self.name = [NSString stringWithFormat:@"powerUp_%@", powerUpTextureKey];
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = [CategoryBitMasks powerUpCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = [CategoryBitMasks shipCategory];
    }
    return self;
}

@end
