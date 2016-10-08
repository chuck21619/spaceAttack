//
//  ShipSelectionButton.h
//  SpaceAttack
//
//  Created by charles johnston on 8/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Spaceship.h"
#import "GlowingButton.h"

@interface ShipSelectionButton : UIButton

-(void)setupForSpaceship:(Spaceship *)spaceship;
@property Spaceship * spaceship;

-(void)addGlowAnimated;
-(void)refreshContent;

@end
