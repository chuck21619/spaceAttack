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
    CGRect frame = kGKAchievementDefaultSize;
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
    CGRect SAFrame = CGRectMake(0, 0, width, 65);
    
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

        CGRect r1 = kGKAchievementText1;
        CGRect r2 = kGKAchievementText2;

        // create the text label
        UILabel *tTextLabel = [[UILabel alloc] initWithFrame:r1];
        tTextLabel.textAlignment = NSTextAlignmentLeft;
        tTextLabel.backgroundColor = [UIColor clearColor];
        tTextLabel.textColor = [UIColor whiteColor];
        tTextLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:20];
        tTextLabel.text = NSLocalizedString(@"Achievement Unlocked", @"Achievemnt Unlocked Message");
        self.textLabel = tTextLabel;
        
        // detail label
        UILabel *tDetailLabel = [[UILabel alloc] initWithFrame:r2];
        tDetailLabel.textAlignment = NSTextAlignmentCenter;
        tDetailLabel.adjustsFontSizeToFitWidth = YES;
        tDetailLabel.minimumScaleFactor = 10.0f/15.0f;
        tDetailLabel.backgroundColor = [UIColor clearColor];
        tDetailLabel.textColor = [UIColor whiteColor];
        tDetailLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:11.0f];
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
    NSLog(@"dealloc: GKAchievementNotification");
    
    self.handlerDelegate = nil;
    self.logo = nil;
}


#pragma mark -

- (void)animateIn
{
    [self delegateCallback:@selector(willShowAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kGKAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationInDidStop:finished:context:)];
    self.frame = kGKAchievementFrameEnd;
    [UIView commitAnimations];
}

- (void)animateOut
{
    [self delegateCallback:@selector(willHideAchievementNotification:) withObject:self];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kGKAchievementAnimeTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDidStopSelector:@selector(animationOutDidStop:finished:context:)];
    self.frame = kGKAchievementFrameStart;
    [UIView commitAnimations];
}

- (void)setImage:(UIImage *)image
{
    if (image)
    {
        if (!self.logo)
        {
            UIImageView *tLogo = [[UIImageView alloc] initWithFrame:CGRectMake(45, 5, 55, 55)];
            tLogo.contentMode = UIViewContentModeScaleAspectFit;
            self.logo = tLogo;
            [self addSubview:self.logo];
        }
        self.logo.image = image;
        self.textLabel.frame = kGKAchievementText1WLogo;
        self.detailLabel.frame = kGKAchievementText2WLogo;
    }
    else
    {
        if (self.logo)
        {
            [self.logo removeFromSuperview];
        }
        self.textLabel.frame = kGKAchievementText1;
        self.detailLabel.frame = kGKAchievementText2;
    }
}

@end
