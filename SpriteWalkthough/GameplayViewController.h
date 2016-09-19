//
//  GameplayViewController.h
//  SpaceAttack
//
//  Created by chuck johnston on 2/22/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpaceshipKit.h"
#import "GameplayControls.h"
#import "SpaceshipScene.h"
#import "DGActivityIndicatorView.h"
#import "GlowingButton.h"
@import GoogleMobileAds;

@interface GameplayViewController : UIViewController <GADBannerViewDelegate, GADInterstitialDelegate, SpaceshipSceneDelegate>

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@property (weak, nonatomic) IBOutlet SKView *mySKView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mySKViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mySKViewBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bannerViewHeightConstraint;
@property (nonatomic) SpaceshipScene * spaceshipScene;
@property (nonatomic) GameplayControls * sharedGameplayControls;
@property (nonatomic) UIView * blackTransitionScreen;
@property (nonatomic) Spaceship * spaceshipForScene;
@property (nonatomic) GADRequest * bannerAdRequest;
@property (nonatomic) BOOL fullScreenAdShown;
@property (nonatomic) BOOL firstViewWillAppear;
@property (nonatomic) BOOL displayGoMessage;

@property (weak, nonatomic) IBOutlet UILabel *gameOverLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UITextView *bonusPointsTextView;
@property (weak, nonatomic) IBOutlet GlowingButton *restartButton;
- (IBAction)restartButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet GlowingButton *selectShipButton;
@property (weak, nonatomic) IBOutlet UIImageView *selectShipBadge;
- (IBAction)selectShipAction:(id)sender;
@property (weak, nonatomic) IBOutlet GlowingButton *upgradesButton;
@property (weak, nonatomic) IBOutlet UIImageView *upgradesBadge;
- (IBAction)upgradesAction:(id)sender;
@property (weak, nonatomic) IBOutlet GlowingButton *homeButton;
- (IBAction)homeAction:(id)sender;

@property (nonatomic) DGActivityIndicatorView * activityIndicator;
@property (nonatomic) UIView * activityIndicatorBackground;

@property (nonatomic) float bonusPointsTextViewHeightDefault;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bonusPointsTextViewHeight;
@property (nonatomic) NSMutableArray * achievementsCompletedDuringFlight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomUpgrades;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingUpgrades;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingUpgrades;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomSelectShip;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopHome;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomRestart;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomBonus;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomPoints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightPoints;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomGameOver;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightGameOver;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopBadgeShip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingBadgeShip;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBadgeShip;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopBadgeUpgrades;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingBadgeUpgrades;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBadgeUpgrades;










@end
