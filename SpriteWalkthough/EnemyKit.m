//
//  EnemyKit.m
//  SpriteWalkthough
//
//  Created by chuck on 6/16/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "EnemyKit.h"
#import "SpaceshipScene.h"

@implementation EnemyKit

static EnemyKit * sharedEnemyKit = nil;
+ (EnemyKit *)sharedInstanceWithScene:(SKScene *)scene
{
    if ( sharedEnemyKit == nil )
    {
        sharedEnemyKit = [[EnemyKit alloc] init];
    }
    
    if ( scene )
        sharedEnemyKit.scene = scene;
    
    return sharedEnemyKit;
}

- (instancetype) init
{
    if ( self = [super init] )
    {
        self.enemyTextureBasic = [SKTexture textureWithImageNamed:@"enemyBasic.png"];
        self.enemyTextureFast = [SKTexture textureWithImageNamed:@"enemyFast.png"];
        self.enemyTextureBig = [SKTexture textureWithImageNamed:@"enemyBig.png"];
        
        self.explosionFrames = @[[SKTexture textureWithImageNamed:@"EnemyExplosion1.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion2.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion3.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion4.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion5.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion6.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion7.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion8.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion9.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion10.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion11.png"],
                                 [SKTexture textureWithImageNamed:@"EnemyExplosion12.png"]];
    }
    return self;
}

- (NSArray *) texturesForPreloading
{
    NSMutableArray * texturesForPreloading = [NSMutableArray new];
    
    [texturesForPreloading addObject:self.enemyTextureBasic];
    [texturesForPreloading addObject:self.enemyTextureFast];
    [texturesForPreloading addObject:self.enemyTextureBig];
    [texturesForPreloading addObjectsFromArray:self.explosionFrames];
    
    return texturesForPreloading;
}

- (NSArray *) addEnemiesBasic:(int)count toScene:(SKScene *)scene withSpeed:(float)enemySpeedCoefficient
{
    EnemyBasic * enemyBasicForReference = [[EnemyBasic alloc] initWithTexture:self.enemyTextureBasic];
    
    int enemySpacingX = enemyBasicForReference.size.width * .5;
    int maxNumberOfEnemies = scene.size.width/enemySpacingX;
    if ( count > maxNumberOfEnemies )
        count = maxNumberOfEnemies;
    int widthOfGroup = (enemyBasicForReference.size.width + enemySpacingX) * count;
    int rangeOfFirstShipXposition = scene.size.width - widthOfGroup;
    float firstShipXposition = skRand(0, rangeOfFirstShipXposition) + enemyBasicForReference.size.width/2;
    
    NSMutableArray * allEnemies = [NSMutableArray new];
    for ( int i = 0; i < count; i++ )
    {
        EnemyBasic * tmpEnemyBasic = [[EnemyBasic alloc] initWithTexture:self.enemyTextureBasic];
        [allEnemies addObject:tmpEnemyBasic];
        tmpEnemyBasic.delegate = (id<EnemyDelegate>)scene; //should be either UpgradeScene or SpaceshipScene
        
        int tmpEnemyBasicXposition = ((enemyBasicForReference.size.width + enemySpacingX) * i) + firstShipXposition;
        tmpEnemyBasic.position = CGPointMake(tmpEnemyBasicXposition, scene.size.height + tmpEnemyBasic.size.height);
        
        SKAction * moveDown = [SKAction moveByX:0 y:-(scene.size.height + tmpEnemyBasic.position.y) duration:15*enemySpeedCoefficient];
        
        SKAction * move1 = [SKAction moveByX:0 y:10 duration:.7*enemySpeedCoefficient];
        [move1 setTimingMode:SKActionTimingEaseInEaseOut];
        SKAction * move2 = [SKAction moveByX:0 y:-10 duration:.7*enemySpeedCoefficient];
        [move2 setTimingMode:SKActionTimingEaseInEaseOut];
        SKAction * hover;
        if ( i % 2 == 0 )
            hover = [SKAction repeatActionForever:[SKAction sequence:@[move1, move2]]];
        else
            hover = [SKAction repeatActionForever:[SKAction sequence:@[move2, move1]]];
        
        SKAction * wait = [SKAction waitForDuration:skRand(0, .5)];
        
        [scene addChild:tmpEnemyBasic];
        [tmpEnemyBasic runAction:[SKAction sequence:@[wait, [SKAction group:@[wait, moveDown, hover]]]]];
    }
    
    return allEnemies;
}

- (NSArray *) addEnemiesFast:(int)count toScene:(SKScene *)scene withSpeed:(float)enemySpeedCoefficient
{
    if ( count >= 10 )
        count = 10;
    
    int arcRadius = (scene.size.height/10)/enemySpeedCoefficient;
    
    //zig zag path
    EnemyFast * enemyFastForReference = [[EnemyFast alloc] initWithTexture:self.enemyTextureFast];
    CGMutablePathRef path = CGPathCreateMutable();
    for ( int i = 0; i-1 < (scene.size.height+enemyFastForReference.size.height)/(arcRadius*2); i++ )
    {
        if ( i % 2 == 0 )
            CGPathAddArc(path, NULL, scene.size.width-arcRadius, ((scene.size.height-arcRadius)+enemyFastForReference.size.height)-i*arcRadius*2, arcRadius, M_PI_2, -M_PI_2, true);
        else
            CGPathAddArc(path, NULL, arcRadius, ((scene.size.height-arcRadius)+enemyFastForReference.size.height)-i*arcRadius*2, arcRadius, M_PI_2, -M_PI_2, false);
    }
    
    UIBezierPath * tmpPath = [UIBezierPath bezierPathWithCGPath:path];
    CGAffineTransform mirrorOverXOrigin = CGAffineTransformMakeScale(-1.0f, 1.0f);
    CGAffineTransform translate = CGAffineTransformMakeTranslation(self.scene.size.width, 0);
    [tmpPath applyTransform:mirrorOverXOrigin];
    [tmpPath applyTransform:translate];
    CGPathRef flippedPath = CGPathCreateCopy(tmpPath.CGPath);
    
    CGPathRef randomPath;
    if ( arc4random_uniform(2) )
        randomPath = path;
    else
        randomPath = flippedPath;
    
    NSMutableArray * allEnemies = [NSMutableArray new];
    for ( int i = 0; i < count; i++ )
    {
        UIBezierPath * selectedPath = [UIBezierPath bezierPathWithCGPath:randomPath];
        CGAffineTransform translate = CGAffineTransformMakeTranslation(arc4random_uniform(20), arc4random_uniform(40));
        [selectedPath applyTransform:translate];
        CGPathRef tmpPath = CGPathCreateCopy(selectedPath.CGPath);
        SKAction * tmpFollowLine = [SKAction followPath:tmpPath asOffset:NO orientToPath:YES duration:12*enemySpeedCoefficient];
        
        EnemyFast * tmpEnemyFast = [[EnemyFast alloc] initWithTexture:self.enemyTextureFast];
        [allEnemies addObject:tmpEnemyFast];
        tmpEnemyFast.delegate = (id<EnemyDelegate>)scene; //should be either UpgradeScene or SpaceshipScene
        //initialize it off screen until animation starts
        [tmpEnemyFast setPosition:CGPointMake(0, scene.size.height + tmpEnemyFast.size.height)];
        [scene addChild:tmpEnemyFast];
        
        SKAction * wait = [SKAction waitForDuration:i*((float)arcRadius/150)];
        SKAction * sequence = [SKAction sequence:@[wait, tmpFollowLine]];
        [tmpEnemyFast runAction:sequence];
    }
    
    return allEnemies;
}


- (NSArray *) addEnemiesBig:(int)count toScene:(SKScene *)scene withSpeed:(float)enemySpeedCoefficient
{
    NSMutableArray * allEnemies = [NSMutableArray new];
    for ( int i = 0; i < count; i++ )
    {
        EnemyBig * tmpEnemyBig = [[EnemyBig alloc] initWithTexture:self.enemyTextureBig];
        [allEnemies addObject:tmpEnemyBig];
        tmpEnemyBig.delegate = (id<EnemyDelegate>)scene; //should be either UpgradeScene or SpaceshipScene
        [tmpEnemyBig setPosition:CGPointMake(skRand(tmpEnemyBig.size.width/2, scene.size.width - tmpEnemyBig.size.width/2), scene.size.height + tmpEnemyBig.size.height)];
        
        [scene addChild:tmpEnemyBig];
        
        SKAction * wait = [SKAction waitForDuration:i];
        SKAction * sequence = [SKAction sequence:@[wait, [SKAction moveToY:-tmpEnemyBig.size.height duration:15*enemySpeedCoefficient]]];
        
        [tmpEnemyBig runAction:sequence];
    }
    
    return allEnemies;
}

/*
- (void) addBossToScene:(SpaceshipScene *)scene
{
    Boss1 * tmpBoss = [[Boss1 alloc] init];
    tmpBoss.position = CGPointMake(scene.size.width/2, scene.size.height - tmpBoss.size.height);
    [scene addChild:tmpBoss];
    [tmpBoss startFighting];
}*/


static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

@end
