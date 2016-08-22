//
//  MainMenuBackgroundScene.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "MenuBackgroundScene.h"

@implementation MenuBackgroundScene

static MenuBackgroundScene * sharedMenuBackgroundScene = nil;
+ (MenuBackgroundScene *) sharedInstance
{
    if ( sharedMenuBackgroundScene == nil )
    {
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        sharedMenuBackgroundScene = [[MenuBackgroundScene alloc] initWithSize:screenSize];
    }
    
    return sharedMenuBackgroundScene;
}

- (void) didMoveToView:(SKView *)view
{
    if ( !self.contentCreated )
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void) createSceneContents
{
    //self.backgroundColor = [SKColor colorWithRed:160.0/255.0 green:46.0/255.0 blue:128.0/255.0 alpha:1];
    
    //SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed:@"Black Star.png"];
    SKSpriteNode * background = [SKSpriteNode spriteNodeWithImageNamed:@"menuBackground.png"];
    background.size = CGSizeMake(self.size.width, self.size.height);
    //background.blendMode = SKBlendModeScreen;
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:background];
    
    
//    SKSpriteNode * tmpPlanet1 = [[SKSpriteNode alloc] initWithImageNamed:@"menuPlanet.png"];
//    SKSpriteNode * tmpPlanet2 = [[SKSpriteNode alloc] initWithImageNamed:@"menuPlanet.png"];
//    SKSpriteNode * tmpPlanet3 = [[SKSpriteNode alloc] initWithImageNamed:@"menuPlanet.png"];
//    
//    tmpPlanet1.position = CGPointMake(self.size.width * .7, self.size.height * .7);
//    tmpPlanet2.position = CGPointMake(self.size.width * .4, self.size.height * .4);
//    tmpPlanet3.position = CGPointMake(self.size.width * .2, self.size.height * .6);
//    
//    double randomScale = ((double)arc4random() / 0x100000000);
//    [tmpPlanet1 setScale:randomScale*.5];
//    randomScale = ((double)arc4random() / 0x100000000);
//    [tmpPlanet2 setScale:randomScale*.5];
//    randomScale = ((double)arc4random() / 0x100000000);
//    [tmpPlanet3 setScale:randomScale*.5];
//    
//    [self addChild:tmpPlanet1];
//    [self addChild:tmpPlanet2];
//    [self addChild:tmpPlanet3];
//    
//    SKAction * moveDown = [SKAction moveTo:CGPointMake(tmpPlanet1.position.x, -tmpPlanet1.size.height) duration:60];
//    [tmpPlanet1 runAction:moveDown];
//    moveDown = [SKAction moveTo:CGPointMake(tmpPlanet2.position.x, -tmpPlanet2.size.height) duration:60];
//    [tmpPlanet2 runAction:moveDown];
//    moveDown = [SKAction moveTo:CGPointMake(tmpPlanet3.position.x, -tmpPlanet3.size.height) duration:60];
//    [tmpPlanet3 runAction:moveDown];
    
//    SKSpriteNode * planet = [SKSpriteNode spriteNodeWithImageNamed:@"planets2.png"];
//    [background addChild:planet];
//    SKAction * colorize = [SKAction colorizeWithColor:[UIColor greenColor] colorBlendFactor:1 duration:10];
//    
//    [planet runAction:colorize];
//    SKAction * moveDown = [SKAction moveByX:0 y:-100 duration:10];
//    [planet runAction:moveDown];
    
    
    
    
    //pre-jef
    /*
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    NSString * cloudsPath = [[NSBundle mainBundle] pathForResource:@"Clouds" ofType:@"sks"];
    SKEmitterNode * clouds = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudsPath];
    clouds.name = @"clouds";
    clouds.position = CGPointMake(self.size.width/2, self.size.height+300);
    [self addChild:clouds];
    
    NSString * starsPath = [[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"];
    SKEmitterNode * stars = [NSKeyedUnarchiver unarchiveObjectWithFile:starsPath];
    stars.name = @"stars";
    stars.position = CGPointMake(self.size.width/2, self.size.height+20);
    [self addChild:stars];*/
}

@end
