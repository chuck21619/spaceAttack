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


@implementation UpgradesViewController
{
    int _defaultRowHeightMinmized;
    int _defaultRowHeightMaximized;
    int _defaultConstraintTopMyTable;
    float _cellSpacing;
}

- (void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentPurchased) name:@"SKPaymentTransactionStatePurchased" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentFailed) name:@"SKPaymentTransactionStateFailed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(achievementsLoaded) name:@"achievementsLoaded" object:nil];
    
    self.upgrades = [[AccountManager sharedInstance] upgrades];
    
    //[self validateProductIdentifiers];
    
    _cellSpacing = 5;
    
    _defaultConstraintTopMyTable = self.constraintTopMyTable.constant;
    
    _defaultRowHeightMaximized = self.view.frame.size.height;
    _defaultRowHeightMinmized = (self.myTable.frame.size.height/self.upgrades.count) - _cellSpacing;
    self.myTable.rowHeight = UITableViewAutomaticDimension;
    self.myTable.estimatedRowHeight = _defaultRowHeightMinmized;
    
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
    //[self.myTable reloadData];
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

- (void) setMainScreenViewsAlpha:(float)alpha
{
    self.upgradeTitleLabel.alpha = alpha;
    self.backButton.alpha = alpha;
    self.availablePointsLabel.alpha = alpha;
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

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpgradeCell * cell = (UpgradeCell*)[tableView dequeueReusableCellWithIdentifier:@"upgradeCell"];
    
    if ( cell.heightConstraint.constant != _defaultRowHeightMinmized && cell.heightConstraint.constant != _defaultRowHeightMaximized )
        cell.heightConstraint.constant = _defaultRowHeightMinmized;
    
    Upgrade * tmpUpgrade = [self.upgrades objectAtIndex:indexPath.section];
    [cell createContentFromUpgrade:tmpUpgrade];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UpgradeCell * cell = (UpgradeCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.delegate = self;
    
    NSMutableArray * allOtherCells = [[tableView visibleCells] mutableCopy];
    [allOtherCells removeObject:cell];
    
    float mainScreenViewsAlpha;
    
    //if minimized
    if ( cell.heightConstraint.constant == _defaultRowHeightMinmized )
    {
        mainScreenViewsAlpha = 0;
        
        [cell showMinimizedContent:NO animated:YES completion:^
        {
            [cell showMaximizedContent:YES animated:YES completion:nil];
        }];
        
        cell.heightConstraint.constant = _defaultRowHeightMaximized;
        self.constraintTopMyTable.constant = 0;
        tableView.allowsSelection = NO;
    }
    else
    {
        mainScreenViewsAlpha = 1;
        
        [cell showMaximizedContent:NO animated:YES completion:^
        {
            [cell showMinimizedContent:YES animated:YES completion:nil];
        }];
        
        cell.heightConstraint.constant = _defaultRowHeightMinmized;
        self.constraintTopMyTable.constant = _defaultConstraintTopMyTable;
        tableView.allowsSelection = YES;
    }
    
    [UIView animateWithDuration:.3 animations:^
    {
        for ( UpgradeCell * tmpCell in allOtherCells )
            [tmpCell setAlpha:mainScreenViewsAlpha];
        [self setMainScreenViewsAlpha:mainScreenViewsAlpha];
        [self.view layoutIfNeeded];
        [cell.contentView layoutIfNeeded];
        [tableView beginUpdates];
        [tableView endUpdates];
        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

#pragma mark upgrade cell delegate
- (void) minimizePressed:(UpgradeCell *)upgradeCell
{
    NSIndexPath * indexPath = [self.myTable indexPathForCell:upgradeCell];
    [self tableView:self.myTable didSelectRowAtIndexPath:indexPath];
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
