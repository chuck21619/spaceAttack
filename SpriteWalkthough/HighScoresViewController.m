//
//  HighScoresViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 9/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "HighScoresViewController.h"
#import "DGActivityIndicatorView.h"
#import "AccountManager.h"
#import <GameKit/GameKit.h>
#import "HighScoreCell.h"
#import "SAAlertView.h"
#import "AudioManager.h"
#import "AccountManager.h"

@implementation HighScoresViewController
{
    DGActivityIndicatorView * _activityIndicator;
    UIView * _activityIndicatorBackground;
    
    //high scores
    NSArray * _scores;
    GKScore * _localPlayerScore;
    
    BOOL _alreadyAppeared;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userScoreLabel.alpha = 0;
    self.userNameLabel.alpha = 0;
    self.userRankLabel.alpha = 0;
    
    _alreadyAppeared = NO;
    
    [self showProgressHud:YES];
    [self loadLeaderboard];
    
    self.backButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.backButton.titleLabel.font.pointSize];
    self.highScoresTitleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:self.highScoresTitleLabel.font.pointSize];
    self.userRankLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:self.highScoresTitleLabel.font.pointSize];
    self.userNameLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:self.userNameLabel.font.pointSize];
    self.userScoreLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:self.userScoreLabel.font.pointSize];
    
    [self adjustForDeviceSize];
    [self.view layoutIfNeeded];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.tableViewContainerForGradientMask.bounds;
    gradient.colors = [NSArray arrayWithObjects:
                       (__bridge id)UIColor.clearColor.CGColor,
                       UIColor.whiteColor.CGColor,
                       UIColor.whiteColor.CGColor,
                       UIColor.clearColor.CGColor,
                       nil];
    gradient.locations = [NSArray arrayWithObjects:
                          [NSNumber numberWithFloat:0],
                          [NSNumber numberWithFloat:1.0/16],
                          [NSNumber numberWithFloat:15.0/16],
                          [NSNumber numberWithFloat:1],
                          nil];
    self.tableViewContainerForGradientMask.layer.mask = gradient;
    
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    self.constraintTrailingBackButton.constant = width* 0.66875;
    
    self.constraintTopTableContainer.constant = width* 0.00625;
    self.constraintLeadingTableContainer.constant = width* 0.0625;
    self.constraintTrailingTableContainer.constant = width* 0.028125;
    self.constraintBottomTableContainer.constant = width* 0.365625;
    
    self.constraintWidthUserRank.constant = width* 0.378125;
    self.constraintBottomUserRank.constant = width* 0.0875;
    
    self.constraintTopUserName.constant = width* 0.078125;
    self.constraintLeadingUserName.constant = width* 0.025;
    self.constraintBottomUserName.constant = width* 0.171875;
    
    self.constraintTopUserScore.constant = width* 0.1875;
    self.constraintBottomUserScore.constant = width* 0.1125;
    
    self.constraintHeightPageControl.constant = width* 0.103125;
    
    
    self.userScoreLabel.font = [self.userScoreLabel.font fontWithSize:width*0.05625];
    self.userNameLabel.font = [self.userNameLabel.font fontWithSize:width*0.075];
    self.userRankLabel.font = [self.userRankLabel.font fontWithSize:width*0.15625];
    self.highScoresTitleLabel.font = [self.highScoresTitleLabel.font fontWithSize:width*0.0875];
    [self.backButton.titleLabel setFont:[self.backButton.titleLabel.font fontWithSize:width*.044]];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ( !_alreadyAppeared )
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
        [UIView animateWithDuration:.2 animations:^
        {
            for ( UIView * subview in [self.view subviews] )
            {
                if ( subview.tag == 9 )
                {
                    subview.alpha = .1;
                    continue;
                }
                
                if ( ! _localPlayerScore )
                {
                    if ( subview == self.userRankLabel ||
                         subview == self.userNameLabel ||
                         subview == self.userScoreLabel )
                        continue;
                }
                
                subview.alpha = 1;
            }
        }];
        
        _alreadyAppeared = YES;
    }
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

- (void) loadLeaderboard
{
    [GKLeaderboard loadLeaderboardsWithCompletionHandler:^(NSArray<GKLeaderboard *> * _Nullable leaderboards, NSError * _Nullable error)
     {
         if ( error )
         {
             NSLog(@"error 1 : %@", error);
             [self showProgressHud:NO];
             [self displayError:error];
             return;
         }
         
         GKLeaderboard * leaderboard = [leaderboards firstObject];
         [leaderboard loadScoresWithCompletionHandler:^(NSArray<GKScore *> * _Nullable scores, NSError * _Nullable error2)
          {
              if ( error2 )
              {
                  NSLog(@"error 2 : %@", error);
                  [self showProgressHud:NO];
                  [self displayError:error2];
                  return;
              }
              
              _localPlayerScore = [leaderboard localPlayerScore];
              _scores = scores;
              [self refreshLeaderboardView];
              [self showProgressHud:NO];
          }];
     }];
}

- (void) refreshLeaderboardView
{
    [self.highScoresTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.userRankLabel.text = [numberFormatter stringFromNumber:@((int)_localPlayerScore.rank)];
    self.userScoreLabel.text = [numberFormatter stringFromNumber:@((int)_localPlayerScore.value)];
    
    if ( (int)_localPlayerScore.value > [AccountManager personalBest] )
        [AccountManager setPersonalBest:(int)_localPlayerScore.value];
    
    [UIView animateWithDuration:.3 animations:^
    {
        self.userScoreLabel.alpha = 1;
        self.userNameLabel.alpha = 1;
        self.userRankLabel.alpha = 1;
    }];
}

- (IBAction)backAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuBackButton];
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)pageControlAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"turnPageToAchievements" object:nil];
}

- (void) displayError:(NSError *)error
{
    SAAlertView * unlockAlert;
    
    if ( error.code == 6 ) // localPlayer is not authenticated
    {
        unlockAlert = [[SAAlertView alloc] initWithTitle:NSLocalizedString(@"Unavailable", nil) message:NSLocalizedString(@"You are not signed into Game Center", nil) cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitle:NSLocalizedString(@"Sign In", nil)];
                unlockAlert.otherButtonAction = ^
                {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"gamecenter:"]];
                };
    }
    else
        unlockAlert = [[SAAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitle:nil];
    
    
    [self showProgressHud:NO];
    [unlockAlert show];
}

#pragma mark - table view delegate/datasource
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float width = self.view.frame.size.width;
    return width*0.34375;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _scores.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HighScoreCell * cell = [tableView dequeueReusableCellWithIdentifier:@"highScoreCell"];
    [cell updateContentWithScore:[_scores objectAtIndex:indexPath.row]];
    return cell;
}

@end
