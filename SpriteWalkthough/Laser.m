//
//  Laser.m
//  SpriteWalkthough
//
//  Created by chuck on 4/29/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Laser.h"
#import "CategoryBitMasks.h"

@implementation Laser

- (id)initWithAtlas:(NSArray *)atlas
{
    if (self = [super init])
    {
		self = [[Laser alloc] initWithTexture:atlas[0]];
        [self setTexture:nil];
        self.name = @"laser";
        self.anchorPoint = CGPointMake(0.5, 0);
        [self runAction:[SKAction animateWithTextures:atlas timePerFrame:0.03 resize:YES restore:YES] completion:^
        {
            [self removeFromParent];
        }];
    }
    return self;
}

+ (int) baseDamage
{
    return 2;
}

@end
