//
//  SpaceshipKit.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/22/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "SpaceshipKit.h"

@implementation SpaceshipKit

static SpaceshipKit * sharedSpaceshipKit = nil;
+ (SpaceshipKit *)sharedInstance
{
    if ( sharedSpaceshipKit == nil )
    {
        sharedSpaceshipKit = [[SpaceshipKit alloc] init];
        
        SKTexture * abdulKadir = [SKTexture textureWithImageNamed:@"Abdul_Kadir_Menu.png"];
        SKTexture * babengerg = [SKTexture textureWithImageNamed:@"Babenberg_Menu.png"];
        SKTexture * caiman = [SKTexture textureWithImageNamed:@"Caiman_Menu.png"];
        SKTexture * dandolo = [SKTexture textureWithImageNamed:@"Dandolo_Menu.png"];
        SKTexture * edinburgh = [SKTexture textureWithImageNamed:@"Edinburgh_Menu.png"];
        SKTexture * flandre = [SKTexture textureWithImageNamed:@"Flandre_Menu.png"];
        SKTexture * gascogne = [SKTexture textureWithImageNamed:@"Gascogne_Menu.png"];
        SKTexture * habsburg = [SKTexture textureWithImageNamed:@"Habsburg_Menu.png"];
        
        sharedSpaceshipKit.shipTextures = @{NSStringFromClass([Abdul_Kadir class]) : abdulKadir,
                                            NSStringFromClass([Babenberg class]) : babengerg,
                                            NSStringFromClass([Caiman class]) : caiman,
                                            NSStringFromClass([Dandolo class]) : dandolo,
                                            NSStringFromClass([Edinburgh class]) : edinburgh,
                                            NSStringFromClass([Flandre class]) : flandre,
                                            NSStringFromClass([Gascogne class]) : gascogne,
                                            NSStringFromClass([Habsburg class]) : habsburg};
    }
    
    return sharedSpaceshipKit;
}

- (NSArray *) texturesForPreloading
{
    return [self.shipTextures allValues];
}

@end
