//
//  HealthBar.m
//  SpaceAttack
//
//  Created by Johnston, Charles on 10/10/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "HealthBar.h"
#import "SpriteAppDelegate.h"

@implementation HealthBar

- (instancetype) initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        self.transform = CGAffineTransformScale(self.transform, 1, frame.size.height);
        [self setProgress:1];
        [self setTintColor:_SAPink];
        [self setTrackTintColor:[UIColor clearColor]];
        self.alpha = .25;
    }
    return self;
}

- (void) setProgress:(float)progress animated:(BOOL)animated
{
    [super setProgress:progress animated:animated];
    
    //flash
    [UIView animateWithDuration:.1 animations:^{
        self.alpha = 1;
    }
    completion:^(BOOL finished)
    {
        [UIView animateWithDuration:.1 animations:^
        {
            self.alpha = .25;
        }];
    }];
}

@end
