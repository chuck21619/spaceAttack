//
//  SAAlertView.m
//  SpaceAttack
//
//  Created by charles johnston on 7/31/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "SAAlertView.h"

@implementation SAAlertView

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitle:(NSString *)otherButtonTitle
{
    if ( self = [super initWithTitle:title message:message cancelButtonTitle:cancelButtonTitle otherButtonTitle:otherButtonTitle] )
    {
        self.titleLabel.numberOfLines = 2;
        self.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
        self.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
        self.appearTime = .4;
        self.disappearTime = .4;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.messageLabel.textColor = [UIColor whiteColor];
        [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}


@end
