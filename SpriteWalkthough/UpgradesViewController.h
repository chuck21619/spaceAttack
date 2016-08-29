//
//  UpgradesViewController.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "DGActivityIndicatorView.h"
#import "Upgrade.h"
#import "UpgradeCell.h"
#import <UIKit/UIKit.h>
@import StoreKit;


@interface UpgradesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, UpgradeCellDelegate>

@property NSArray * upgrades;
@property Upgrade * activeUpgrade;

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMyTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingMyTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingMyTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomMyTable;

@property (weak, nonatomic) IBOutlet UILabel *upgradeTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *availablePointsLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightAvailablePoints;

@property (nonatomic) SKProductsRequest * productsRequest;
@property (nonatomic) NSArray * products;
@property (nonatomic) DGActivityIndicatorView * activityIndicator;
@property (nonatomic) UIView * activityIndicatorBackground;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBackButton;
- (IBAction)backAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewForSKView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomViewForSKView;

@end
