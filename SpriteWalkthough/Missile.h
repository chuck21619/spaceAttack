//
//  Missile.h
//  SpriteWalkthough
//
//  Created by chuck on 4/2/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Missile : SKSpriteNode <NSCopying>

@property (nonatomic) BOOL isLaunched;

- (void) launch;
- (void) update;
- (void) explode;

@end
