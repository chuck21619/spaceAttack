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

@implementation HighScoresAchievementsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    
    NSLog(@"load game center bullshit");
    NSLog(@"achievements : %@", [AccountManager achievements]);
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

- (void) achievementsLoaded
{
    NSLog(@"achievementsLoaded");
    NSLog(@"achievements : %@", [AccountManager achievements]);
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

@end
