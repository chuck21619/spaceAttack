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
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser 1"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser 2"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser 3"]];
        [laserFrames addObject:[SKTexture textureWithImageNamed:@"laser 4"]];
        sharedPlayerWeaponsKit.laserFrames = laserFrames;
        
        NSMutableArray * laserFramesUpgraded = [NSMutableArray new];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 1"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 2"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 3"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 4"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 5"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 6"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 7"]];
        [laserFramesUpgraded addObject:[SKTexture textureWithImageNamed:@"laser_upgrade 8"]];
        sharedPlayerWeaponsKit.laserFramesUpgraded = laserFramesUpgraded;
        
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

- (NSArray *) currentLaserFrames
{
    if ( [AccountManager laserUpgraded] )
        return self.laserFramesUpgraded;
    else
        return self.laserFrames;
}

- (NSArray *) texturesForPreloading
{
    NSMutableArray * textures = [NSMutableArray new];
    [textures addObjectsFromArray:[self.weaponTextures allValues]];
    [textures addObject:self.bulletTexture];
    [textures addObject:self.photonTexture];
    [textures addObjectsFromArray:self.laserFrames];
    [textures addObjectsFromArray:self.laserFramesUpgraded];
    [textures addObjectsFromArray:self.electricityFrames];
    return textures;
}

@end
