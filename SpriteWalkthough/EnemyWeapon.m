//
//  EnemyWeapon.m
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "EnemyWeapon.h"

@implementation EnemyWeapon

- (id) initWithImageNamed:(NSString *)name
{
    if (self = [super initWithImageNamed:name])
    {
        self.level = 1;
        self.zPosition = 1;
    }
    
    return self;
}

@end
