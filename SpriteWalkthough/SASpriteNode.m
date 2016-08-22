//
//  SASpriteNode.m
//  SpaceAttack
//
//  Created by charles johnston on 7/23/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "SASpriteNode.h"

@implementation SASpriteNode

@synthesize delegate;

- (void) removeFromParent
{
    [self.delegate SASpriteNodeRemovingFromParent:self];
    [super removeFromParent];
}

@end
