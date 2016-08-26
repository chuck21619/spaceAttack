//
//  UpgradeCell.m
//  SpaceAttack
//
//  Created by charles johnston on 8/22/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "UpgradeCell.h"
#import "SpriteAppDelegate.h"

@implementation UpgradeCell
{
    BOOL _contentCreated;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.heightConstraintView.layer.cornerRadius = self.frame.size.height/3;
    self.heightConstraintView.layer.borderWidth = 1.5;
    self.heightConstraintView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_AppDelegate addGlowToLayer:self.heightConstraintView.layer withColor:[UIColor whiteColor].CGColor];
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
        [UIView animateWithDuration:.2 animations:^
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
    //self.upgradeTitleLabel.alpha = alpha;
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
        [UIView animateWithDuration:.2 animations:^
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

- (void) createContentFromUpgrade:(Upgrade *)upgrade
{
    if ( ! _contentCreated )
    {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.heightConstraint.constant)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
        titleLabel.text = upgrade.title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:titleLabel];
        [_AppDelegate addGlowToLayer:titleLabel.layer withColor:titleLabel.textColor.CGColor];
        
        _contentCreated = YES;
    }
}

@end
