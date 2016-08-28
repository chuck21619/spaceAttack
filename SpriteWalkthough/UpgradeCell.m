//
//  UpgradeCell.m
//  SpaceAttack
//
//  Created by charles johnston on 8/22/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "UpgradeCell.h"
#import "SpriteAppDelegate.h"
#import "GlowingButton.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SAAlertView.h"
#import "DGActivityIndicatorView.h"
#import <Crashlytics/Crashlytics.h>

@implementation UpgradeCell
{
    Upgrade * _myUpgrade;
    
    BOOL _framesAdjustedForHeight; //this is becuase we dont have the updated frame size in awakeFromNib
    float _defaultBorderWidth;
    
    UILabel * _upgradeTitleLabel;
    
    //minimized content
    UIImageView * _iconImage;
    UIImageView * _lockOrCheckIcon;
    UILabel * _costLabel;
    UILabel * _pointsNumberLabel;
    UILabel * _pointsLabel;
    
    //maximized content
    UIButton * _minimizeButton;
    DGActivityIndicatorView * _demoLoadingIndicator;
    SKScene * _demoScene;
    SKView * _demoView;
    CGRect _demoViewFrame;
    
    UILabel * _upgradeDescription;
    GlowingButton * _purchaseButtonMoney;
    GlowingButton * _purchaseButtonPoints;
    UILabel * _purchasedLabel;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableWillAnimate) name:kUpgradeTableWillAnimate object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableDidAnimate) name:kUpgradeTableDidAnimate object:nil];
    
    _framesAdjustedForHeight = NO;
    
    _defaultBorderWidth = 1.5;
    
    self.borderView.layer.borderWidth = _defaultBorderWidth;
    self.borderView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.borderView.layer.cornerRadius = self.frame.size.height/3.0;
    [_AppDelegate addGlowToLayer:self.borderView.layer withColor:self.borderView.layer.borderColor];
    
    _upgradeTitleLabel = [UILabel new];
    _upgradeTitleLabel.textColor = [UIColor whiteColor];
    _upgradeTitleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
    _upgradeTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_upgradeTitleLabel];
    [_AppDelegate addGlowToLayer:_upgradeTitleLabel.layer withColor:_upgradeTitleLabel.textColor.CGColor];
    
    //--minimized content
    _iconImage = [UIImageView new];
    _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconImage];
    
    _costLabel = [UILabel new];
    _costLabel.text = @"COST";
    _costLabel.textColor = [UIColor whiteColor];
    _costLabel.font = [UIFont fontWithName:@"Moon-Bold" size:8];
    _costLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_costLabel];
    [_AppDelegate addGlowToLayer:_costLabel.layer withColor:_costLabel.textColor.CGColor];
    
    _pointsNumberLabel = [UILabel new];
    _pointsNumberLabel.textColor = [UIColor whiteColor];
    _pointsNumberLabel.font = [UIFont fontWithName:@"Moon-Bold" size:28];
    _pointsNumberLabel.textAlignment = NSTextAlignmentCenter;
    _pointsNumberLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:_pointsNumberLabel];
    [_AppDelegate addGlowToLayer:_pointsNumberLabel.layer withColor:_pointsNumberLabel.textColor.CGColor];
    
    _pointsLabel = [UILabel new];
    _pointsLabel.text = NSLocalizedString(@"points", nil);
    _pointsLabel.textColor = [UIColor whiteColor];
    _pointsLabel.font = [UIFont fontWithName:@"Moon-Bold" size:8];
    _pointsLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_pointsLabel];
    [_AppDelegate addGlowToLayer:_pointsLabel.layer withColor:_pointsLabel.textColor.CGColor];

    _lockOrCheckIcon = [UIImageView new];
    _lockOrCheckIcon.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_lockOrCheckIcon];
    
    
    //--maximied content
    _minimizeButton = [UIButton new];
    [_minimizeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [_minimizeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [_minimizeButton setContentEdgeInsets:UIEdgeInsetsMake(10, 0, 0, 17)];
    [_minimizeButton.titleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:17]];
    [_minimizeButton setTitle:@"X" forState:UIControlStateNormal];
    [_minimizeButton addTarget:self action:@selector(minimizePressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_minimizeButton];
    [_AppDelegate addGlowToLayer:_minimizeButton.titleLabel.layer withColor:_minimizeButton.currentTitleColor.CGColor];
    
    _demoLoadingIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:[UIColor whiteColor] size:35];
    [self.contentView addSubview:_demoLoadingIndicator];
    
    _upgradeDescription = [UILabel new];
    _upgradeDescription.textColor = [UIColor whiteColor];
    _upgradeDescription.font = [UIFont fontWithName:@"Moon-Bold" size:14];
    _upgradeDescription.textAlignment = NSTextAlignmentCenter;
    _upgradeDescription.numberOfLines = 0;
    [self.contentView addSubview:_upgradeDescription];
    [_AppDelegate addGlowToLayer:_upgradeDescription.layer withColor:_upgradeDescription.textColor.CGColor];
    
    _purchaseButtonMoney = [GlowingButton new];
    _purchaseButtonMoney.layer.borderWidth = 1.5;
    _purchaseButtonMoney.layer.borderColor = [UIColor whiteColor].CGColor;
    [_purchaseButtonMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _purchaseButtonMoney.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:12];
    _purchaseButtonMoney.titleLabel.textAlignment = NSTextAlignmentCenter;
    _purchaseButtonMoney.titleLabel.numberOfLines = 0;
    [_purchaseButtonMoney addTarget:self action:@selector(unlockWithMoneyPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_purchaseButtonMoney];
    
    _purchaseButtonPoints = [GlowingButton new];
    _purchaseButtonPoints.layer.borderWidth = 1.5;
    _purchaseButtonPoints.layer.borderColor = [UIColor whiteColor].CGColor;
    [_purchaseButtonPoints setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _purchaseButtonPoints.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:12];
    _purchaseButtonPoints.titleLabel.textAlignment = NSTextAlignmentCenter;
    _purchaseButtonPoints.titleLabel.numberOfLines = 0;
    [_purchaseButtonPoints addTarget:self action:@selector(unlockWithPointsPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_purchaseButtonPoints];
    
    _purchasedLabel = [UILabel new];
    _purchasedLabel.text = @"PURCHASED";
    _purchasedLabel.textColor = [UIColor whiteColor];
    _purchasedLabel.font = [UIFont fontWithName:@"Moon-Bold" size:30];
    _purchasedLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_purchasedLabel];
    [_AppDelegate addGlowToLayer:_purchasedLabel.layer withColor:_purchasedLabel.textColor.CGColor];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    if ( ! _framesAdjustedForHeight )
    {
        float width = self.frame.size.width;
        
        self.borderView.layer.cornerRadius = self.frame.size.height/3.0;
        _upgradeTitleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.065];
        _costLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.026];
        _pointsNumberLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.092];
        _pointsLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.026];
        [_minimizeButton setContentEdgeInsets:UIEdgeInsetsMake(width*.033, 0, 0, width*.056)];
        [_minimizeButton.titleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:width*.056]];
        _upgradeDescription.font = [UIFont fontWithName:@"Moon-Bold" size:width*.046];
        _purchaseButtonMoney.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.039];
        _purchaseButtonPoints.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.039];
        _purchasedLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.098];
        
        
        _upgradeTitleLabel.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        _iconImage.frame = CGRectMake(width*.0098, width*.0098, width*.163, width*.163);
        _costLabel.frame = CGRectMake(width*.817, width*.0065, width*.163, width*.033);
        _pointsNumberLabel.frame = CGRectMake(width*.817, width*.033, width*.163, width*.114);
        _pointsLabel.frame = CGRectMake(width*.817, width*.141, width*.163, width*.033);
        _lockOrCheckIcon.frame = CGRectMake(width*.856, width*.033, width*.105, width*.105);
        
        _minimizeButton.frame = CGRectMake(self.frame.size.width - width*.239, 0, width*.261, width*.18);
        _demoViewFrame = CGRectMake((self.frame.size.width - width*.719)/2, width*.245, width*.719, width*.98);
        _demoLoadingIndicator.frame = CGRectMake((self.frame.size.width - width*.163)/2, width*.637, width*.163, width*.163);
        _upgradeDescription.frame = CGRectMake(width*.023, width*1.19, self.frame.size.width-width*.046, width*.327);
        _purchaseButtonMoney.frame = CGRectMake(width*.065, width*1.503, width*.359, width*.212);
        _purchaseButtonMoney.layer.cornerRadius = _purchaseButtonMoney.frame.size.height/3.0;
        _purchaseButtonPoints.frame = CGRectMake(self.frame.size.width - width*.425, width*1.503, width*.359, width*.212);
        _purchaseButtonPoints.layer.cornerRadius = _purchaseButtonPoints.frame.size.height/3.0;
        _purchasedLabel.frame = CGRectMake(0, width*1.503, self.frame.size.width, width*.212);
        
        _framesAdjustedForHeight = YES;
    }
}

- (void) createContentFromUpgrade:(Upgrade *)upgrade
{
    _myUpgrade = upgrade;
    
    if ( upgrade.upgradeType == kUpgrade4Weapons )
    {
        int numberOfUnlockedUpgrades = 0;
        for ( Upgrade * tmpUpgrade in [AccountManager sharedInstance].upgrades )
        {
            if ( tmpUpgrade.isUnlocked )
                numberOfUnlockedUpgrades++;
        }
        
        if ( numberOfUnlockedUpgrades < 7 )
            _upgradeTitleLabel.text = @"Locked";
        else
            _upgradeTitleLabel.text = upgrade.title;
    }
    else
        _upgradeTitleLabel.text = upgrade.title;
    
    //minimized content
    _iconImage.image = upgrade.icon;
    _pointsNumberLabel.text = [NSString stringWithFormat:@"%iK", _myUpgrade.pointsToUnlock/1000];
    if ( upgrade.isUnlocked )
        _lockOrCheckIcon.image = [UIImage imageNamed:@"Check.png"];
    else
        _lockOrCheckIcon.image = [UIImage imageNamed:@"Lock.png"];

    //maximized content
    _demoScene = [[UpgradeScene alloc] initWithUpgradeType:upgrade.upgradeType];
    _upgradeDescription.text = upgrade.upgradeDescription;
    
    if ( upgrade.isValidForMoneyPurchase )
        [_purchaseButtonMoney setTitle:[NSString stringWithFormat:@"%@!\n%@", NSLocalizedString(@"Unlock Now", nil), upgrade.priceString] forState:UIControlStateNormal];
    else
    {
        [_purchaseButtonMoney setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Unavailable", nil)] forState:UIControlStateNormal];
        _purchaseButtonMoney.enabled = NO;
    }
    
    if ( [AccountManager availablePoints] >= upgrade.pointsToUnlock )
        [_purchaseButtonPoints setTitle:[NSString stringWithFormat:@"%@!\n%ik %@", NSLocalizedString(@"Unlock Now", nil), upgrade.pointsToUnlock/1000, NSLocalizedString(@"points", nil)] forState:UIControlStateNormal];
    else
    {
        [_purchaseButtonPoints setTitle:[NSString stringWithFormat:@"%ik %@\n%@", upgrade.pointsToUnlock/1000, NSLocalizedString(@"points", nil), NSLocalizedString(@"to Unlock", nil)] forState:UIControlStateNormal];
        _purchaseButtonPoints.enabled = NO;
    }
    
    //initial cell will be minimized
    [self showMaximizedContent:NO];
    [self showMinimizedContent:YES];
}

- (void) minimizePressed
{
    [self.delegate minimizePressed:self];
}

- (void) showPurchasedLabelAnimated:(BOOL)animated
{
    if ( animated )
    {
        [UIView animateWithDuration:.3 animations:^
        {
            _purchaseButtonMoney.alpha = 0;
            _purchaseButtonPoints.alpha = 0;
        }
        completion:^(BOOL finished)
        {
            [UIView animateWithDuration:.3 animations:^
            {
                _purchasedLabel.alpha = 1;
            }];
        }];
    }
    else
    {
        _purchaseButtonMoney.alpha = 0;
        _purchaseButtonPoints.alpha = 0;
        _purchasedLabel.alpha = 1;
    }
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark
- (void) tableWillAnimate
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:0];
    animation.duration = .25;
    
    [_borderView.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_upgradeTitleLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_costLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_pointsNumberLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_pointsLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_minimizeButton.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_upgradeDescription.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_purchaseButtonMoney.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_purchaseButtonPoints.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_purchasedLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    
    _borderView.layer.shadowOpacity = 0;
    _upgradeTitleLabel.layer.shadowOpacity = 0;
    _costLabel.layer.shadowOpacity = 0;
    _pointsNumberLabel.layer.shadowOpacity = 0;
    _pointsLabel.layer.shadowOpacity = 0;
    _minimizeButton.layer.shadowOpacity = 0;
    _upgradeDescription.layer.shadowOpacity = 0;
    _purchaseButtonMoney.layer.shadowOpacity = 0;
    _purchaseButtonPoints.layer.shadowOpacity = 0;
    _purchasedLabel.layer.shadowOpacity = 0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animation.duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        _borderView.layer.shadowRadius = 0;
        _upgradeTitleLabel.layer.shadowRadius = 0;
        _costLabel.layer.shadowRadius = 0;
        _pointsNumberLabel.layer.shadowRadius = 0;
        _pointsLabel.layer.shadowRadius = 0;
        _minimizeButton.layer.shadowRadius = 0;
        _upgradeDescription.layer.shadowRadius = 0;
        _purchaseButtonMoney.layer.shadowRadius = 0;
        _purchaseButtonPoints.layer.shadowRadius = 0;
        _purchasedLabel.layer.shadowRadius = 0;
    });
}

- (void) tableDidAnimate
{
    _borderView.layer.shadowRadius = 4.0;
    _upgradeTitleLabel.layer.shadowRadius = 4.0;
    _costLabel.layer.shadowRadius = 4.0;
    _pointsNumberLabel.layer.shadowRadius = 4.0;
    _pointsLabel.layer.shadowRadius = 4.0;
    _minimizeButton.layer.shadowRadius = 4.0;
    _upgradeDescription.layer.shadowRadius = 4.0;
    _purchaseButtonMoney.layer.shadowRadius = 4.0;
    _purchaseButtonPoints.layer.shadowRadius = 4.0;
    _purchasedLabel.layer.shadowRadius = 4.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [_borderView.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_upgradeTitleLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_costLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_pointsNumberLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_pointsLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_minimizeButton.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_upgradeDescription.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_purchaseButtonMoney.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_purchaseButtonPoints.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_purchasedLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
}


#pragma mark
- (void) unlockWithMoneyPressed
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unlock %@\nfor %@?", _myUpgrade.title, _myUpgrade.priceString] cancelButtonTitle:@"Cancel" otherButtonTitle:@"Unlock"];
    unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.95];
    unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
    unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    unlockAlert.otherButtonAction = ^
    {
        [self.delegate purchaseWithMoneyPressed:_myUpgrade];
    };
    [unlockAlert show];
}

- (void) unlockWithPointsPressed
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString * formattedPoints = [formatter stringFromNumber:[NSNumber numberWithInteger:_myUpgrade.pointsToUnlock]];
    
    SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unlock %@\nfor %@ points?", _myUpgrade.title, formattedPoints] cancelButtonTitle:@"Cancel" otherButtonTitle:@"Unlock"];
    unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.95];
    unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
    unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    unlockAlert.otherButtonAction = ^
    {
        [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:_myUpgrade.pointsToUnlock]
                             currency:@"game points"
                              success:@YES
                             itemName:_myUpgrade.title
                             itemType:@"Upgrade"
                               itemId:nil
                     customAttributes:@{}];
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuDidUnlock];
        [AccountManager subtractPoints:_myUpgrade.pointsToUnlock];
        [AccountManager unlockUpgrade:_myUpgrade.upgradeType];
        [self showPurchasedLabelAnimated:YES];
        [self.delegate purchasedWithPoints:_myUpgrade.pointsToUnlock];
    };
    [unlockAlert show];
}


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
            [self showMinimizedContent:show];
        }
        completion:^(BOOL finished)
        {
            if ( completion )
                completion();
        }];
    }
    else
    {
        [self showMinimizedContent:show];
        if ( completion )
            completion();
    }
}

- (void) showMaximizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion
{
    if ( animated )
    {
        if ( show )
        {
            [_minimizeButton setEnabled:NO];
            
            _demoScene = [[UpgradeScene alloc] initWithUpgradeType:_myUpgrade.upgradeType];
            _demoView = [[SKView alloc] initWithFrame:_demoViewFrame];
            [_demoView presentScene:_demoScene];
            _demoView.alpha = 0;
            [self.contentView addSubview:_demoView];
        }
        
        [UIView animateWithDuration:.3 animations:^
        {
            [self showMaximizedContent:show];
        }
        completion:^(BOOL finished)
        {
            if ( !show )
            {
                [_demoView presentScene:nil];
                [_demoView removeFromSuperview];
                _demoScene = nil;
            }
            else
            {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
                {
                    [UIView animateWithDuration:.3 animations:^
                    {
                        _demoLoadingIndicator.alpha = 0;
                        _demoView.alpha = 1;
                    }
                    completion:^(BOOL finished)
                    {
                        [_minimizeButton setEnabled:YES];
                    }];
                });
            }
            
            if ( completion )
                completion();
        }];
    }
    else
    {
        [self showMaximizedContent:show];
        if ( !show )
        {
            [_demoView presentScene:nil];
            [_demoView removeFromSuperview];
        }
        if ( completion )
            completion();
    }
}

#pragma mark
- (void) showMinimizedContent:(BOOL)show
{
    float alpha;
    
    if ( show )
    {
        alpha = 1;
    }
    else
    {
        alpha = 0;
    }
    
    _iconImage.alpha = alpha;
    
    _lockOrCheckIcon.alpha = 0;
    _costLabel.alpha = 0;
    _pointsNumberLabel.alpha = 0;
    _pointsLabel.alpha = 0;
    
    if ( ! _myUpgrade.isUnlocked )
    {
        int numberOfUnlockedUpgrades = 0;
        for ( Upgrade * tmpUpgrade in [AccountManager sharedInstance].upgrades )
        {
            if ( tmpUpgrade.isUnlocked )
                numberOfUnlockedUpgrades++;
        }
        
        if ( _myUpgrade.upgradeType == kUpgrade4Weapons && numberOfUnlockedUpgrades < 7 )
            _lockOrCheckIcon.alpha = alpha;
        else
        {
            if ( _myUpgrade.upgradeType == kUpgrade4Weapons )
                _iconImage.image = [UIImage imageNamed:@"fourWeaponsUpgrade.png"];
            
            _costLabel.alpha = alpha;
            _pointsNumberLabel.alpha = alpha;
            _pointsLabel.alpha = alpha;
        }
    }
    else
    {
        _lockOrCheckIcon.image = [UIImage imageNamed:@"Check.png"];
        _lockOrCheckIcon.alpha = alpha;
    }
}

- (void) showMaximizedContent:(BOOL)show
{
    float alpha;
    
    if ( show )
    {
        alpha = 1;
        
        [_demoLoadingIndicator startAnimating];
        
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = _demoView.bounds;
        maskLayer.shadowRadius = 5;
        maskLayer.shadowPath = CGPathCreateWithRoundedRect(CGRectInset(_demoView.bounds, 10, 10), 10, 10, nil);
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSizeZero;
        maskLayer.shadowColor = [UIColor whiteColor].CGColor;
        
        _demoView.layer.mask = maskLayer;
    }
    else
    {
        alpha = 0;
        
        [_demoLoadingIndicator stopAnimating];
        _demoView.alpha = alpha;
    }
    
    _minimizeButton.alpha = alpha;
    //_demoView.alpha = alpha;
    _upgradeDescription.alpha = alpha;
    _demoLoadingIndicator.alpha = alpha;
    
    _purchasedLabel.alpha = 0;
    _purchaseButtonPoints.alpha = 0;
    _purchaseButtonMoney.alpha = 0;
    
    if ( _myUpgrade.isUnlocked )
    {
        _purchasedLabel.alpha = alpha;
    }
    else
    {
        _purchaseButtonMoney.alpha = alpha;
        _purchaseButtonPoints.alpha = alpha;
    }
}

@end
