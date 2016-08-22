//
//  UpgradesViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "UpgradesViewController.h"
#import "DQAlertView.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "MenuBackgroundScene.h"
#import <Crashlytics/Crashlytics.h>
#import "SpriteAppDelegate.h"

@implementation UpgradesViewController

- (void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentPurchased) name:@"SKPaymentTransactionStatePurchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:@"SKPaymentTransactionStateFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    
    self.upgrades = [[AccountManager sharedInstance] upgrades];
    
    [self validateProductIdentifiers];
    
    self.shadingView.alpha = 0;
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadingViewPressed)];
    [self.shadingView addGestureRecognizer:tapGesture];
    
    for ( UIView * tmpUIView in self.view.subviews )
    {
        if ( [tmpUIView class] == [UpgradeView class] )
            [(UpgradeView *)tmpUIView setDelegate:self];
    }
    
    [self.upgradeView1 setupForUpgrade:[self.upgrades objectAtIndex:0]];
    [self.upgradeView2 setupForUpgrade:[self.upgrades objectAtIndex:1]];
    [self.upgradeView3 setupForUpgrade:[self.upgrades objectAtIndex:2]];
    [self.upgradeView4 setupForUpgrade:[self.upgrades objectAtIndex:3]];
    [self.upgradeView5 setupForUpgrade:[self.upgrades objectAtIndex:4]];
    [self.upgradeView6 setupForUpgrade:[self.upgrades objectAtIndex:5]];
    [self.upgradeView7 setupForUpgrade:[self.upgrades objectAtIndex:6]];
    [self.upgradeView8 setupForUpgrade:[self.upgrades objectAtIndex:7]];
    
    [_AppDelegate addGlowToLayer:self.upgradeTitleLabel.layer withColor:[self.upgradeTitleLabel.textColor CGColor]];
    [_AppDelegate addGlowToLayer:self.availablePointsLabel.layer withColor:[self.availablePointsLabel.textColor CGColor]];
    [_AppDelegate addGlowToLayer:self.backButton.titleLabel.layer withColor:[self.backButton.titleLabel.textColor CGColor]];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    MenuBackgroundScene * backgroundScene = [MenuBackgroundScene sharedInstance];
    self.animatedBackgroundSKView = [[SKView alloc] initWithFrame:screenBound];
    [self.view insertSubview:self.animatedBackgroundSKView belowSubview:self.upgradeView1];
    [self.animatedBackgroundSKView presentScene:backgroundScene];
}

- (void) adjust4WeaponsView
{
    int numberofUnlockedUpgrades = 0;
    for ( Upgrade * upgrade in self.upgrades )
    {
        if ( upgrade.isUnlocked == YES )
            numberofUnlockedUpgrades++;
    }
    
    
    if ( numberofUnlockedUpgrades < 7 )
    {
        self.upgradeView8.upgrade.icon = [UIImage imageNamed:@"locked.png"];
        self.upgradeView8.userInteractionEnabled = NO;
    }
    else
    {
        self.upgradeView8.upgrade.icon = [[Upgrade alloc] initWithUpgradeType:kUpgrade4Weapons].icon;
        self.upgradeView8.userInteractionEnabled = YES;
    }
    [self.upgradeView8 refreshView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [self adjust4WeaponsView];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@([AccountManager availablePoints])];
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Available Points", nil),numberString];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^
    {
        self.view.alpha = 1;
    }];
    
    
//    for ( UIView * subview in [self.view subviews] )
//        subview.alpha = 0;
//    [UIView animateWithDuration:.2 animations:^
//    {
//        for ( UIView * subview in [self.view subviews] )
//            subview.alpha = 1;
//    }];
    
    for ( UpgradeView * upgradeView in [self.view subviews] )
    {
        if ( [upgradeView class] == [UpgradeView class] )
            upgradeView.minimizedFrame = upgradeView.frame;
    }
}

- (void) viewDidLayoutSubviews
{
    //GD autolayout - autolayout is recalculating the upgradeView frame once the [upgradeView addSubview] is called
    //addSubview is necessary becuase i have to Nil out the skView when minimizing the upgradeView to get rid of the skScene
    //i have to get rid of the skScene becuase i cant have multiple skScenes at the same time

    for ( UpgradeView * upgradeView in [self.view subviews] )
    {
        if ( [upgradeView class] == [UpgradeView class] )
        {
            if ( ! upgradeView.isMinimizing )
            {
                if ( ! upgradeView.isMinimized )
                    upgradeView.frame = upgradeView.maximizedFrame;
                else
                    [upgradeView minimizeViewAnimated:NO];
            }
        }
    }
    
}

- (void) refreshUpgradeViews
{
    for ( UIView * tmpUIView in self.view.subviews )
    {
        if ( [tmpUIView class] == [UpgradeView class] )
            [(UpgradeView *)tmpUIView refreshView];
    }
    
    [self adjust4WeaponsView];
}

- (void) dealloc
{
    self.productsRequest.delegate = nil;
    [self.productsRequest cancel];
    self.productsRequest = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) achievementsLoaded
{
    [self refreshUpgradeViews];
}

- (IBAction)backAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuBackButton];
    [UIView animateWithDuration:.2 animations:^
    {
        self.view.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void) showProgressHud
{
    if ( ! self.activityIndicatorBackground )
    {
        self.activityIndicatorBackground = [[UIView alloc] initWithFrame:self.view.frame];
        self.activityIndicatorBackground.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
    }
    if ( ! self.activityIndicator )
    {
        self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallTrianglePath tintColor:[UIColor whiteColor] size:self.view.frame.size.width/6.4];
        self.activityIndicator.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    }
    
    self.activityIndicatorBackground.alpha = 0;
    [self.activityIndicatorBackground addSubview:self.activityIndicator];
    [self.view addSubview:self.activityIndicatorBackground];
    [self.activityIndicator startAnimating];
    [UIView animateWithDuration:.2 animations:^
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

- (void) fadeOutShadingViewIfNeeded
{
    BOOL shouldFadeOut = YES;
    for ( UpgradeView * upgradeView in [self.view subviews] )
    {
        if ( [upgradeView class] == [UpgradeView class] )
        {
            if ( !upgradeView.isMinimized && !upgradeView.isMinimizing)
                shouldFadeOut = NO;
        }
    }
    
    if ( shouldFadeOut )
    {
        [UIView animateWithDuration:.5 animations:^
         {
             self.shadingView.alpha = 0;
         }];
    }
}

- (void) shadingViewPressed
{
    for ( UpgradeView * upgradeView in [self.view subviews] )
    {
        if ( [upgradeView class] == [UpgradeView class] )
        {
            if ( ! upgradeView.isMinimized )
                [upgradeView minimizeViewAnimated:YES];
        }
    }
}

- (void) animateAvailablePoints:(NSNumber *)pointsToSubtractNumber
{
    int pointsToSubtract = [pointsToSubtractNumber intValue];
    
    if ( self.animatingUpgradeView )
    {
        [self performSelector:@selector(animateAvailablePoints:) withObject:@(pointsToSubtract) afterDelay:.5];
        return;
    }
    
    NSString * availablePointsPart = [NSString stringWithFormat:@"%@ : ", NSLocalizedString(@"Available Points", nil)];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    int points = [[numberFormatter numberFromString:[self.availablePointsLabel.text stringByReplacingOccurrencesOfString:availablePointsPart withString:@""]] intValue];
    NSString *numberString = [numberFormatter stringFromNumber:@(points - 500)];
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Available Points", nil), numberString];
    
    if ( pointsToSubtract != 500 )
        [self performSelector:@selector(animateAvailablePoints:) withObject:[NSNumber numberWithInt:pointsToSubtract-500] afterDelay:.05];
}

#pragma mark - store kit
- (void) validateProductIdentifiers
{
    NSMutableArray * productIdentifiers = [NSMutableArray new];
    for ( Upgrade * upgrade in self.upgrades )
        [productIdentifiers addObject:upgrade.storeKitIdentifier];
    
    self.productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[productIdentifiers copy]];
    self.productsRequest.delegate = self;
    [self.productsRequest start];
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    self.products = response.products;
    for ( SKProduct * product in self.products )
    {
        [numberFormatter setLocale:product.priceLocale];
        for ( Upgrade * upgrade in self.upgrades )
        {
            if ( [product.productIdentifier isEqualToString:upgrade.storeKitIdentifier] )
            {
                //NSLog(@"identifier matched to upgrade : %@", product.productIdentifier);
                upgrade.isValidForMoneyPurchase = YES;
                upgrade.priceString = [numberFormatter stringFromNumber:product.price];
            }
        }
    }
    
    
    for ( NSString * invalidIdentifier in response.invalidProductIdentifiers )
    {
        NSLog(@"invalidIdentifier : %@", invalidIdentifier);
        for ( Upgrade * upgrade in self.upgrades )
        {
            if ( [upgrade.storeKitIdentifier isEqualToString:invalidIdentifier] )
                upgrade.isValidForMoneyPurchase = NO;
        }
    }
    
    [self refreshUpgradeViews];
}

- (void) paymentPurchased
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString * currency = [formatter currencyCode];
    
    [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:self.activeUpgrade.priceToUnlock]
                         currency:currency
                          success:@YES
                         itemName:self.activeUpgrade.title
                         itemType:@"Upgrade"
                           itemId:nil
                 customAttributes:@{}];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuDidUnlock];
    NSLog(@"Payment Purchased Notification");
    [self hideProgressHud];
    [self refreshUpgradeViews];
}

- (void) paymentFailed
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString * currency = [formatter currencyCode];
    
    [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:self.activeUpgrade.priceToUnlock]
                         currency:currency
                          success:@NO
                         itemName:self.activeUpgrade.title
                         itemType:@"Upgrade"
                           itemId:nil
                 customAttributes:@{}];
    NSLog(@"Payment Failed Notification");
    [self hideProgressHud];
    [self refreshUpgradeViews];
}

#pragma mark - upgrade view delegate
- (void) willMaximizeUpgradeView:(UpgradeView *)upgradeView
{
    self.animatingUpgradeView = YES;
    [self.view bringSubviewToFront:self.shadingView];
    [self.view bringSubviewToFront:upgradeView];
    [UIView animateWithDuration:.5 animations:^
    {
        [self.view layoutSubviews];
    }];
    
    
    [UIView animateWithDuration:.5 animations:^
    {
        self.shadingView.alpha = .8;
    }];
}

- (void) didMaximizeUpgradeView:(UpgradeView *)upgradeView
{
    self.animatingUpgradeView = NO;
    self.activeUpgrade = upgradeView.upgrade;
}

- (void) willMinimizeUpgradeView:(UpgradeView *)upgradeView
{
    self.animatingUpgradeView = YES;
    [self fadeOutShadingViewIfNeeded];
}

- (void) didMinimizeUpgradeView:(UpgradeView *)upgradeView
{
    self.animatingUpgradeView = NO;
    self.activeUpgrade = nil;
}

- (void) unlockWithPointsPressed:(UpgradeView *)upgradeView
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString * formattedPoints = [formatter stringFromNumber:[NSNumber numberWithInteger:upgradeView.upgrade.pointsToUnlock]];

    DQAlertView * unlockAlert = [[DQAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unlock %@\nfor %@ points?", upgradeView.upgrade.title, formattedPoints] cancelButtonTitle:@"Cancel" otherButtonTitle:@"Unlock"];
    unlockAlert.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
    unlockAlert.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
    unlockAlert.appearTime = .2;
    unlockAlert.disappearTime = .2;
    unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.95];
    unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
    unlockAlert.messageLabel.textColor = [UIColor whiteColor];
    unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    [unlockAlert.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    [unlockAlert.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unlockAlert.otherButtonAction = ^
    {
        [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:upgradeView.upgrade.pointsToUnlock]
                             currency:@"game points"
                              success:@YES
                             itemName:upgradeView.upgrade.title
                             itemType:@"Upgrade"
                               itemId:nil
                     customAttributes:@{}];
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuDidUnlock];
        [AccountManager subtractPoints:upgradeView.upgrade.pointsToUnlock];
        [AccountManager unlockUpgrade:upgradeView.upgrade.upgradeType];
        [self refreshUpgradeViews];
        [self animateAvailablePoints:[NSNumber numberWithInt:upgradeView.upgrade.pointsToUnlock]];
    };
    [unlockAlert show];
}

- (void) unlockWithMoneyPressed:(UpgradeView *)upgradeView
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    DQAlertView * unlockAlert = [[DQAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unlock %@\nfor %@?", upgradeView.upgrade.title, upgradeView.upgrade.priceString] cancelButtonTitle:@"Cancel" otherButtonTitle:@"Unlock"];
    unlockAlert.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
    unlockAlert.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
    unlockAlert.appearTime = .2;
    unlockAlert.disappearTime = .2;
    unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.95];
    unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:20];
    unlockAlert.messageLabel.textColor = [UIColor whiteColor];
    unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    [unlockAlert.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
    [unlockAlert.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    unlockAlert.otherButtonAction = ^
    {
        SKProduct * product = nil;
        for ( SKProduct * tmpProduct in self.products )
        {
            if ( [tmpProduct.productIdentifier isEqualToString:upgradeView.upgrade.storeKitIdentifier] )
            {
                product = tmpProduct;
                break;
            }
        }
        
        if ( product )
        {
            SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            [self showProgressHud];
        }
        else
        {
            NSLog(@"somethign screwd up i think");
        }
    };
    [unlockAlert show];
}
@end
