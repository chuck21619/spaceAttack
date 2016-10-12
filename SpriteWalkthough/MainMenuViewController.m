//
//  MainMenuViewController.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "MainMenuViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "SelectShipViewController.h"
#import "UpgradesViewController.h"
#import "SAAlertView.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SettingsViewController.h"
#import "SpriteAppDelegate.h"

@implementation MainMenuViewController
{
    BOOL _skipNextViewWillAppear;
}

- (void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(skipNextViewWillAppear) name:@"skipNextViewWillAppear" object:nil];
    
    if ( [_AppDelegate hasCustomMainMenuBackground] )
        self.spaceAttackLabel.text = @"";
    else
    {
        self.spaceAttackLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.spaceAttackLabel.font.pointSize];
        [_AppDelegate addGlowToLayer:self.spaceAttackLabel.layer withColor:self.spaceAttackLabel.textColor.CGColor];
    }
    
    self.playButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.playButton.titleLabel.font.pointSize];
    self.highScoresAchievementsButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.highScoresAchievementsButton.titleLabel.font.pointSize];
    self.upgradesButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.upgradesButton.titleLabel.font.pointSize];
    
    self.playButton.titleLabel.numberOfLines = 1;
    self.playButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.playButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.highScoresAchievementsButton.titleLabel.numberOfLines = 1;
    self.highScoresAchievementsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.highScoresAchievementsButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.upgradesButton.titleLabel.numberOfLines = 1;
    self.upgradesButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.upgradesButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [self adjustForDeviceSize];
    
    _skipNextViewWillAppear = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    for ( UIView * subview in [self.view subviews] )
    {
        subview.alpha = 0;
    }
    
    if ( _skipNextViewWillAppear )
    {
        _skipNextViewWillAppear = NO;
        return;
    }

    
    if ( [AccountManager firstLaunch] )
    {
        NSLog(@"main menu first launch");
        
        UIImageView * background = [self.view viewWithTag:10];
        [UIView animateWithDuration:3 animations:^
        {
            background.alpha = 1;
        }
        completion:^(BOOL finished)
        {
            [UIView animateWithDuration:2 animations:^
             {
                 for ( UIView * subview in [self.view subviews] )
                 {
                     if ( subview != self.playBadge && subview != self.upgradesBadge )
                         subview.alpha = 1;
                 }
             }];
        }];
    }
    else
    {
        [UIView animateWithDuration:.2 animations:^
        {
            for ( UIView * subview in [self.view subviews] )
            {
                if ( subview != self.playBadge && subview != self.upgradesBadge )
                    subview.alpha = 1;
            }
        }];
    }
    
    [self authenticateLocalPlayer];
    [self updateButtonColorStatus];
    
    self.playButton.layer.cornerRadius = 20;
    self.playButton.layer.borderColor = [self.playButton.currentTitleColor CGColor];
    self.playButton.layer.borderWidth = 2;
    
    self.highScoresAchievementsButton.layer.cornerRadius = 10;
    self.highScoresAchievementsButton.layer.borderColor = [self.highScoresAchievementsButton.currentTitleColor CGColor];
    self.highScoresAchievementsButton.layer.borderWidth = 2;
    
    self.upgradesButton.layer.cornerRadius = 10;
    self.upgradesButton.layer.borderColor = [self.upgradesButton.currentTitleColor CGColor];
    self.upgradesButton.layer.borderWidth = 2;
    
    [_AppDelegate addGlowToLayer:self.zinStudioButton.layer withColor:self.zinStudioButton.currentTitleColor.CGColor];
    
    [self.settingsButton.imageView setTintColor:_SAPink];
    [self.settingsButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.settingsButton setImage:[[[self.settingsButton imageView] image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    [_AppDelegate addGlowToLayer:self.settingsButton.layer withColor:self.settingsButton.tintColor.CGColor];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) updateButtonColorStatus
{
    if ( [AccountManager enoughGamePointsToUnlockAShip] )
        self.playBadge.alpha = 1;
    else
        self.playBadge.alpha = 0;
    
    if ( [AccountManager enoughGamePointsToUnlockAnUpgrade] )
        self.upgradesBadge.alpha = 1;
    else
        self.upgradesBadge.alpha = 0;
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    [self.spaceAttackLabel setFont:[self.spaceAttackLabel.font fontWithSize:width*.17]];
    [self.playButton.titleLabel setFont:[self.playButton.titleLabel.font fontWithSize:width*.156]];
    [self.highScoresAchievementsButton.titleLabel setFont:[self.highScoresAchievementsButton.titleLabel.font fontWithSize:width*.059]];
    [self.upgradesButton.titleLabel setFont:[self.upgradesButton.titleLabel.font fontWithSize:width*.084]];
    [self.zinStudioButton.titleLabel setFont:[self.zinStudioButton.titleLabel.font fontWithSize:width*.094]];
    
    self.constraintLeadingSettings.constant = width*.872;
    self.constraintTrailingZinStudio.constant = width*.666;
    
    self.constraintLeadingBadge.constant = width*.691;
    self.constraintTopBadge.constant = width*-.05;
    self.constraintTrailingBadge.constant = width*.216;
    
    self.constraintLeadingBadgeStart.constant = width*0.7125;
    self.constraintTopBadgeStart.constant = width*-0.046875;
    self.constraintTrailingBadgeStart.constant = width*0.19375;
    
    self.constraintLeadingPlay.constant = width*0.128125;
    self.constraintTrailingPlay.constant = width*0.128125;
}

- (void) skipNextViewWillAppear
{
    _skipNextViewWillAppear = YES;
}

#pragma mark - game center
- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    self.view.alpha = 0;
    [UIView animateWithDuration:.6 animations:^
    {
        gameCenterViewController.view.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [gameCenterViewController dismissViewControllerAnimated:NO completion:^
        {
            [UIView animateWithDuration:.2 animations:^
            {
                self.view.alpha = 1;
            }];
        }];
    }];
}



- (void) authenticateLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __weak typeof(localPlayer) weaklocalPlayer = localPlayer;
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if ( error )
            NSLog(@"error : %@", error);
        
        if (viewController != nil)
        {
            NSLog(@"device does not have an authenticated game center player");
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else if (weaklocalPlayer.isAuthenticated)
        {
            NSLog(@"game center authenticated");
            if ( ! [weaklocalPlayer.playerID isEqualToString:[AccountManager lastPlayerLoggedIn]] )
            {
                NSLog(@"   last player id : %@", [AccountManager lastPlayerLoggedIn]);
                NSLog(@"current player id : %@", weaklocalPlayer.playerID);
                NSLog(@"new player - clearing player progress");
                [AccountManager clearPlayerProgress];
            }
            
            [AccountManager setLastPlayerLoggedIn:weaklocalPlayer.playerID];
            
//#warning uncomment for release builds
            [AccountManager loadAchievements];
        }
        else
            NSLog(@"game center authentication process failed");
    };
}


- (void) achievementsLoaded
{
    [self updateButtonColorStatus];
}


#pragma mark - buttons
- (IBAction)playAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuSelectShip];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SelectShipViewController * ssvc = [storyboard instantiateViewControllerWithIdentifier:@"selectShipViewController"];
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
        [self presentViewController:ssvc animated:NO completion:nil];
    }];
}

- (IBAction)upgradesAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUpgrade];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpgradesViewController * upgradesVC = [storyboard instantiateViewControllerWithIdentifier:@"upgradesViewController"];
    [upgradesVC view]; //preloads the view
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self presentViewController:upgradesVC animated:NO completion:nil];
    }];
}

- (IBAction)highScoresAchievementsAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuHighScoreAchievements];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpgradesViewController * upgradesVC = [storyboard instantiateViewControllerWithIdentifier:@"gameCenterPageVC"];
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self presentViewController:upgradesVC animated:NO completion:nil];
    }];
}

- (IBAction)settingsAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuSettings];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingsViewController * settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self presentViewController:settingsVC animated:NO completion:nil];
    }];
}

#pragma mark weblink
- (IBAction)zinStudioAction:(id)sender
{
    NSURL * zinStudioUrl = [NSURL URLWithString:@"http://zin.studio"];
    [[UIApplication sharedApplication] openURL:zinStudioUrl];
}

@end
