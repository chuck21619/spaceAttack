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
    
    UILabel * _upgradeTitleLabel;
    
    //minimized content
    CGRect _minimizedFrameLockedIcon;
    
    //maximized content
    SKView * _demoScene;
    UILabel * _upgradeDescription;
    UIButton * _purchaseButtonMoney;
    UIButton * _purchaseButtonPoints;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.heightConstraintView.layer.cornerRadius = self.frame.size.height/3;
    self.heightConstraintView.layer.borderWidth = 1.5;
    self.heightConstraintView.layer.borderColor = [UIColor whiteColor].CGColor;
    [_AppDelegate addGlowToLayer:self.heightConstraintView.layer withColor:[UIColor whiteColor].CGColor];
}


- (void) createContentFromUpgrade:(Upgrade *)upgrade
{
    if ( ! _contentCreated )
    {
        UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.heightConstraint.constant)];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = upgrade.title;
        [self.contentView addSubview:titleLabel];
        [_AppDelegate addGlowToLayer:titleLabel.layer withColor:titleLabel.textColor.CGColor];
        
        //minimized content
        
        //maximized content
        _upgradeDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.frame.size.width, 100)];
        _upgradeDescription.textColor = [UIColor whiteColor];
        _upgradeDescription.font = [UIFont fontWithName:@"Moon-Bold" size:14];
        _upgradeDescription.textAlignment = NSTextAlignmentCenter;
        _upgradeDescription.text = upgrade.upgradeDescription;
        [self.contentView addSubview:_upgradeDescription];
        [_AppDelegate addGlowToLayer:_upgradeDescription.layer withColor:_upgradeDescription.textColor.CGColor];
        _upgradeDescription.alpha = 0;
        
        _contentCreated = YES;
    }
}
//
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
    _upgradeDescription.alpha = alpha;
}

@end
