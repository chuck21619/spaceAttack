//
//  GlowingButton.m
//  SpaceAttack
//
//  Created by charles johnston on 8/14/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "GlowingButton.h"
#import "SpriteAppDelegate.h"

@implementation GlowingButton

- (void) didMoveToWindow
{
    //idk why the initwithdecoder method does not successfully add the glow
    [_AppDelegate addGlowToLayer:self.layer withColor:self.currentTitleColor.CGColor];
}

- (void) setTitleColor:(UIColor *)color forState:(UIControlState)state
{
    [super setTitleColor:color forState:state];
    [_AppDelegate addGlowToLayer:self.layer withColor:color.CGColor];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ( self.layer.borderWidth )
    {
        CABasicAnimation * color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        color.duration = .08;
        color.fromValue = (id)self.currentTitleColor.CGColor;
        color.toValue   = (id)[UIColor clearColor].CGColor;
        self.layer.borderColor = [UIColor clearColor].CGColor;
        [self.layer addAnimation:color forKey:@"color"];
    }
    else
    {
        [UIView animateWithDuration:.08 animations:^
        {
            self.titleLabel.alpha = .5;
        }];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ( self.layer.borderWidth )
    {
        CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        color.duration = .08;
        color.fromValue = (id)[UIColor clearColor].CGColor;
        color.toValue   = (id)self.currentTitleColor.CGColor;
        self.layer.borderColor = self.currentTitleColor.CGColor;
        [self.layer addAnimation:color forKey:@"color"];
    }
    else
    {
        [UIView animateWithDuration:.08 animations:^
        {
            self.titleLabel.alpha = 1;
        }];
    }
    
    [super touchesEnded:touches withEvent:event];
}

@end
