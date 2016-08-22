//
//  PowerUp.h
//  SpaceAttack
//
//  Created by charles johnston on 8/10/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "SASpriteNode.h"
#import "EnumTypes.h"

@interface PowerUp : SASpriteNode

- (id) initWithPowerUpType:(PowerUpType)powerUpType;
@property (nonatomic) PowerUpType powerUpType;

@end
