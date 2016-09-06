//
//  Shield.h
//  SpaceAttack
//
//  Created by charles johnston on 4/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Shield;
@protocol ShieldDelegate <NSObject>
- (void) shieldTookDamage:(Shield *)shield;
- (void) shieldDestroyed:(Shield *)shield;
@end


@interface Shield : SKSpriteNode

@property (nonatomic, weak) id <ShieldDelegate> delegate;
@property (nonatomic) int armor;
- (void) takeDamage;

@end
