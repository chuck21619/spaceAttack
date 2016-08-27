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
    UILabel * _upgradeTitleLabel;
    float _defaultBorderWidth;
    
    //minimized content
    CGRect _minimizedFrameLockedIcon;
    
    //maximized content
    UIButton * _minimizeButton;
    SKView * _demoScene;
    UILabel * _upgradeDescription;
    UIButton * _purchaseButtonMoney;
    UIButton * _purchaseButtonPoints;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _defaultBorderWidth = 1.5;
    
    self.borderView.layer.borderWidth = _defaultBorderWidth;
    self.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.borderView.layer.cornerRadius = self.frame.size.height/3.0;
    [_AppDelegate addGlowToLayer:self.borderView.layer withColor:self.borderView.layer.borderColor];
    //[_AppDelegate addGlowToView:self.borderView withColor:self.borderView.layer.borderColor];
    
    
    _upgradeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    _upgradeTitleLabel.textColor = [UIColor whiteColor];
    _upgradeTitleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
    _upgradeTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_upgradeTitleLabel];
    [_AppDelegate addGlowToLayer:_upgradeTitleLabel.layer withColor:_upgradeTitleLabel.textColor.CGColor];
    
    
    _minimizeButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 73, 0, 80, 55)];
    [_minimizeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_minimizeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_minimizeButton setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 17)];
    [_minimizeButton.titleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:17]];
    [_minimizeButton setTitle:@"X" forState:UIControlStateNormal];
    [_minimizeButton addTarget:self action:@selector(minimizePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_minimizeButton];
    [_AppDelegate addGlowToLayer:_minimizeButton.titleLabel.layer withColor:_minimizeButton.currentTitleColor.CGColor];
    
    _upgradeDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, self.frame.size.width, 100)];
    _upgradeDescription.textColor = [UIColor whiteColor];
    _upgradeDescription.font = [UIFont fontWithName:@"Moon-Bold" size:14];
    _upgradeDescription.textAlignment = NSTextAlignmentCenter;
    _upgradeDescription.numberOfLines = 0;
    [self.contentView addSubview:_upgradeDescription];
    [_AppDelegate addGlowToLayer:_upgradeDescription.layer withColor:_upgradeDescription.textColor.CGColor];
    
    
    [self setMaximizedAlphas:0]; //initial cell will be minimized
}


- (void) createContentFromUpgrade:(Upgrade *)upgrade
{
    _upgradeTitleLabel.text = upgrade.title;
    
    //minimized content

    //maximized content
    _upgradeDescription.text = upgrade.upgradeDescription;
}

- (void) minimizePressed
{
    [self.delegate minimizePressed:self];
}

//- (void) setAlpha:(CGFloat)alpha
//{
//    [super setAlpha:alpha];
//    if ( alpha == 0 )
//        self.heightConstraintView.layer.borderWidth = 0;
//    else
//        self.heightConstraintView.layer.borderWidth = _defaultBorderWidth;
//}

#pragma mark
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

#pragma mark
- (void) setMinimizedAlphas:(float)alpha
{
    //self.upgradeTitleLabel.alpha = alpha;
}

- (void) setMaximizedAlphas:(float)alpha
{
    _minimizeButton.alpha = alpha;
    _upgradeDescription.alpha = alpha;
}

@end
