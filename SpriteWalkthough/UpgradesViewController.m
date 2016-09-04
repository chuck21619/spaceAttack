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
#import "UIView+Shake.h"

@implementation UpgradesViewController
{
    int _defaultConstraintTopMyTable;
    float _minimizedCellHeight;
    float _cellSpacing;
    
    BOOL _minimizedCellFramesUpdated;
    
    NSMutableDictionary * _precomputedCells;
    
    BOOL _demoMaskApplied;
}

- (void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentPurchased) name:@"SKPaymentTransactionStatePurchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:@"SKPaymentTransactionStateFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:@"appDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:@"appDidBecomeActive" object:nil];
    
    self.upgrades = [[AccountManager sharedInstance] upgrades];
    _precomputedCells = [NSMutableDictionary new];
    for ( int i = 0; i < self.upgrades.count; i++ )
    {
        Upgrade * upgrade = [self.upgrades objectAtIndex:i];
        UpgradeCell * cell = [[UpgradeCell alloc] initWithUpgrade:upgrade];
        [_precomputedCells setObject:cell forKey:upgrade.title];
    }
    
    [self validateProductIdentifiers];
    
    [self adjustForDeviceSize];
    
    _defaultConstraintTopMyTable = self.constraintTopMyTable.constant;
    
    [_AppDelegate addGlowToLayer:self.upgradeTitleLabel.layer withColor:[self.upgradeTitleLabel.textColor CGColor]];
    [_AppDelegate addGlowToLayer:self.availablePointsLabel.layer withColor:[self.availablePointsLabel.textColor CGColor]];
    [_AppDelegate addGlowToLayer:self.backButton.titleLabel.layer withColor:[self.backButton.titleLabel.textColor CGColor]];
    
    [self.myTable reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@([AccountManager availablePoints])];
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Available Points", nil),numberString];
    
    for ( UIView * subview in [self.view subviews] )
    {
        if ( subview.tag != 10 ) //10 is the background image
            subview.alpha = 0;
    }
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview != self.demoPreviewImageView && subview != self.myTable )
                subview.alpha = 1;
        }
    }];
    [UIView animateWithDuration:.4 animations:^
    {
        self.myTable.alpha = 1;
    }];
}

- (void) refreshUpgradeViews
{
    for ( Upgrade * upgrade in self.upgrades )
    {
        UpgradeCell * cell = [_precomputedCells objectForKey:upgrade.title];
        [cell updateContentWithUpgrade:upgrade];
    }
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
#warning stop the shadow animation
    //remove app store validity
    [self removeAppStoreValidity];
    
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuBackButton];
    
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag != 10 && subview != self.myTable ) //10 is the background image
                subview.alpha = 0;
        }
    }];
    [UIView animateWithDuration:.3 animations:^
    {
        self.myTable.alpha = 0;
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
        self.activityIndicator = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScale tintColor:[UIColor whiteColor] size:self.view.frame.size.width/6.4];
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

- (void) setMainScreenViewsAlpha:(float)alpha
{
    self.upgradeTitleLabel.alpha = alpha;
    self.backButton.alpha = alpha;
    self.availablePointsLabel.alpha = alpha;
    self.backgroundImageView.alpha = alpha;
}

- (void) animateAvailablePoints:(NSNumber *)pointsToSubtractNumber
{
    int pointsToSubtract = [pointsToSubtractNumber intValue];
    
//    if ( self.animatingUpgradeView )
//    {
//        [self performSelector:@selector(animateAvailablePoints:) withObject:@(pointsToSubtract) afterDelay:.5];
//        return;
//    }
    
    NSString * availablePointsPart = [NSString stringWithFormat:@"%@ : ", NSLocalizedString(@"Available Points", nil)];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    int points = [[numberFormatter numberFromString:[self.availablePointsLabel.text stringByReplacingOccurrencesOfString:availablePointsPart withString:@""]] intValue];
    NSString *numberString = [numberFormatter stringFromNumber:@(points - 500)];
    self.availablePointsLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Available Points", nil), numberString];
    
    if ( pointsToSubtract != 500 )
        [self performSelector:@selector(animateAvailablePoints:) withObject:[NSNumber numberWithInt:pointsToSubtract-500] afterDelay:.05];
}

- (void) viewDidLayoutSubviews
{
    [self updateMinizedCellFramesIfNeccessary];
    [super viewDidLayoutSubviews];
    
    if ( ! _demoMaskApplied )
    {
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectMake(0, 0, self.demoPreviewImageView.frame.size.width, self.demoPreviewImageView.frame.size.height);
        maskLayer.shadowRadius = 5;
        maskLayer.shadowPath = CGPathCreateWithRoundedRect(CGRectInset(maskLayer.frame, 10, 10), 10, 10, nil);
        maskLayer.shadowOpacity = 1;
        maskLayer.shadowOffset = CGSizeZero;
        maskLayer.shadowColor = [UIColor whiteColor].CGColor;
        self.demoPreviewImageView.layer.mask = maskLayer;
        
        _demoMaskApplied = YES;
    }
}

- (void) updateMinizedCellFramesIfNeccessary
{
    if ( ! _minimizedCellFramesUpdated )
    {
        _minimizedCellHeight = (self.myTable.frame.size.height/_upgrades.count) - _cellSpacing;
        for ( UpgradeCell * cell in [_precomputedCells allValues] )
            [cell updateMinimizedCellHeight:_minimizedCellHeight];
        
        _minimizedCellFramesUpdated = YES;
    }
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    _cellSpacing = width*.016;
    _demoPreviewImageView.layer.borderColor = [UIColor blackColor].CGColor;
    _demoPreviewImageView.layer.borderWidth = width*0.03125;
    
    self.constraintTrailingBackButton.constant = width*.669;
    [self.backButton.titleLabel setFont:[self.backButton.titleLabel.font fontWithSize:width*.044]];
    
    self.constraintTopTitleLabel.constant = width*.047;
    self.constraintHeightTitleLabel.constant = width*.147;
    self.upgradeTitleLabel.font = [self.upgradeTitleLabel.font fontWithSize:width*.119];
    
    self.constraintHeightAvailablePoints.constant = width*.047;
    self.availablePointsLabel.font = [self.availablePointsLabel.font fontWithSize:width*.044];
    
    self.constraintTopMyTable.constant = width*.25;
    self.constraintLeadingMyTable.constant = width*.022;
    self.constraintTrailingMyTable.constant = width*.022;
    self.constraintBottomMyTable.constant = width*.022;
    
    self.constraintBottomDemoPreviewImageView.constant = width*.65;
}

- (void) animateCellHeight:(UpgradeCell *)cell tableTopConstraint:(int)constraintConstant mainScreenViewsAlpha:(float)alpha completion:(void (^)())completion
{
    self.constraintTopMyTable.constant = constraintConstant;
    [UIView animateWithDuration:.35 animations:^
    {
        [self.view layoutIfNeeded];
        [self setMainScreenViewsAlpha:alpha];
    }
    completion:^(BOOL finished)
    {
        if ( completion )
            completion();
    }];
    
    [self.myTable beginUpdates];
    [self.myTable endUpdates];
    NSIndexPath * indexPath = [self.myTable indexPathForCell:cell];
    [self.myTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) removeAppStoreValidity
{
    //remove app store validity
    for ( Upgrade * upgrade in self.upgrades )
        upgrade.isValidForMoneyPurchase = NO;
    
    [self refreshUpgradeViews];
}

- (void) appDidEnterBackground
{
    [self removeAppStoreValidity];
    [self refreshUpgradeViews];
}

- (void) appDidBecomeActive
{
    [self validateProductIdentifiers];
}

#pragma mark - table view
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return _cellSpacing;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, _cellSpacing)];
    return emptyView;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.upgrades.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Upgrade * tmpUpgrade = [self.upgrades objectAtIndex:indexPath.section];
    
    if ( tmpUpgrade.isMaximized )
        return self.myTable.frame.size.height;
    
    return _minimizedCellHeight;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Upgrade * upgrade = [self.upgrades objectAtIndex:indexPath.section];
    UpgradeCell * cell = [_precomputedCells objectForKey:upgrade.title];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpgradeCell * cell = (UpgradeCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    
    Upgrade * tmpUpgrade = [self.upgrades objectAtIndex:indexPath.section];
    self.activeUpgrade = tmpUpgrade;
    
    float mainScreenViewsAlpha;
    
    //if minimized
    if ( ! tmpUpgrade.isMaximized )
    {
        if ( tmpUpgrade.upgradeType == kUpgrade4Weapons )
        {
            int numberOfUnlockedUpgrades = 0;
            for ( Upgrade * tmpUpgrade in [AccountManager sharedInstance].upgrades )
            {
                if ( tmpUpgrade.isUnlocked )
                    numberOfUnlockedUpgrades++;
            }
            
            if ( numberOfUnlockedUpgrades < 7 )
            {
#warning stop the shadow animation
                [cell shake];
                return;
            }
        }
        
        
        mainScreenViewsAlpha = 0;
        tableView.allowsSelection = NO;
        tmpUpgrade.isMaximized = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpgradeTableWillAnimate object:nil];
        [cell showMinimizedContent:NO animated:YES completion:^
        {
            [self animateCellHeight:cell tableTopConstraint:7 mainScreenViewsAlpha:mainScreenViewsAlpha completion:^
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpgradeTableDidAnimate object:nil];
                [self showDemoImageForUpgrade:tmpUpgrade];
                [cell showMaximizedContent:YES animated:YES completion:nil];
            }];
        }];
    }
    else
    {
        mainScreenViewsAlpha = 1;
        tableView.allowsSelection = YES;
        tmpUpgrade.isMaximized = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpgradeTableWillAnimate object:nil];
        [self hideScene];
        [cell showMaximizedContent:NO animated:YES completion:^
        {
            [self animateCellHeight:cell tableTopConstraint:_defaultConstraintTopMyTable mainScreenViewsAlpha:mainScreenViewsAlpha completion:^
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpgradeTableDidAnimate object:nil];
                [cell showMinimizedContent:YES animated:YES completion:nil];
            }];
        }];
    }
}

#pragma mark upgrade cell delegate
- (void) minimizePressed:(UpgradeCell *)upgradeCell
{
    NSIndexPath * indexPath = [self.myTable indexPathForCell:upgradeCell];
    [self tableView:self.myTable didSelectRowAtIndexPath:indexPath];
}

- (void) purchasedWithPoints:(float)pointsSpent
{
    [self animateAvailablePoints:[NSNumber numberWithFloat:pointsSpent]];
}

- (void) purchaseWithMoneyPressed:(Upgrade *)upgrade
{
    SKProduct * product = nil;
    for ( SKProduct * tmpProduct in self.products )
    {
        if ( [tmpProduct.productIdentifier isEqualToString:upgrade.storeKitIdentifier] )
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
}

#pragma mark
- (void) showDemoImageForUpgrade:(Upgrade *)upgrade
{
    self.demoPreviewImageView.alpha = 0;
    self.demoPreviewImageView.animatedImage = upgrade.animatedImage;
    
    [UIView animateWithDuration:.3 animations:^
    {
        self.demoPreviewImageView.alpha = 1;
    }];
}

- (void) hideScene
{
    [UIView animateWithDuration:.3 animations:^
    {
        self.demoPreviewImageView.alpha = 0;
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
    NSLog(@"products validated");
    
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

@end
