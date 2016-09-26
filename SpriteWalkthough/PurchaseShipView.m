//
//  PurchaseShipView.m
//  SpaceAttack
//
//  Created by charles johnston on 9/4/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "PurchaseShipView.h"
#import "SpriteAppDelegate.h"
#import "GlowingButton.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SAAlertView.h"
#import <Crashlytics/Crashlytics.h>

@implementation PurchaseShipView
{
    Spaceship * _mySpaceship;
    UILabel * _shipNameLabel;
    UIImageView * _shipImageView;
    GlowingButton * _purchaseButtonMoney;
    GlowingButton * _purchaseButtonPoints;
    UILabel * _availablePoints;
    UILabel * _availablePointsNumber;
    UILabel * _purchasedLabel;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        float width = frame.size.width;
        
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.925];
        
        UIButton * minimizeButton = [[UIButton alloc] initWithFrame:CGRectMake(width - width*.239, 0, width*.261, width*.18)];
        [minimizeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [minimizeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [minimizeButton setContentEdgeInsets:UIEdgeInsetsMake(width*.033, 0, 0, width*.056)];
        [minimizeButton.titleLabel setFont:[UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.056]];
        [minimizeButton setTitle:@"X" forState:UIControlStateNormal];
        [minimizeButton addTarget:self action:@selector(minimizePressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:minimizeButton];
        [_AppDelegate addGlowToLayer:minimizeButton.titleLabel.layer withColor:minimizeButton.currentTitleColor.CGColor];
        
        _shipNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width*.05, width, width*.3)];
        _shipNameLabel.textColor = [UIColor whiteColor];
        _shipNameLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.13];
        _shipNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_shipNameLabel];
        [_AppDelegate addGlowToLayer:_shipNameLabel.layer withColor:_shipNameLabel.textColor.CGColor];
        
        _shipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*.15, width*.3965, width*.7, width*.7)];
        _shipImageView.layer.cornerRadius = _shipImageView.frame.size.width/2;
        _shipImageView.backgroundColor = [UIColor colorWithWhite:0 alpha:.675];
        _shipImageView.contentMode = UIViewContentModeCenter;
        [self addSubview:_shipImageView];
        
        _purchaseButtonMoney = [GlowingButton new];
        _purchaseButtonMoney.frame = CGRectMake(width*.065, width*1.23, width*.37, width*.18);
        _purchaseButtonMoney.layer.cornerRadius = _purchaseButtonMoney.frame.size.height/3.0;
        _purchaseButtonMoney.layer.borderWidth = 1.5;
        _purchaseButtonMoney.layer.borderColor = [UIColor whiteColor].CGColor;
        [_purchaseButtonMoney setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _purchaseButtonMoney.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.04];
        _purchaseButtonMoney.titleLabel.textAlignment = NSTextAlignmentCenter;
        _purchaseButtonMoney.titleLabel.numberOfLines = 0;
        [_purchaseButtonMoney addTarget:self action:@selector(unlockWithMoneyPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_purchaseButtonMoney];
        
        _purchaseButtonPoints = [GlowingButton new];
        _purchaseButtonPoints.frame = CGRectMake(width - width*.435, width*1.23, width*.37, width*.18);
        _purchaseButtonPoints.layer.cornerRadius = _purchaseButtonPoints.frame.size.height/3.0;
        _purchaseButtonPoints.layer.borderWidth = 1.5;
        _purchaseButtonPoints.layer.borderColor = [UIColor whiteColor].CGColor;
        [_purchaseButtonPoints setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _purchaseButtonPoints.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.04];
        _purchaseButtonPoints.titleLabel.textAlignment = NSTextAlignmentCenter;
        _purchaseButtonPoints.titleLabel.numberOfLines = 0;
        [_purchaseButtonPoints addTarget:self action:@selector(unlockWithPointsPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_purchaseButtonPoints];
        
        _availablePoints = [[UILabel alloc] initWithFrame:CGRectMake(0, width*1.44, width, width*.2)];
        _availablePoints.text = NSLocalizedString(@"Available Points", nil);
        _availablePoints.textColor = [UIColor whiteColor];
        _availablePoints.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.07];
        _availablePoints.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_availablePoints];
        [_AppDelegate addGlowToLayer:_availablePoints.layer withColor:_availablePoints.textColor.CGColor];
        
        _availablePointsNumber = [[UILabel alloc] initWithFrame:CGRectMake(0, width*1.6, width, width*.1)];
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        _availablePointsNumber.text = [numberFormatter stringFromNumber:@([AccountManager availablePoints])];
        _availablePointsNumber.textColor = [UIColor whiteColor];
        _availablePointsNumber.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.07];
        _availablePointsNumber.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_availablePointsNumber];
        [_AppDelegate addGlowToLayer:_availablePointsNumber.layer withColor:_availablePointsNumber.textColor.CGColor];
        
        _purchasedLabel = [UILabel new];
        _purchasedLabel.frame = CGRectMake(0, width*1.4, width, width*.212);
        _purchasedLabel.text = NSLocalizedString(@"PURCHASED", nil);
        _purchasedLabel.textColor = [UIColor whiteColor];
        
        _purchasedLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.115];
        //_purchasedLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.115];
        _purchasedLabel.textAlignment = NSTextAlignmentCenter;
        _purchasedLabel.alpha = 0;
        [self addSubview:_purchasedLabel];
        [_AppDelegate addGlowToLayer:_purchasedLabel.layer withColor:_purchasedLabel.textColor.CGColor];
    }
    return self;
}

- (void) updateContentWithSpaceship:(Spaceship *)spaceship
{
    _mySpaceship = spaceship;
    
    if ( [spaceship isUnlocked] )
    {
        _purchaseButtonPoints.alpha = 0;
        _purchaseButtonMoney.alpha = 0;
        _availablePoints.alpha = 0;
        _availablePointsNumber.alpha = 0;
        _purchasedLabel.alpha = 1;
    }
    else
    {
        _purchaseButtonPoints.alpha = 1;
        _purchaseButtonMoney.alpha = 1;
        _availablePoints.alpha = 1;
        _availablePointsNumber.alpha = 1;
        _purchasedLabel.alpha = 0;
    }
    
    [_shipNameLabel setText:NSLocalizedString(NSStringFromClass([spaceship class]), nil)];
    
    float imageScale = _shipImageView.frame.size.width*.7;
    UIImage * image= [self imageWithImage:[UIImage imageNamed:NSStringFromClass([spaceship class])] scaledToSize:CGSizeMake(imageScale, imageScale)];
    [_shipImageView setImage:image];
    
    if ( spaceship.isValidForMoneyPurchase )
    {
        [_purchaseButtonMoney setTitle:[NSString stringWithFormat:@"%@!\n%@", NSLocalizedString(@"Unlock Now", nil), spaceship.priceString] forState:UIControlStateNormal];
        _purchaseButtonMoney.enabled = YES;
    }
    else
    {
        [_purchaseButtonMoney setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Unavailable", nil)] forState:UIControlStateNormal];
        _purchaseButtonMoney.enabled = NO;
    }
    
    NSString * pointsString;
    if ( spaceship.pointsToUnlock > 1000 )
        pointsString = [NSString stringWithFormat:@"%gk", spaceship.pointsToUnlock/1000.0];
    else
        pointsString = [NSString stringWithFormat:@"%i", spaceship.pointsToUnlock];
    
    if ( [AccountManager availablePoints] >= spaceship.pointsToUnlock )
    {
        [_purchaseButtonPoints setTitle:[NSString stringWithFormat:@"%@!\n%@ %@", NSLocalizedString(@"Unlock Now", nil), pointsString, NSLocalizedString(@"points", nil)] forState:UIControlStateNormal];
        _purchaseButtonPoints.enabled = YES;
    }
    else
    {
        [_purchaseButtonPoints setTitle:[NSString stringWithFormat:@"%@ %@\n%@", pointsString, NSLocalizedString(@"points", nil), NSLocalizedString(@"to Unlock", nil)] forState:UIControlStateNormal];
        _purchaseButtonPoints.enabled = NO;
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark
- (void) showPurchasedLabelAnimated:(BOOL)animated
{
    [UIView animateWithDuration:.4 animations:^
    {
        _purchaseButtonPoints.alpha = 0;
        _purchaseButtonMoney.alpha = 0;
        _availablePoints.alpha = 0;
        _availablePointsNumber.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        _purchasedLabel.alpha = 1;
    }];
}

#pragma mark
- (void) unlockWithMoneyPressed
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    [self.delegate purchaseWithMoneyPressed:_mySpaceship];
}

- (void) unlockWithPointsPressed
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@(_mySpaceship.pointsToUnlock)];
    SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@ %@\n%@ %@ %@?", NSLocalizedString(@"Unlock", nil), NSLocalizedString(NSStringFromClass([_mySpaceship class]), nil), NSLocalizedString(@"for", nil),numberString, NSLocalizedString(@"points", nil)] cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitle:NSLocalizedString(@"Unlock", nil)];
    unlockAlert.otherButtonAction = ^
    {
        [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:_mySpaceship.pointsToUnlock]
                             currency:@"game points"
                              success:@YES
                             itemName:_mySpaceship.name
                             itemType:@"Spaceship"
                               itemId:nil
                     customAttributes:@{}];
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuDidUnlock];
        [AccountManager unlockShip:_mySpaceship];
        [AccountManager subtractPoints:_mySpaceship.pointsToUnlock];
        [self showPurchasedLabelAnimated:YES];
        [self.delegate purchasedWithPoints:_mySpaceship];
    };
    [unlockAlert show];
}

- (void) minimizePressed
{
    [self.delegate closeViewPressed];
}

@end
