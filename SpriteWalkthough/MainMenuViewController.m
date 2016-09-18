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
    BOOL _ignoreNextViewWillAppear;
}

- (void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ignoreViewWillAppearAnimation) name:@"ignoreViewWillAppearAnimation" object:nil];
    [self adjustForDeviceSize];
    _ignoreNextViewWillAppear = NO;
    [_AppDelegate addGlowToLayer:self.spaceAttackLabel.layer withColor:self.spaceAttackLabel.textColor.CGColor];
}

- (void) viewWillAppear:(BOOL)animated
{
    if ( _ignoreNextViewWillAppear )
    {
        _ignoreNextViewWillAppear = NO;
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag ) //10 is the background image
                subview.alpha = 0;
        }
        [UIView animateWithDuration:.2 animations:^
         {
             for ( UIView * subview in [self.view subviews] )
             {
                 if ( subview.tag == 10 )
                     subview.alpha = 1;
             }
         }];
        return;
    }
    
    for ( UIView * subview in [self.view subviews] )
    {
        if ( subview.tag != 10 ) //10 is the background image
            subview.alpha = 0;
    }
    [UIView animateWithDuration:.2 animations:^
     {
         for ( UIView * subview in [self.view subviews] )
         {
             subview.alpha = 1;
         }
     }];
    
    if ( ! [[GKLocalPlayer localPlayer] isAuthenticated] )
        [self.highScoresAchievementsButton setTitleColor:[UIColor colorWithWhite:.5 alpha:1] forState:UIControlStateNormal];
        
//    SKView * spriteView = (SKView *)self.view;
//    spriteView.ignoresSiblingOrder = YES; // improves performance
//    MenuBackgroundScene * backgroundScene = [MenuBackgroundScene sharedInstance];
//    [spriteView presentScene:backgroundScene];
    
    [self authenticateLocalPlayer];
    [self updateButtonColorStatus];
    
    self.playButton.layer.cornerRadius = 20;
    self.playButton.layer.borderColor = [self.playButton.currentTitleColor CGColor];
    self.playButton.layer.borderWidth = 2;
    //[_AppDelegate addGlowToLayer:self.playButton.layer withColor:[self.playButton.currentTitleColor CGColor]];
    //[_AppDelegate addGlowToLayer:self.playButton.titleLabel.layer withColor:[self.playButton.currentTitleColor CGColor]];
    
    self.highScoresAchievementsButton.layer.cornerRadius = 10;
    self.highScoresAchievementsButton.layer.borderColor = [self.highScoresAchievementsButton.currentTitleColor CGColor];
    self.highScoresAchievementsButton.layer.borderWidth = 2;
//    [_AppDelegate addGlowToLayer:self.highScoresAchievementsButton.layer withColor:[self.highScoresAchievementsButton.currentTitleColor CGColor]];
//    [_AppDelegate addGlowToLayer:self.highScoresAchievementsButton.titleLabel.layer withColor:[self.highScoresAchievementsButton.currentTitleColor CGColor]];
    
    self.upgradesButton.layer.cornerRadius = 10;
    self.upgradesButton.layer.borderColor = [self.upgradesButton.currentTitleColor CGColor];
    self.upgradesButton.layer.borderWidth = 2;
//    [_AppDelegate addGlowToLayer:self.upgradesButton.layer withColor:[self.upgradesButton.currentTitleColor CGColor]];
//    [_AppDelegate addGlowToLayer:self.upgradesButton.titleLabel.layer withColor:[self.upgradesButton.currentTitleColor CGColor]];
    
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

- (void) ignoreViewWillAppearAnimation
{
    _ignoreNextViewWillAppear = YES;
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
    
    self.constraintLeadingPlanet1.constant = width*.359;
    self.constraintTopPlanet1.constant = width*.025;
    self.constraintTrailingPlanet1.constant = width*.484;
    
    self.constraintLeadingPlanet2.constant = width*.625;
    self.constraintTopPlanet2.constant = width*.191;
    self.constraintTrailingPlanet2.constant = width*.063;
    
    self.constraintLeadingPlanet3.constant = width*.091;
    self.constraintTopPlanet3.constant = width*.456;
    self.constraintTrailingPlanet3.constant = width*.284;
    
    self.constraintLeadingBadge.constant = width*.691;
    self.constraintTopBadge.constant = width*-.05;
    self.constraintTrailingBadge.constant = width*.216;
    
    self.constraintLeadingBadgeStart.constant = width*0.7125;
    self.constraintTopBadgeStart.constant = width*-0.046875;
    self.constraintTrailingBadgeStart.constant = width*0.19375;
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
            [self.highScoresAchievementsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.highScoresAchievementsButton.layer.borderColor = [self.highScoresAchievementsButton.currentTitleColor CGColor];
//            [_AppDelegate addGlowToLayer:self.highScoresAchievementsButton.layer withColor:[self.highScoresAchievementsButton.currentTitleColor CGColor]];
//            [_AppDelegate addGlowToLayer:self.highScoresAchievementsButton.titleLabel.layer withColor:[self.highScoresAchievementsButton.currentTitleColor CGColor]];
            
//#warning uncomment for release builds
            [AccountManager loadAchievements];
        }
        else
        {
            NSLog(@"game center authentication process failed");
            //[self disableGameCenter];
        }
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
        {
            if ( subview.tag != 10 ) //10 is the background image
                subview.alpha = 0;
        }
        [self presentViewController:ssvc animated:NO completion:^
        {
            self.view.alpha = 1;
        }];
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
        {
            if ( subview.tag != 10 ) //10 is the background image
                subview.alpha = 0;
        }
    }
    completion:^(BOOL finished)
    {
        [self presentViewController:upgradesVC animated:NO completion:^
        {
            for ( UIView * subview in [self.view subviews] )
            {
                subview.alpha = 1;
            }
        }];
    }];
}

- (IBAction)highScoresAchievementsAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuHighScoreAchievements];
    if ( ! [[GKLocalPlayer localPlayer] isAuthenticated] )
    {
#warning localize
        SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:@"Scores Unavailable" message:@"You are not signed into Game Center" cancelButtonTitle:@"Got It" otherButtonTitle:nil];
        unlockAlert.appearTime = .2;
        unlockAlert.disappearTime = .2;
        [unlockAlert show];
        return;
    }
    
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUpgrade];
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UpgradesViewController * upgradesVC = [storyboard instantiateViewControllerWithIdentifier:@"highscoresAchievementsVC"];
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
        [self presentViewController:upgradesVC animated:NO completion:^
        {
            for ( UIView * subview in [self.view subviews] )
                subview.alpha = 1;
        }];
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
        {
            if ( subview.tag != 10 ) //10 is the background image
                subview.alpha = 0;
        }
    }
    completion:^(BOOL finished)
    {
        [self presentViewController:settingsVC animated:NO completion:^
        {
            for ( UIView * subview in [self.view subviews] )
            {
                    subview.alpha = 1;
            }
        }];
    }];
}

#pragma mark weblink
- (IBAction)zinStudioAction:(id)sender
{
    NSURL * zinStudioUrl = [NSURL URLWithString:@"http://zin.studio"];
    [[UIApplication sharedApplication] openURL:zinStudioUrl];
}

@end
