//
//  EnemyExplosion.m
//  SpaceAttack
//
//  Created by charles johnston on 9/10/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "EnemyExplosion.h"

@implementation EnemyExplosion

- (id)initWithAtlas:(NSArray *)atlas size:(float)size
{
    if ( self = [super initWithTexture:atlas[0]] )
    {
        [self setTexture:nil];
        self.name = @"enemyExplosion";
        self.size = CGSizeMake(size, size);
        [self runAction:[SKAction animateWithTextures:atlas timePerFrame:0.03 resize:NO restore:YES] completion:^
        {
            [self removeFromParent];
        }];
    }
    return self;
}

@end
