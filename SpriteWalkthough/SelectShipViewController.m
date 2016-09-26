//
//  SelectShipViewController.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "SelectShipViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "SpaceshipKit.h"
#import "GameplayViewController.h"
#import "GameplayControls.h"
#import "AccountManager.h"
#import "SAAlertView.h"
#import "AudioManager.h"
#import <Crashlytics/Crashlytics.h>
#import "SpriteAppDelegate.h"

@implementation SelectShipViewController
{
    SKProductsRequest * _productsRequest;
    PurchaseShipView * _purchaseView;
    DGActivityIndicatorView * _activityIndicator;
    UIView * _activityIndicatorBackground;
    NSArray * _shipButtons;
    Spaceship * _activeSpaceship;
//    NSNumberFormatter * numberFormatter = [NSNumberFormatter new];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentPurchased) name:@"SKPaymentTransactionStatePurchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:@"SKPaymentTransactionStateFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:@"appDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:@"appDidBecomeActive" object:nil];
    
    [_AppDelegate addGlowToLayer:self.selectTitleLabel.layer withColor:self.selectTitleLabel.textColor.CGColor];
    
    self.spaceships = [[AccountManager sharedInstance] spaceships];
    
    [self.shipButton1 setupForSpaceship:[self.spaceships objectAtIndex:0]];
    [self.shipButton2 setupForSpaceship:[self.spaceships objectAtIndex:1]];
    [self.shipButton3 setupForSpaceship:[self.spaceships objectAtIndex:2]];
    [self.shipButton4 setupForSpaceship:[self.spaceships objectAtIndex:3]];
    [self.shipButton5 setupForSpaceship:[self.spaceships objectAtIndex:4]];
    [self.shipButton6 setupForSpaceship:[self.spaceships objectAtIndex:5]];
    [self.shipButton7 setupForSpaceship:[self.spaceships objectAtIndex:6]];
    [self.shipButton8 setupForSpaceship:[self.spaceships objectAtIndex:7]];
    
    _shipButtons = @[self.shipButton1,
                     self.shipButton2,
                     self.shipButton3,
                     self.shipButton4,
                     self.shipButton5,
                     self.shipButton6,
                     self.shipButton7,
                     self.shipButton8];
    
    [self validateProductIdentifiers];
    _purchaseView = [[PurchaseShipView alloc] initWithFrame:self.view.frame];
    _purchaseView.alpha = 0;
    _purchaseView.delegate = self;
    [self.view addSubview:_purchaseView];
    
    [self addGlowToShipSelectionButtons];
    
    
    self.selectTitleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.selectTitleLabel.font.pointSize];
    self.backButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.backButton.titleLabel.font.pointSize];
    
    [self adjustForDeviceSize];
}

- (void) viewWillAppear:(BOOL)animated
{
    for ( UIView * subview in [self.view subviews] )
    {
        subview.alpha = 0;
    }
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag == 9 ) //scan lines
            {
                subview.alpha = .1;
                continue;
            }
            
            if ( subview != _purchaseView )
                subview.alpha = 1;
        }
    }];
}

- (void) dealloc
{
    _productsRequest.delegate = nil;
    [_productsRequest cancel];
    _productsRequest = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    [self.selectTitleLabel setFont:[self.selectTitleLabel.font fontWithSize:width*.119]];
    [self.backButton.titleLabel setFont:[self.backButton.titleLabel.font fontWithSize:width*.044]];
    
    
    self.constraintTrailingBack.constant = width*.669;
    
    self.constraintLeadingSelect.constant = width*.125;
    self.constraintTopSelect.constant = width*.038;
    self.constraintTrailingSelect.constant = width*.125;
    
    self.constraintTopFirstButton.constant = width*.041;
}

- (void) addGlowToShipSelectionButtons
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        for ( ShipSelectionButton * shipButton in _shipButtons )
            [shipButton addGlowAnimated];
    });
}

- (void) showProgressHud
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

- (void) hideProgressHud
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

- (void) refreshShipButtons
{
    for ( ShipSelectionButton * shipButton in _shipButtons )
        [shipButton refreshContent];
}

#pragma mark
- (void) appDidEnterBackground
{
    [self removeAppStoreValidity];
    if ( _activeSpaceship )
        [_purchaseView updateContentWithSpaceship:_activeSpaceship];
}

- (void) appDidBecomeActive
{
    [self validateProductIdentifiers];
}

#pragma mark - game center
- (void) achievementsLoaded
{
    if ( _activeSpaceship )
        [_purchaseView updateContentWithSpaceship:_activeSpaceship];
}

#pragma mark - store kit
- (void) removeAppStoreValidity
{
    for ( Spaceship * spaceship in self.spaceships )
        spaceship.isValidForMoneyPurchase = NO;
    
    if ( _activeSpaceship )
        [_purchaseView updateContentWithSpaceship:_activeSpaceship];
}

- (void) validateProductIdentifiers
{
    NSMutableArray * productIdentifiers = [NSMutableArray new];
    for ( Spaceship * spaceship in self.spaceships )
    {
        if ( ! [spaceship isKindOfClass:[Abdul_Kadir class]] )
            [productIdentifiers addObject:spaceship.storeKitIdentifier];
    }
    
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[productIdentifiers copy]];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    //NSLog(@"spaceship products validated");
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    for ( SKProduct * product in response.products )
    {
        [numberFormatter setLocale:product.priceLocale];
        for ( Spaceship * spaceship in self.spaceships )
        {
            if ( [product.productIdentifier isEqualToString:spaceship.storeKitIdentifier] )
            {
                //NSLog(@"identifier matched to spaceship : %@", product.productIdentifier);
                spaceship.storeKitProduct = product;
                spaceship.isValidForMoneyPurchase = YES;
                spaceship.priceString = [numberFormatter stringFromNumber:product.price];
            }
        }
    }
    
    
    for ( NSString * invalidIdentifier in response.invalidProductIdentifiers )
    {
        NSLog(@"invalidIdentifier : %@", invalidIdentifier);
        for ( Spaceship * spaceship in self.spaceships )
        {
            if ( [spaceship.storeKitIdentifier isEqualToString:invalidIdentifier] )
                spaceship.isValidForMoneyPurchase = NO;
        }
    }
    
    if ( _activeSpaceship )
        [_purchaseView updateContentWithSpaceship:_activeSpaceship];
}

- (void) paymentPurchased
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString * currency = [formatter currencyCode];
    
    NSString * trimmedString = [[_activeSpaceship.priceString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    
    [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:[trimmedString floatValue]]
                         currency:currency
                          success:@YES
                         itemName:NSStringFromClass([_activeSpaceship class])
                         itemType:@"Spaceship"
                           itemId:nil
                 customAttributes:@{}];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuDidUnlock];
    [AccountManager unlockShip:_activeSpaceship];
    NSLog(@"Payment Purchased Notification - spaceship");
    
    [self hideProgressHud];
    [self refreshShipButtons];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        [_purchaseView showPurchasedLabelAnimated:YES];
    });
}

- (void) paymentFailed
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    NSString * currency = [formatter currencyCode];
    
    NSString * trimmedString = [[_activeSpaceship.priceString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]]componentsJoinedByString:@""];
    
    [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:[trimmedString floatValue]]
                         currency:currency
                          success:@NO
                         itemName:NSStringFromClass([_activeSpaceship class])
                         itemType:@"Spaceship"
                           itemId:nil
                 customAttributes:@{}];
    NSLog(@"Payment Failed Notification - spaceships");
    [self hideProgressHud];
}

#pragma mark - misc.
- (IBAction)engageAction:(id)sender
{
    Spaceship * selectedShip = [(ShipSelectionButton *)sender spaceship];
    
    if ( [selectedShip isUnlocked] )
    {
        [[AudioManager sharedInstance] fadeOutMenuMusic];
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuEngage];
        [AccountManager setLastSelectedShip:selectedShip];

        UIViewController * mainMenuVC = [self presentingViewController];
        mainMenuVC.view.alpha = 0;
        [UIView animateWithDuration:.3 animations:^
        {
            self.view.alpha = 0;
        }
        completion:^(BOOL finished)
        {
            [self dismissViewControllerAnimated:NO completion:^
            {
                UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                GameplayViewController * gameplayVC = [storyboard instantiateViewControllerWithIdentifier:@"gameplayVC"];
                [gameplayVC setSpaceshipForScene:[selectedShip copy]];
                [mainMenuVC presentViewController:gameplayVC animated:NO completion:^
                {
                    mainMenuVC.view.alpha = 1;
                }];
            }];
        }];
    }
    else
    {
        _activeSpaceship = selectedShip;
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
        [_purchaseView updateContentWithSpaceship:selectedShip];
        [UIView animateWithDuration:.4 animations:^
        {
            _purchaseView.alpha = 1;
        }];
    }
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

#pragma mark - purchase view delegate
- (void) purchasedWithPoints:(Spaceship *)spaceship
{
    [self refreshShipButtons];
}

- (void) purchaseWithMoneyPressed:(Spaceship *)spacehship
{
    SKProduct * product = spacehship.storeKitProduct;
    if ( product )
    {
        NSLog(@"purchase prodect request : %@", product.productIdentifier);
        SKMutablePayment * payment = [SKMutablePayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [self showProgressHud];
    }
    else
    {
        NSLog(@"somethign screwd up : %@", product.productIdentifier);
    }
}

- (void) closeViewPressed
{
    [UIView animateWithDuration:.5 animations:^
    {
        _purchaseView.alpha = 0;
    }];
}

@end
