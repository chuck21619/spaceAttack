//
//  SAAlertView.m
//  SpaceAttack
//
//  Created by charles johnston on 7/31/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "SAAlertView.h"
#import "SpriteAppDelegate.h"

@implementation SAAlertView

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    if ( self = [super initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle] )
    {
        float width = [[UIScreen mainScreen] bounds].size.width;
        
        self.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.055];
        self.messageLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*0.04];
        self.cancelButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*0.035];
        self.otherButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*0.035];
        
        self.cornerRadius = 0;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.65];
        self.titleLabel.numberOfLines = 2;
        self.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
        self.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
        self.appearTime = .4;
        self.disappearTime = .4;
        self.titleLabel.textColor = _SAPink;
        self.messageLabel.textColor = _SAPink;
        [self.cancelButton setTitleColor:_SAPink forState:UIControlStateNormal];
        [self.otherButton setTitleColor:_SAPink forState:UIControlStateNormal];
        
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}


@end
