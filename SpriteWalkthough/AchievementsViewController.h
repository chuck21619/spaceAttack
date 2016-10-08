//
//  AchievementsViewController.h
//  SpaceAttack
//
//  Created by charles johnston on 9/24/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AchievementsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *achievementsTitleLabel;

@property (weak, nonatomic) IBOutlet UITableView *achievementTableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainerForGradientMask;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBackButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopTableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingTableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingTableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomTableContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightPageControl;

@end
