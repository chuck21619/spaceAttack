//
//  HighScoresAchievementsViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 9/5/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "HighScoresAchievementsViewController.h"
#import "AudioManager.h"
#import "AccountManager.h"
#import "DGActivityIndicatorView.h"
#import <GameKit/GameKit.h>

@implementation HighScoresAchievementsViewController
{
    DGActivityIndicatorView * _activityIndicator;
    UIView * _activityIndicatorBackground;
    
    //high scores
    GKLeaderboard * _leaderboard;
    NSArray * _scores;
    
    //achievements
    NSArray * _achievements;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showProgressHud:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    [self loadLeaderboard];
    
    _achievements = [AccountManager achievements];
    [self refreshAchievementsView];
}

- (void) viewWillAppear:(BOOL)animated
{
    for ( UIView * subview in [self.view subviews] )
    {
        if ( subview.tag != 10 ) //10 is the background image
            subview.alpha = 0;
    }
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
                subview.alpha = 1;
    }];
}

- (IBAction)backAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuBackButton];
    [UIView animateWithDuration:.2 animations:^
     {
         for ( UIView * subview in [self.view subviews] )
         {
             if ( subview.tag != 10 ) //10 is the background image
                 subview.alpha = 0;
         }
     }
                     completion:^(BOOL finished)
     {
         [self dismissViewControllerAnimated:NO completion:nil];
     }];
}

- (void) showProgressHud:(BOOL)show
{
    if ( show )
    {
        if ( ! _activityIndicatorBackground )
        {
            _activityIndicatorBackground = [[UIView alloc] initWithFrame:self.view.frame];
            _activityIndicatorBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
        }
        if ( ! _activityIndicator )
        {
            _activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:[UIColor whiteColor] size:self.view.frame.size.width/6.4];
            _activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
        }
        
        _activityIndicatorBackground.alpha = 0;
        [_activityIndicatorBackground addSubview:_activityIndicator];
        [self.view addSubview:_activityIndicatorBackground];
        [_activityIndicator startAnimating];
        [UIView animateWithDuration:.2 animations:^
         {
             _activityIndicatorBackground.alpha = 1;
         }];
    }
    else
    {
        [UIView animateWithDuration:.2 animations:^
         {
             _activityIndicatorBackground.alpha = 0;
         }
                         completion:^(BOOL finished)
         {
             [_activityIndicator stopAnimating];
         }];
    }
}

#pragma mark - achievements
- (void) achievementsLoaded
{
    _achievements = [AccountManager achievements];
    [self refreshAchievementsView];
}

- (void) refreshAchievementsView
{
    NSLog(@"refresh achievements view");
    NSLog(@"achievements : %@", _achievements);
}

#pragma mark - leaderboards
- (void) loadLeaderboard
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray<GKLeaderboard *> * _Nullable leaderboards, NSError * _Nullable error)
    {
        _leaderboard = [leaderboards firstObject];
        [_leaderboard loadScoresWithCompletionHandler:^(NSArray<GKScore *> * _Nullable scores, NSError * _Nullable error)
        {
            _scores = scores;
            [self refreshLeaderboardView];
            [self showProgressHud:NO];
        }];
    }];
}

- (void) refreshLeaderboardView
{
    NSLog(@"refresh leaderboard view : %@\n%@", _leaderboard, _scores);
}

@end
