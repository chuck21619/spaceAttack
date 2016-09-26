//
//  AchievementsViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 9/24/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "AchievementsViewController.h"
#import "AccountManager.h"
#import "AchievementCell.h"
#import "DGActivityIndicatorView.h"

@implementation AchievementsViewController
{
    DGActivityIndicatorView * _activityIndicator;
    UIView * _activityIndicatorBackground;
    
    NSDictionary * _achievements;
    NSMutableArray * _sortedKeys;
    
    BOOL _alreadyAppeared;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showProgressHud:YES];
    [self loadAchievementDescriptions];
    
    _achievements = [NSMutableDictionary new];
    
    for ( GKAchievement * achievement in [AccountManager achievements] )
    {
        NSMutableDictionary * chievo = [NSMutableDictionary new];
        [chievo setObject:achievement forKey:@"gkAchievement"];
        [chievo setObject:@"" forKey:@"title"];
        [_achievements setValue:chievo forKey:achievement.identifier];
    }
    
    _sortedKeys = [NSMutableArray arrayWithArray:[_achievements allKeys]];
    [_sortedKeys sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    self.backButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.backButton.titleLabel.font.pointSize];
    
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

    [self refreshAchievementsView];
}

- (void) viewWillAppear:(BOOL)animated
{
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
                 
                 subview.alpha = 1;
             }
         }];
        
        _alreadyAppeared = YES;
    }
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    self.constraintTrailingBackButton.constant = width* 0.66875;
    
    self.constraintTopTableContainer.constant = width* 0.00625;
    self.constraintLeadingTableContainer.constant = width* 0.0625;
    self.constraintTrailingTableContainer.constant = width* 0.028125;
    self.constraintBottomTableContainer.constant = width* 0.090625;
    
    self.constraintHeightPageControl.constant = width* 0.103125;
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

- (void) loadAchievementDescriptions
{
    [GKAchievementDescription loadAchievementDescriptionsWithCompletionHandler:^(NSArray<GKAchievementDescription *> * _Nullable descriptions, NSError * _Nullable error)
    {
        for ( GKAchievementDescription * description in descriptions )
            [[_achievements valueForKey:description.identifier] setValue:description.title forKey:@"title"];
        
        [self showProgressHud:NO];
        [self refreshAchievementsView];
    }];
}

- (void) refreshAchievementsView
{
    [self.achievementTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)backAction:(id)sender
{
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"turnPageToHighScores" object:nil];
}

#pragma mark - table view delegate/datasource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _achievements.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AchievementCell * cell = [tableView dequeueReusableCellWithIdentifier:@"achievementCell"];
    
    NSString * achievementIdentifier = [_sortedKeys objectAtIndex:indexPath.row];
    GKAchievement * achievement = [[_achievements valueForKey:achievementIdentifier] valueForKey:@"gkAchievement"];
    NSString * description = [[_achievements valueForKey:achievementIdentifier] valueForKey:@"title"];
    
    [cell updateContentWithAchievement:achievement description:description];
    
    return cell;
}
@end
