//
//  UpgradesViewController.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "DGActivityIndicatorView.h"
#import "Upgrade.h"
#import <UIKit/UIKit.h>
@import StoreKit;


@interface UpgradesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate>

@property NSArray * upgrades;
@property Upgrade * activeUpgrade;

@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMyTable;

@property (weak, nonatomic) IBOutlet UILabel *upgradeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *availablePointsLabel;

@property (nonatomic) SKProductsRequest * productsRequest;
@property (nonatomic) NSArray * products;
@property (nonatomic) DGActivityIndicatorView * activityIndicator;
@property (nonatomic) UIView * activityIndicatorBackground;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backAction:(id)sender;

@end
