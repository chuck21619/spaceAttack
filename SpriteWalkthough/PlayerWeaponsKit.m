//
//  PlayerWeaponsKit.m
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerWeaponsKit.h"
#import "AccountManager.h"
#import "UpgradesViewController.h"

@implementation PlayerWeaponsKit

static PlayerWeaponsKit * sharedPlayerWeaponsKit = nil;
+ (PlayerWeaponsKit *)sharedInstance
{
    if ( sharedPlayerWeaponsKit == nil )
    {
        sharedPlayerWeaponsKit = [[PlayerWeaponsKit alloc] init];
        
        SKTexture * machineGun = [SKTexture textureWithImageNamed:@"machineGun.png"];
        SKTexture * photonCannon = [SKTexture textureWithImageNamed:@"photonCannon.png"];
        SKTexture * laserCannon = [SKTexture textureWithImageNamed:@"laserCannon.png"];
        SKTexture * electricalGenerator = [SKTexture textureWithImageNamed:@"electricalGenerator.png"];
        
        sharedPlayerWeaponsKit.weaponTextures = @{NSStringFromClass([MachineGun class]) : machineGun,
                                                  NSStringFromClass([PhotonCannon class]) : photonCannon,
                                                  NSStringFromClass([LaserCannon class]) : laserCannon,
                                                  NSStringFromClass([ElectricalGenerator class]) : electricalGenerator};
        
        sharedPlayerWeaponsKit.bulletTexture = [SKTexture textureWithImageNamed:@"bullet.png"];
        sharedPlayerWeaponsKit.photonTexture = [SKTexture textureWithImageNamed:@"photon.png"];
        
        //laser
        NSMutableArray * laserFrames = [NSMutableArray new];
//        NSString * atlasName;
//        if ( [AccountManager laserUpgraded] || [sharedPlayerWeaponsKit beingUsedForDemoScene] )
//            atlasName = @"laserUpgraded";
//        else
//            atlasName = @"laser";
//        SKTextureAtlas * laserAtlas = [SKTextureAtlas atlasNamed:atlasName];
        
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser1.png"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser2.png"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser3.png"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser4.png"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser5.png"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser6.png"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser7.png"]];
        
        sharedPlayerWeaponsKit.laserFrames = laserFrames;
        
        //electricity
        sharedPlayerWeaponsKit.electricityFrames = [NSMutableArray new];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity1.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity2.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity3.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity4.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity5.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity6.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity7.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity8.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity9.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity10.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity11.png"]];
        [sharedPlayerWeaponsKit.electricityFrames addObject:[SKTexture textureWithImageNamed:@"electricity12.png"]];
    }
    
    return sharedPlayerWeaponsKit;
}

- (BOOL) beingUsedForDemoScene
{
    if ( [[[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentedViewController] class] == [UpgradesViewController class] )
        return YES;
    
    return NO;
}

- (NSArray *) texturesForPreloading
{
    NSMutableArray * textures = [NSMutableArray new];
    [textures addObjectsFromArray:[self.weaponTextures allValues]];
    [textures addObject:self.bulletTexture];
    [textures addObject:self.photonTexture];
    [textures addObjectsFromArray:self.laserFrames];
    [textures addObjectsFromArray:self.electricityFrames];
    return textures;
}

@end
