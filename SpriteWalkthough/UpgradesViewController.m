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
#import <Crashlytics/Crashlytics.h>
#import "SpriteAppDelegate.h"
#import "MenuBackgroundScene.h"
#import "UpgradeCell.h"



@implementation UpgradesViewController
{
    //CAGradientLayer * _gradientLayer;
    int _defaultRowHeight;
}

- (void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentPurchased) name:@"SKPaymentTransactionStatePurchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:@"SKPaymentTransactionStateFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    
    self.upgrades = [[AccountManager sharedInstance] upgrades];
    
    //[self validateProductIdentifiers];
    
    
    
    _defaultRowHeight = self.myTable.rowHeight;
    self.myTable.rowHeight = UITableViewAutomaticDimension;
    self.myTable.estimatedRowHeight = _defaultRowHeight;
    
    
//    _gradientLayer = [CAGradientLayer layer];
//    _gradientLayer.frame = self.view.frame;
//    _gradientLayer.colors = @[(id)self.myTable.backgroundColor.CGColor, (id)[UIColor clearColor].CGColor];
//    _gradientLayer.endPoint = CGPointMake(1.0f, 0.07f);
//    _gradientLayer.startPoint = CGPointMake(1.0f, .2f);
//    self.tableAlphaMaskView.layer.mask = _gradientLayer;
    
//    MenuBackgroundScene * backgroundScene = [MenuBackgroundScene sharedInstance];
//    SKView * spriteView = (SKView *)self.view;
//    [spriteView presentScene:backgroundScene];
    
    [_AppDelegate addGlowToLayer:self.upgradeTitleLabel.layer withColor:[self.upgradeTitleLabel.textColor CGColor]];
    [_AppDelegate addGlowToLayer:self.availablePointsLabel.layer withColor:[self.availablePointsLabel.textColor CGColor]];
    [_AppDelegate addGlowToLayer:self.backButton.titleLabel.layer withColor:[self.backButton.titleLabel.textColor CGColor]];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@([AccountManager availablePoints])];
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Available Points", nil),numberString];
    
    self.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^
    {
        self.view.alpha = 1;
    }];
    
}


- (void) refreshUpgradeViews
{
    [self.myTable reloadData];
}

- (void) dealloc
{
    self.productsRequest.delegate = nil;
    [self.productsRequest cancel];
    self.productsRequest = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

/*
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
}*/


#pragma mark - table view
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.upgrades.count+1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpgradeCell * cell = (UpgradeCell*)[tableView dequeueReusableCellWithIdentifier:@"upgradeCell"];
    
    if ( indexPath.row == 0 )
    {
        cell.heightConstraint.constant = 100;
        for ( UIView * subview in [cell subviews] )
            [subview removeFromSuperview];
    }
    else
    {
        cell.heightConstraint.constant = _defaultRowHeight;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpgradeCell * cell = (UpgradeCell*)[tableView cellForRowAtIndexPath:indexPath];

    NSArray * colors;
    
    if ( cell.heightConstraint.constant == self.view.frame.size.height )
    {
        [UIView animateWithDuration:.3 animations:^
        {
            self.upgradeTitleLabel.alpha = 1;
            self.availablePointsLabel.alpha = 1;
        }];
        
        cell.heightConstraint.constant = _defaultRowHeight;
        tableView.scrollEnabled = YES;
        colors = @[(id)self.myTable.backgroundColor.CGColor, (id)[UIColor clearColor].CGColor];
    }
    else
    {
        [UIView animateWithDuration:.3 animations:^
        {
            self.upgradeTitleLabel.alpha = 0;
            self.availablePointsLabel.alpha = 0;
        }];
        
        cell.heightConstraint.constant = self.view.frame.size.height;
        tableView.scrollEnabled = NO;
        colors = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor, (id)[UIColor blackColor].CGColor, nil];
    }
    
    [UIView animateWithDuration:.3 animations:^
     {
         //table/cell
         [cell.contentView layoutIfNeeded];
         [tableView beginUpdates];
         [tableView endUpdates];
         [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
         
         //top gradient
         //_gradientLayer.colors = colors;
     }];
}

#pragma mark - game center
- (void) achievementsLoaded
{
    [self refreshUpgradeViews];
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

/*
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
}*/
@end
