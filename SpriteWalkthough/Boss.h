//
//  Boss.h
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol bossProtocol <NSObject>
- (void) startFighting;
@end


@interface Boss : SKSpriteNode

- (void) explode;
@property int maxHealth;
@property int health;

@end
