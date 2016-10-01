//
//  GKAchievementNotification.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "GKAchievementNotification.h"

#pragma mark -

@interface GKAchievementNotification(private)

- (void)animationInDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)animationOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
- (void)delegateCallback:(SEL)selector withObject:(id)object;

@end

#pragma mark -

@implementation GKAchievementNotification(private)

- (void)animationInDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self delegateCallback:@selector(didShowAchievementNotification:) withObject:self];
    [self performSelector:@selector(animateOut) withObject:nil afterDelay:kGKAchievementDisplayTime];
}

- (void)animationOutDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self delegateCallback:@selector(didHideAchievementNotification:) withObject:self];
    [self removeFromSuperview];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//code here will ignore the warning
- (void)delegateCallback:(SEL)selector withObject:(id)object
{
    if (self.handlerDelegate)
    {
        if ([self.handlerDelegate respondsToSelector:selector])
        {
            [self.handlerDelegate performSelector:selector withObject:object];
        }
    }
}
#pragma clang diagnostic pop

@end

#pragma mark -

@implementation GKAchievementNotification

@synthesize achievement=_achievement;
@synthesize background=_background;
@synthesize handlerDelegate=_handlerDelegate;
@synthesize detailLabel=_detailLabel;
@synthesize logo=_logo;
@synthesize message=_message;
@synthesize title=_title;
@synthesize textLabel=_textLabel;

#pragma mark -

- (id)initWithAchievementDescription:(GKAchievementDescription *)achievement
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    CGRect frame = CGRectMake(0, 0, width, width*0.1733);
    self.achievement = achievement;
    if ((self = [self initWithFrame:frame]))
    {
    }
    return self;
}

- (id)initWithTitle:(NSString *)title andMessage:(NSString *)message
{
    self.title = title;
    self.message = message;
    
    float width = [UIScreen mainScreen].bounds.size.width;
    CGRect SAFrame = CGRectMake(0, 0, width, width*0.1733);
    
    if ((self = [self initWithFrame:SAFrame]))
    {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        // create the GK background
        UIImageView *tBackground = [[UIImageView alloc] initWithFrame:frame];
        tBackground.image = [UIImage imageNamed:@"menuBackground.png"];
        self.background = tBackground;
        self.background.alpha = .95;
        //self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        
        self.opaque = NO;
        [self addSubview:self.background];

        CGRect r1 = CGRectMake(0, 0, 0, 0);
        CGRect r2 = CGRectMake(0, 0, 0, 0);

        // create the text label
        UILabel *tTextLabel = [[UILabel alloc] initWithFrame:r1];
        tTextLabel.adjustsFontSizeToFitWidth = YES;
        tTextLabel.minimumScaleFactor = .5;
        tTextLabel.textAlignment = NSTextAlignmentLeft;
        tTextLabel.backgroundColor = [UIColor clearColor];
        tTextLabel.textColor = [UIColor whiteColor];
        tTextLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:0.053*frame.size.width];
        tTextLabel.text = NSLocalizedString(@"Achievement Unlocked", @"Achievemnt Unlocked Message");
        self.textLabel = tTextLabel;
        
        // detail label
        UILabel *tDetailLabel = [[UILabel alloc] initWithFrame:r2];
        tDetailLabel.textAlignment = NSTextAlignmentLeft;
        tDetailLabel.adjustsFontSizeToFitWidth = YES;
        tDetailLabel.minimumScaleFactor = 10.0f/15.0f;
        tDetailLabel.backgroundColor = [UIColor clearColor];
        tDetailLabel.textColor = [UIColor whiteColor];
        tDetailLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:0.0373*frame.size.width];
        self.detailLabel = tDetailLabel;

        if (self.achievement)
        {
            self.textLabel.text = self.achievement.title;
            self.detailLabel.text = self.achievement.achievedDescription;
        }
        else
        {
            if (self.title)
            {
                self.textLabel.text = self.title;
            }
            if (self.message)
            {
                self.detailLabel.text = self.message;
            }
        }

        [self addSubview:self.textLabel];
        [self addSubview:self.detailLabel];
    }
    return self;
}

- (void)dealloc
{
    self.handlerDelegate = nil;
    self.logo = nil;
}


#pragma mark -

- (void)animateIn
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    [self delegateCallback:@selector(willShowAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kGKAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationInDidStop:finished:context:)];
    self.frame = CGRectMake(0, 0, width, width*0.1733);
    [UIView commitAnimations];
}

- (void)animateOut
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    [self delegateCallback:@selector(willHideAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kGKAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationOutDidStop:finished:context:)];
    self.frame = CGRectMake(0, width*-0.176, width, width*0.1733);
    [UIView commitAnimations];
}

- (void)setImage:(UIImage *)image
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    if (!self.logo)
    {
        UIImageView *tLogo = [[UIImageView alloc] initWithFrame:CGRectMake(width*0.12, width*0.0133, width*0.1467, width*0.1467)];
        tLogo.contentMode = UIViewContentModeScaleAspectFit;
        self.logo = tLogo;
        [self addSubview:self.logo];
    }
    self.logo.image = image;
    self.textLabel.frame = CGRectMake(width*0.328, width*0.05067, width*0.61067, width*0.05867);
    self.detailLabel.frame = CGRectMake(width*0.328, width*0.096, width*0.6106666667, width*0.05867);
}

@end
