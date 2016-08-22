//
//  MainMenuBackgroundScene.h
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@interface MenuBackgroundScene : SKScene

+ (MenuBackgroundScene *) sharedInstance;
@property (nonatomic) BOOL contentCreated;



@end
