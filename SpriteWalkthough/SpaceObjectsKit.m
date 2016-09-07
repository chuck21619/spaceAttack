//
//  SpaceObjectsKit.m
//  SpriteWalkthough
//
//  Created by chuck on 7/17/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "SpaceObjectsKit.h"
#import "SpaceshipScene.h"

@implementation SpaceObjectsKit
{
    NSDictionary * _spaceBackgroundTextures;
}

static SpaceObjectsKit * sharedSpaceObjectsKit = nil;
+ (SpaceObjectsKit *)sharedInstanceWithScene:(SpaceshipScene *)scene
{
    if ( sharedSpaceObjectsKit == nil )
    {
        sharedSpaceObjectsKit = [[SpaceObjectsKit alloc] init];
    }
    
    if ( scene )
        sharedSpaceObjectsKit.scene = scene;
    
    return sharedSpaceObjectsKit;
}

- (instancetype) init
{
    if ( self = [super init] )
    {
        //asteroids
        NSMutableArray * crumbleFrames = [NSMutableArray array];
        SKTextureAtlas * asteroidAnimatedAtlas = [SKTextureAtlas atlasNamed:@"asteroid"];
        for ( int i = 1; i <= asteroidAnimatedAtlas.textureNames.count; i++ )
        {
            NSString * textureName = [NSString stringWithFormat:@"asteroid%d", i];
            SKTexture * tmp = [asteroidAnimatedAtlas textureNamed:textureName];
            [crumbleFrames addObject:tmp];
        }
        self.asteroidTextureAtlas = [NSArray arrayWithArray:crumbleFrames];
        
        //shield textures
        NSMutableArray * shieldFrames = [NSMutableArray array];
        SKTextureAtlas * shieldAnimatedAtlas = [SKTextureAtlas atlasNamed:@"shield1"];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-1"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-2"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-3"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-4"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-5"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-6"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-7"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-8"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield1-9"]]];
        self.shield1Frames = shieldFrames;
        
        shieldFrames = [NSMutableArray new];
        shieldAnimatedAtlas = [SKTextureAtlas atlasNamed:@"shield2"];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-1"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-2"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-3"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-4"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-5"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-6"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-7"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-8"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield2-9"]]];
        self.shield2Frames = shieldFrames;
        
        shieldFrames = [NSMutableArray new];
        shieldAnimatedAtlas = [SKTextureAtlas atlasNamed:@"shield3"];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-1"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-2"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-3"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-4"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-5"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-6"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-7"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-8"]]];
        [shieldFrames addObject:[shieldAnimatedAtlas textureNamed:[NSString stringWithFormat:@"shield3-9"]]];
        self.shield3Frames = shieldFrames;
        
        //power up textures
        SKTexture * machineGun = [SKTexture textureWithImageNamed:@"Bullet_Powerup.png"];
        SKTexture * photonCannon = [SKTexture textureWithImageNamed:@"Photon_Powerup.png"];
        SKTexture * electricalGenerator = [SKTexture textureWithImageNamed:@"Electricity_Powerup.png"];
        SKTexture * laserCannon = [SKTexture textureWithImageNamed:@"Laser_Powerup.png"];
        SKTexture * shield = [SKTexture textureWithImageNamed:@"Shield_Powerup.png"];
        SKTexture * energyBooster = [SKTexture textureWithImageNamed:@"Boost_Powerup.png"];
        
        
        self.powerUpTextures = @{@"MachineGun" : machineGun,
                                 @"PhotonCannon" : photonCannon,
                                 @"ElectricalGenerator" : electricalGenerator,
                                 @"LaserCannon" : laserCannon,
                                 @"Shield": shield,
                                 @"EnergyBooster" : energyBooster};
        
        _spaceBackgroundTextures = @{@"Black Star" : [SKTexture textureWithImageNamed:@"Black Star copy.png"],
                                     @"Broken" : [SKTexture textureWithImageNamed:@"Broken copy.png"],
                                     @"Colony" : [SKTexture textureWithImageNamed:@"Colony copy.png"],
                                     @"Hologram" : [SKTexture textureWithImageNamed:@"Hologram copy.png"],
                                     @"Red" : [SKTexture textureWithImageNamed:@"Red copy.png"],
                                     @"Ring" : [SKTexture textureWithImageNamed:@"Ring copy.png"],
                                     @"Serebus" : [SKTexture textureWithImageNamed:@"Serebus copy.png"],
                                     @"Twin Suns" : [SKTexture textureWithImageNamed:@"Twin Suns copy.png"],
                                     @"Verdant" : [SKTexture textureWithImageNamed:@"Verdant copy.png"],
                                     @"Void" : [SKTexture textureWithImageNamed:@"Void copy.png"]};
    }
    return self;
}

- (NSArray *) texturesForPreloading
{
    NSMutableArray * textures = [NSMutableArray new];
    [textures addObjectsFromArray:self.asteroidTextureAtlas];
    [textures addObjectsFromArray:[self.powerUpTextures allValues]];
    [textures addObjectsFromArray:[_spaceBackgroundTextures allValues]];
    [textures addObjectsFromArray:self.shield1Frames];
    [textures addObjectsFromArray:self.shield2Frames];
    [textures addObjectsFromArray:self.shield3Frames];
    return textures;
}

- (Asteroid *)addAsteroidWithSpeed:(float)speed angle:(float)angle
{
    Asteroid * newAsteroid = [[Asteroid alloc] initWithAtlas:self.asteroidTextureAtlas];
    newAsteroid.delegate = self.scene;
    
    float tan = tanf(GLKMathDegreesToRadians(angle));
    float randomXrange = tan*self.scene.size.height;
    float minXcoord = -randomXrange;
    if ( angle < 0 )
        minXcoord = 0;
    
    float maxXcoord = self.scene.size.width;
    if ( angle < 0 )
        maxXcoord -= randomXrange;
    
    float xCoord = skRand(minXcoord, maxXcoord);
    float yCoord = self.scene.size.height;
    
    if ( xCoord < 0 )
    {
        float xCoordDifference = 0.0;
        float yCoordDifference = 0.0;
    
        float xOffset = -xCoord;
        float otherAngle = 90-angle;
        yCoordDifference = tanf(GLKMathDegreesToRadians(otherAngle))*xOffset;
        xCoordDifference = xOffset;
        
        xCoord = -newAsteroid.size.width;
        yCoord -= (yCoordDifference - newAsteroid.size.height);
    }
    else if ( xCoord > 320 )
    {
        float xCoordDifference = 0.0;
        float yCoordDifference = 0.0;
        
        float xOffset = xCoord - self.scene.size.width;
        float otherAngle = 90+angle;
        yCoordDifference = tanf(GLKMathDegreesToRadians(otherAngle))*xOffset;
        xCoordDifference = xOffset;
        
        xCoord = self.scene.size.width + newAsteroid.size.width;
        yCoord -= (yCoordDifference - newAsteroid.size.height);
    }
    
    newAsteroid.position = CGPointMake(xCoord, yCoord);
    [self.scene addChild:newAsteroid];
    
    float deviceSizeFactor = [[UIScreen mainScreen] bounds].size.width*0.0000125;
    [newAsteroid.physicsBody applyTorque:skRand(-deviceSizeFactor, deviceSizeFactor)];
    
    //impulse
    CGFloat radianFactor = 0.0174532925;
    CGFloat newRotationDegrees = angle-90;
    CGFloat newRotationRadians = newRotationDegrees * radianFactor;
    CGFloat dx = speed * cos(newRotationRadians);
    CGFloat dy = speed * sin(newRotationRadians);
    [newAsteroid.physicsBody applyImpulse:CGVectorMake(dx*newAsteroid.size.width*.01, dy*newAsteroid.size.width*.01)];
    
    return newAsteroid;
}

- (void) addSpaceBackground
{
    SpaceBackground * spaceBackground;
    
    float posititionDifference = 0;
    if ( ![self.scene childNodeWithName:@"spaceBackground"] )
        posititionDifference = self.scene.size.height;
    
    NSArray * backgroundKeys = [_spaceBackgroundTextures allKeys];
    NSString * randomTextureKey = [backgroundKeys objectAtIndex:arc4random_uniform((int)backgroundKeys.count)];
                                                                                                      
    SKTexture * randomSpaceBackground = [_spaceBackgroundTextures objectForKey:randomTextureKey];
    NSLog(@"what : %@", NSStringFromCGSize(randomSpaceBackground.size));
    float resizeFactor = self.scene.size.width / randomSpaceBackground.size.width;
    spaceBackground = [SpaceBackground spriteNodeWithTexture:randomSpaceBackground size:CGSizeMake(randomSpaceBackground.size.width*resizeFactor, randomSpaceBackground.size.height*resizeFactor)];
    
    spaceBackground.name = @"spaceBackground";
    spaceBackground.zPosition = -100;
    spaceBackground.delegate = self.scene;
    [self.scene addChild:spaceBackground];
    
    int yCoord = (self.scene.size.height + spaceBackground.size.height/2) - posititionDifference;
    int difference = (spaceBackground.size.width/2) + (spaceBackground.size.width/2 - self.scene.size.width);
    int randomXcoord = arc4random_uniform(difference) - (spaceBackground.size.width/2 - self.scene.size.width);

    [spaceBackground setPosition:CGPointMake(randomXcoord, yCoord)];
    SKAction * moveDown = [SKAction moveTo:CGPointMake(spaceBackground.position.x, -spaceBackground.size.height) duration:300];
    [spaceBackground runAction:moveDown completion:^
    {
        [spaceBackground removeFromParent];
    }];
    
    NSLog(@"play song for background : %@", randomTextureKey);
    //[audiomanger playSongForBackgorund:randomTextureKey];
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

@end
