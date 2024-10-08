//
//  GameplayViewController.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/22/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "GameplayViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "AccountManager.h"
#import "FullScreenAdSingleton.h"
#import "AudioManager.h"
#import "PlayerWeaponsKit.h"
#import "SpaceshipKit.h"
#import "PlayerWeaponsKit.h"
#import "MainMenuViewController.h"
#import "SAAlertView.h"
#import "SpriteAppDelegate.h"

@implementation GameplayViewController
{
    UIImageView * _loadingScreenImageView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.gameOverLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.gameOverLabel.font.pointSize];
    self.personalBestLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.personalBestLabel.font.pointSize];
    self.pointsLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.pointsLabel.font.pointSize];
    
    self.restartButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.restartButton.titleLabel.font.pointSize];
    self.selectShipButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.selectShipButton.titleLabel.font.pointSize];
    self.upgradesButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.upgradesButton.titleLabel.font.pointSize];
    self.homeButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.homeButton.titleLabel.font.pointSize];
    
    [self adjustForDeviceSize];
    
    self.mySKView.ignoresSiblingOrder = YES; // improves performance
    
    self.spaceshipScene = [[SpaceshipScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    self.spaceshipScene.customDelegate = self;
    [self.spaceshipScene setMySpaceship:[self.spaceshipForScene copy]];
    
    self.sharedGameplayControls = [GameplayControls sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:@"appDidBecomeActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:@"appWillResignActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementCompleted:) name:@"achievementCompleted" object:nil];
    
    
    _loadingScreenImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    self.achievementsCompletedDuringFlight = [NSMutableArray new];
    self.bonusPointsTextViewHeightDefault = self.bonusPointsTextView.frame.size.height;
    self.bonusPointsTextView.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:12];
    
    self.fullScreenAdShown = NO;
    self.firstViewWillAppear = YES;
    self.displayGoMessage = YES;
    
    self.blackTransitionScreen = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.blackTransitionScreen setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:self.blackTransitionScreen];
    
    self.restartButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.restartButton.layer.borderWidth = 2;
    self.restartButton.layer.cornerRadius = self.restartButton.frame.size.height/3;
    
    self.selectShipButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.selectShipButton.layer.borderWidth = 2;
    self.selectShipButton.layer.cornerRadius = self.selectShipButton.frame.size.height/3;
    
    self.upgradesButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.upgradesButton.layer.borderWidth = 2;
    self.upgradesButton.layer.cornerRadius = self.upgradesButton.frame.size.height/3;
    
    self.homeButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.homeButton.layer.borderWidth = 2;
    self.homeButton.layer.cornerRadius = self.homeButton.frame.size.height/3;
    
    [_AppDelegate addGlowToLayer:self.gameOverLabel.layer withColor:self.gameOverLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.personalBestLabel.layer withColor:self.personalBestLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.pointsLabel.layer withColor:self.pointsLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.bonusPointsTextView.layer withColor:self.bonusPointsTextView.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.restartButton.layer withColor:self.restartButton.currentTitleColor.CGColor];
    [_AppDelegate addGlowToLayer:self.selectShipButton.layer withColor:self.selectShipButton.currentTitleColor.CGColor];
    [_AppDelegate addGlowToLayer:self.upgradesButton.layer withColor:self.upgradesButton.currentTitleColor.CGColor];
    [_AppDelegate addGlowToLayer:self.homeButton.layer withColor:self.homeButton.currentTitleColor.CGColor];

    [self calibrate];
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    [self.gameOverLabel setFont:[self.gameOverLabel.font fontWithSize:width*.156]];
    [self.personalBestLabel setFont:[self.personalBestLabel.font fontWithSize:width*.034]];
    [self.pointsLabel setFont:[self.pointsLabel.font fontWithSize:width*.069]];
    [self.bonusPointsTextView setFont:[self.bonusPointsTextView.font fontWithSize:width*.034]];
    [self.restartButton.titleLabel setFont:[self.restartButton.titleLabel.font fontWithSize:width*.056]];
    [self.selectShipButton.titleLabel setFont:[self.selectShipButton.titleLabel.font fontWithSize:width*.056]];
    [self.upgradesButton.titleLabel setFont:[self.upgradesButton.titleLabel.font fontWithSize:width*.056]];
    [self.homeButton.titleLabel setFont:[self.homeButton.titleLabel.font fontWithSize:width*.056]];
    
    self.constraintBottomUpgrades.constant = width*.75;
    self.constraintLeadingUpgrades.constant = width*.1875;
    self.constraintTrailingUpgrades.constant = width*.1875;
    
    self.constraintBottomSelectShip.constant = width*.028;
    
    self.constraintBottomRestart.constant = width*.025;
    
    self.constraintTopHome.constant = width*.025;
    
    self.constraintBottomBonus.constant = width*-.0156;
    
    self.constraintBottomPoints.constant = width*-.069;
    
    self.constraintHeightPoints.constant = width*.15;
    
    self.constraintBottomGameOver.constant = width*-.031;
    
    self.constraintHeightGameOver.constant = width*.375;
    
    self.constraintTopBadgeShip.constant = width*-.019;
    self.constraintLeadingBadgeShip.constant = width*.656;
    self.constraintTrailingBadgeShip.constant = width*.281;
    
    self.constraintTopBadgeUpgrades.constant = width*-.019;
    self.constraintLeadingBadgeUpgrades.constant = width*.628;
    self.constraintTrailingBadgeUpgrades.constant = width*.309;
    
    self.constraintTopPersonalBest.constant = width*-0.053125;
    self.constraintHeightPersonalBest.constant = width*0.078125;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^
    {
        self.view.alpha = 1;
    }];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( self.firstViewWillAppear )
    {
        self.firstViewWillAppear = NO;
        [self showProgressHud];
    }
}



- (void) calibrate
{
    NSMutableArray * textures = [NSMutableArray new];
    [textures addObjectsFromArray:[[SpaceshipKit sharedInstance] texturesForPreloading:self.spaceshipForScene]];
    [textures addObjectsFromArray:[[EnemyKit sharedInstanceWithScene:nil] texturesForPreloading]];
    [textures addObjectsFromArray:[[SpaceObjectsKit sharedInstanceWithScene:nil] texturesForPreloading]];
    [textures addObjectsFromArray:[[PlayerWeaponsKit sharedInstance] texturesForPreloading]];
    
    NSLog(@"preloading - started");
    [SKTexture preloadTextures:textures withCompletionHandler:^
    {
        NSLog(@"preloading - finished");
    }];
    [self.sharedGameplayControls calibrate:^
    {
        if ( ! self.fullScreenAdShown )
            [self showSpaceshipScene];
    }];
}

- (void) showSpaceshipScene
{
    [self hideProgressHud];
    [self.achievementsCompletedDuringFlight removeAllObjects];

    if ( ![AccountManager shouldShowFullscreenAd] /*[AccountManager shouldShowBannerAds]*/ )
    {
        if ( [AccountManager sharedInstance].firstGameplaySinceLaunch )
        {
            [AccountManager startFullScreenAdTimer];
            [AccountManager sharedInstance].firstGameplaySinceLaunch = NO;
        }
        
        /*if ( self.bannerAdRequest == nil )
        {
            self.bannerView.delegate = self;
            self.bannerAdRequest = [GADRequest request];
            self.bannerAdRequest.testDevices = @[kGADSimulatorID, @"07a7fa85e22c195388c46d2c2f90b457"];
            [self.bannerView loadRequest:self.bannerAdRequest];
         }*/[self hideBannerView];
    }
    else
        [AccountManager startFullScreenAdTimer];
    
    [self.mySKView presentScene:self.spaceshipScene];
    
    [UIView animateWithDuration:.5 animations:^
    {
        self.blackTransitionScreen.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self.blackTransitionScreen removeFromSuperview];
    }];
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void) appWillResignActive
{
    [self.spaceshipScene pauseGame];
}

- (void) appDidBecomeActive
{
    if ( ! self.fullScreenAdShown )
        [self.spaceshipScene resumeGame];
}

- (void) showProgressHud
{
    if ( ! self.activityIndicatorBackground )
    {
        self.activityIndicatorBackground = [[UIView alloc] initWithFrame:self.view.frame];
        self.activityIndicatorBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
        [self.activityIndicatorBackground addSubview:_loadingScreenImageView];
    }
    if ( ! self.activityIndicator )
    {
        self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:[UIColor whiteColor] size:self.view.frame.size.width/10];
        self.activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height - (self.view.frame.size.height/20), 0, 0);
    }
    
    self.activityIndicatorBackground.alpha = 0;
    
    int randomInt = arc4random_uniform(3)+1;
    UIImage * loadingScreenImage = [UIImage imageNamed:[NSString stringWithFormat:@"Loading Screen %i.png", randomInt]];
    _loadingScreenImageView.image = loadingScreenImage;
    
    if ( randomInt == 1 )
        self.activityIndicator.tintColor = [UIColor colorWithRed:235.0/255.0 green:25.0/255.0 blue:10.0/255.0 alpha:.5];
    else if ( randomInt == 2 )
        self.activityIndicator.tintColor = [UIColor colorWithRed:215.0/255.0 green:245.0/255.0 blue:10.0/255.0 alpha:.5];
    else if ( randomInt == 3 )
        self.activityIndicator.tintColor = [UIColor colorWithWhite:0 alpha:.5];
    
    [self.activityIndicatorBackground addSubview:self.activityIndicator];
    [self.view addSubview:self.activityIndicatorBackground];
    [self.activityIndicator startAnimating];
    [UIView animateWithDuration:.33 animations:^
    {
        self.activityIndicatorBackground.alpha = 1;
    }];
}

- (void) hideProgressHud
{
    [UIView animateWithDuration:.2 animations:^
     {
         self.activityIndicatorBackground.alpha = 0;
     }
                     completion:^(BOOL finished)
     {
         [self.activityIndicator stopAnimating];
     }];
}

- (void) hideUIViews
{
    self.mySKView.alpha = 0;
    self.gameOverLabel.alpha = 0;
    self.personalBestLabel.alpha = 0;
    self.pointsLabel.alpha = 0;
    self.restartButton.alpha = 0;
    self.upgradesButton.alpha = 0;
    self.homeButton.alpha = 0;
    self.selectShipButton.alpha = 0;
    self.bonusPointsTextView.alpha = 0;
    self.upgradesBadge.alpha = 0;
    self.selectShipBadge.alpha = 0;
}

#pragma mark - spaceship scene custom delegate
- (void) gameOver:(int)pointsScored
{
    for ( GKAchievement * achievement in self.achievementsCompletedDuringFlight )
    {
        int tmpPoints = [AccountManager bonusPointsForAchievement:[EnumTypes achievementFromIdentifier:achievement.identifier]];
        [AccountManager addPoints:tmpPoints];
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@(pointsScored)];
    self.pointsLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"points", nil), numberString];
    
    [UIView animateWithDuration:1 animations:^
     {
         self.gameOverLabel.alpha = 1;
         self.pointsLabel.alpha = 1;
         if ( pointsScored > [AccountManager personalBest] )
         {
             self.personalBestLabel.alpha = 1;
             [AccountManager setPersonalBest:pointsScored];
         }
     }
     completion:^(BOOL finished)
     {
         if ( self.achievementsCompletedDuringFlight.count )
         {
            [self populateBonusTextView];
            [self showEndScreenButtons:^
            {
                self.bonusPointsTextViewHeight.constant = self.bonusPointsTextViewHeightDefault + (self.achievementsCompletedDuringFlight.count * self.bonusPointsTextView.font.pointSize);
                [UIView animateWithDuration:1 animations:^
                {
                    [self.view layoutIfNeeded];
                    self.bonusPointsTextView.alpha = 1;
                }];
            }];
         }
         else
             [self showEndScreenButtons:nil];
     }];
}

#pragma mark - end game screen
- (void) showEndScreenButtons:(void (^)())completion
{
    [UIView animateWithDuration:1 animations:^
    {
        self.restartButton.alpha = 1;
        self.upgradesButton.alpha = 1;
        self.selectShipButton.alpha = 1;
        self.homeButton.alpha = 1;
        
        if ( [AccountManager enoughGamePointsToUnlockAShip] )
            self.selectShipBadge.alpha = 1;
        
        if ( [AccountManager enoughGamePointsToUnlockAnUpgrade] )
            self.upgradesBadge.alpha = 1;
    }
    completion:^(BOOL finished)
    {
        if ( completion )
            completion();
    }];
}

- (void) populateBonusTextView
{
    NSMutableAttributedString *mutableAttString = [[NSMutableAttributedString alloc] init];
    for ( GKAchievement * achievement in self.achievementsCompletedDuringFlight )
    {
        NSMutableAttributedString * bonusText = [self bonusTextForAchievement:achievement];
        [mutableAttString appendAttributedString:bonusText];
    }
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary * attributes = @{NSParagraphStyleAttributeName : paragraphStyle,
                                  NSFontAttributeName : self.bonusPointsTextView.font};
    
    [mutableAttString addAttributes:attributes range:NSMakeRange(0, [mutableAttString length])];
    
    
    [self.bonusPointsTextView setAttributedText:mutableAttString];
}

- (NSMutableAttributedString *) bonusTextForAchievement:(GKAchievement *)achievement
{
    NSString * localizedKey = [NSString stringWithFormat:@"kAchievement%@", achievement.identifier];
    NSString * bonusAchievementText = NSLocalizedString(localizedKey, nil);
    NSMutableAttributedString * achievementText = [[NSMutableAttributedString alloc] initWithString:bonusAchievementText attributes:nil];
    
    [achievementText addAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} range:NSMakeRange(0, [achievementText length])];
    
    
    Achievement achievementType = [EnumTypes achievementFromIdentifier:achievement.identifier];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString * numberString = [numberFormatter stringFromNumber:@([AccountManager bonusPointsForAchievement:achievementType])];
    NSString * pointsText = [NSString stringWithFormat:@" + %@ %@\n", numberString, NSLocalizedString(@"points", nil)];
    NSDictionary * colorAttribute = @{NSForegroundColorAttributeName : _SAPink};
    NSMutableAttributedString * pointsAttrString = [[NSMutableAttributedString alloc] initWithString:pointsText attributes:colorAttribute];
    
    [achievementText appendAttributedString:pointsAttrString];
    return achievementText;
}

- (void) achievementCompleted:(NSNotification *)notification
{
    GKAchievement * achievement = (GKAchievement *)notification.object;
    [self.achievementsCompletedDuringFlight addObject:achievement];
}

#pragma mark - buttons
- (IBAction)restartButtonAction:(id)sender
{
    [UIView animateWithDuration:.2 animations:^
    {
        [self hideUIViews];
    }
    completion:^(BOOL finished)
    {
        self.bonusPointsTextViewHeight.constant = self.bonusPointsTextViewHeightDefault;
        self.blackTransitionScreen.alpha = 1;
        //self.view addsubview underneath the banner ad
        [self.mySKView presentScene:nil];
        self.spaceshipScene = [[SpaceshipScene alloc] initWithSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
        self.spaceshipScene.customDelegate = self;
        [self.spaceshipScene setMySpaceship:[self.spaceshipForScene copy]];
        [UIView animateWithDuration:.2 animations:^
        {
            self.mySKView.alpha = 1;
        }];
        
        if ( [AccountManager shouldShowFullscreenAd] )//! [AccountManager shouldShowBannerAds] )
        {
            [self hideBannerView];
        }
        
        self.displayGoMessage = NO;
        [self showSpaceshipScene];
    }];
}

- (IBAction)selectShipAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipNextViewWillAppear" object:nil];
    
    [UIView animateWithDuration:.5 animations:^
    {
        [self hideUIViews];
    }
    completion:^(BOOL finished)
    {
        [[AudioManager sharedInstance] playMenuMusic];
        [self dismissViewControllerAnimated:NO completion:nil];
        MainMenuViewController * mmvc = (MainMenuViewController *)self.presentingViewController;
        [mmvc playAction:nil];
    }];
}

- (IBAction)upgradesAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"skipNextViewWillAppear" object:nil];
    
    [UIView animateWithDuration:.5 animations:^
    {
        [self hideUIViews];
    }
    completion:^(BOOL finished)
    {
        [[AudioManager sharedInstance] playMenuMusic];
        [self dismissViewControllerAnimated:NO completion:nil];
        MainMenuViewController * mmvc = (MainMenuViewController *)self.presentingViewController;
        [mmvc upgradesAction:nil];
    }];
}

- (IBAction)homeAction:(id)sender
{
    [UIView animateWithDuration:.5 animations:^
    {
        [self hideUIViews];
    }
    completion:^(BOOL finished)
    {
        [[AudioManager sharedInstance] playMenuMusic];
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

#pragma mark - ads
#pragma mark full screen ads

#pragma mark banner ads

- (void) hideBannerView
{
    self.mySKViewTopConstraint.constant = 0;
    self.mySKViewBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:.25 animations:^
     {
         
     }];
    [UIView animateWithDuration:.4 animations:^
     {
         [self.view layoutIfNeeded];
     }];
}

@end
