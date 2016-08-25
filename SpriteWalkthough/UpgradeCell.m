//
//  UpgradeCell.m
//  SpaceAttack
//
//  Created by charles johnston on 8/22/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "UpgradeCell.h"

@implementation UpgradeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = self.frame.size.height/3;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) showMinimizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion
{
    float alpha;
    if ( show )
        alpha = 1;
    else
        alpha = 0;
    
    if ( animated )
    {
        [UIView animateWithDuration:.3 animations:^
        {
            [self setMinimizedAlphas:alpha];
        }
        completion:^(BOOL finished)
        {
            if ( completion )
                completion();
        }];
    }
    else
    {
        [self setMinimizedAlphas:alpha];
        if ( completion )
            completion();
    }
}

- (void) setMinimizedAlphas:(float)alpha
{
    self.upgradeTitleLabel.alpha = alpha;
}

- (void) showMaximizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion
{
    float alpha;
    if ( show )
        alpha = 1;
    else
        alpha = 0;
    
    if ( animated )
    {
        [UIView animateWithDuration:.3 animations:^
        {
            [self setMaximizedAlphas:alpha];
        }
        completion:^(BOOL finished)
        {
            if ( completion )
                completion();
        }];
    }
    else
    {
        [self setMaximizedAlphas:alpha];
        if ( completion )
            completion();
    }
}

- (void) setMaximizedAlphas:(float)alpha
{
    //self.demoScene.alpha = alpha;
}

@end
