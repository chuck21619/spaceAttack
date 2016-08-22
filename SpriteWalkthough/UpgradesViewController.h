//
//  UpgradesViewController.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UpgradeView.h"
#import "DGActivityIndicatorView.h"
@import StoreKit;

@interface UpgradesViewController : UIViewController <UpgradeViewDelegate, SKProductsRequestDelegate>

@property (weak, nonatomic) IBOutlet UILabel *upgradeTitleLabel;
@property (nonatomic) NSArray * upgrades;
@property (nonatomic) Upgrade * activeUpgrade;
@property (nonatomic) SKView * animatedBackgroundSKView;
@property (weak, nonatomic) IBOutlet UIView *shadingView;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView1;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView2;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView3;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView4;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView5;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView6;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView7;
@property (weak, nonatomic) IBOutlet UpgradeView *upgradeView8;
@property (weak, nonatomic) IBOutlet UILabel *availablePointsLabel;
@property (nonatomic) BOOL animatingUpgradeView;

@property (nonatomic) SKProductsRequest * productsRequest;
@property (nonatomic) NSArray * products;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backAction:(id)sender;

@property (nonatomic) DGActivityIndicatorView * activityIndicator;
@property (nonatomic) UIView * activityIndicatorBackground;

@end
