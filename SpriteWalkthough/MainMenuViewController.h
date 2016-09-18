//
//  MainMenuViewController.h
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameplayControls.h"
#import <GameKit/GameKit.h>
@import CoreMotion;


@interface MainMenuViewController : UIViewController <GKGameCenterControllerDelegate>

@property (nonatomic) GameplayControls * sharedGameplayControls;

@property (weak, nonatomic) IBOutlet UILabel *spaceAttackLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIImageView *playBadge;
- (IBAction)playAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *upgradesButton;
@property (weak, nonatomic) IBOutlet UIImageView *upgradesBadge;
- (IBAction)upgradesAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *highScoresAchievementsButton;
- (IBAction)highScoresAchievementsAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingSettings;
- (IBAction)settingsAction:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *zinStudioButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingZinStudio;
- (IBAction)zinStudioAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingPlanet1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingPlanet1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopPlanet1;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingPlanet2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopPlanet2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingPlanet2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopPlanet3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingPlanet3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingPlanet3;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingBadge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopBadge;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBadge;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingBadgeStart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopBadgeStart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBadgeStart;


@end
