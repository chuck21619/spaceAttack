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
    SKTexture * _nextBackground;
    
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
        self.shieldTexture = [SKTexture textureWithImageNamed:@"shield.png"];
        
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
        
        _spaceBackgroundTextures = @{@"Black Star" : [SKTexture textureWithImageNamed:@"Black Star.png"],
                                     @"Broken" : [SKTexture textureWithImageNamed:@"Broken.png"],
                                     @"Colony" : [SKTexture textureWithImageNamed:@"Colony.png"],
                                     @"Hologram" : [SKTexture textureWithImageNamed:@"Hologram.png"],
                                     @"Red" : [SKTexture textureWithImageNamed:@"Red.png"],
                                     @"Ring" : [SKTexture textureWithImageNamed:@"Ring.png"],
                                     @"Serebus" : [SKTexture textureWithImageNamed:@"Serebus.png"],
                                     @"Twin Suns" : [SKTexture textureWithImageNamed:@"Twin Suns.png"],
                                     @"Verdant" : [SKTexture textureWithImageNamed:@"Verdant.png"],
                                     @"Void" : [SKTexture textureWithImageNamed:@"Void.png"]};
    }
    return self;
}

- (NSArray *) texturesForPreloading
{
    NSMutableArray * textures = [NSMutableArray new];
    [textures addObjectsFromArray:self.asteroidTextureAtlas];
    [textures addObjectsFromArray:[self.powerUpTextures allValues]];
    [textures addObject:self.shieldTexture];
    
    SKTexture * backgroundTexture = [self randomTextureForNextBackground];
    [textures addObject:backgroundTexture];
    
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

- (SKTexture *)randomTextureForNextBackground
{
    NSArray * backgroundKeys = [_spaceBackgroundTextures allKeys];
    NSString * randomTextureKey = [backgroundKeys objectAtIndex:arc4random_uniform((int)backgroundKeys.count)];
    _nextBackground = [_spaceBackgroundTextures objectForKey:randomTextureKey];
    return _nextBackground;
}

- (void) preloadNextBackground
{
    SKTexture * backgroundTexture = [self randomTextureForNextBackground];
    [SKTexture preloadTextures:@[backgroundTexture] withCompletionHandler:^
    {
        //preloading done
    }];
}

- (void) addSpaceBackground
{
    SpaceBackground * spaceBackground;
    
    float posititionDifference = 0;
    if ( ![self.scene childNodeWithName:@"spaceBackground"] )
        posititionDifference = self.scene.size.height;
    
    SKTexture * randomSpaceBackground = _nextBackground;
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
    
    [self preloadNextBackground];
    //NSLog(@"play song for background : %@", randomTextureKey);
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
