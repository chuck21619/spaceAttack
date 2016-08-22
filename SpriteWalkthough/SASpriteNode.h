//
//  SASpriteNode.h
//  SpaceAttack
//
//  Created by charles johnston on 7/23/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class SASpriteNode;
@protocol SASpriteNodeDelegate <NSObject>
- (void) SASpriteNodeRemovingFromParent:(SASpriteNode *)node;
@end


@interface SASpriteNode : SKSpriteNode

@property (nonatomic, weak) id <SASpriteNodeDelegate> delegate;

@end
