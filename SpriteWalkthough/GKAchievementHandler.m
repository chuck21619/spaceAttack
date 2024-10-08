//
//  GKAchievementHandler.m
//
//  Created by Benjamin Borowski on 9/30/10.
//  Copyright 2010 Typeoneerror Studios. All rights reserved.
//  $Id$
//

#import <GameKit/GameKit.h>
#import "GKAchievementHandler.h"
#import "GKAchievementNotification.h"

static GKAchievementHandler *defaultHandler = nil;

#pragma mark -

@interface GKAchievementHandler(private)

- (void)displayNotification:(GKAchievementNotification *)notification;

@end

#pragma mark -

@implementation GKAchievementHandler(private)

- (void)displayNotification:(GKAchievementNotification *)notification
{
    [_topView addSubview:notification];
    [notification animateIn];
}

@end

#pragma mark -

@implementation GKAchievementHandler

@synthesize image=_image;

#pragma mark -

+ (GKAchievementHandler *)defaultHandler
{
    if (!defaultHandler) defaultHandler = [[self alloc] init];
    return defaultHandler;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        _topView = [[UIApplication sharedApplication] keyWindow];
        _queue = [[NSMutableArray alloc] initWithCapacity:0];
        self.image = [UIImage imageNamed:@"gk-icon.png"];
    }
    return self;
}

#pragma mark -

- (void)notifyAchievement:(GKAchievementDescription *)achievement
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    GKAchievementNotification *notification = [[GKAchievementNotification alloc] initWithAchievementDescription:achievement];
    notification.frame = CGRectMake(0, width*-0.176, width, width*0.1733);
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

- (void)notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    GKAchievementNotification *notification = [[GKAchievementNotification alloc] initWithTitle:title andMessage:message];
    notification.frame = CGRectMake(0, width*-0.176, width, width*0.1733);
    notification.handlerDelegate = self;

    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

- (void) notifyAchievementTitle:(NSString *)title andMessage:(NSString *)message image:(UIImage *)image
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    GKAchievementNotification *notification = [[GKAchievementNotification alloc] initWithTitle:title andMessage:message];
    notification.frame = CGRectMake(0, width*-0.176, width, width*0.1733);
    notification.handlerDelegate = self;
    [notification setImage:image];
    
    [_queue addObject:notification];
    if ([_queue count] == 1)
    {
        [self displayNotification:notification];
    }
}

#pragma mark -
#pragma mark GKAchievementHandlerDelegate implementation

- (void)didHideAchievementNotification:(GKAchievementNotification *)notification
{
    [_queue removeObjectAtIndex:0];
    if ([_queue count])
    {
        [self displayNotification:(GKAchievementNotification *)[_queue objectAtIndex:0]];
    }
}

@end
