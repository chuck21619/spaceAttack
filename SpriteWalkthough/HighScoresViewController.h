//
//  HighScoresViewController.h
//  SpaceAttack
//
//  Created by charles johnston on 9/17/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HighScoresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *highScoresTableView;
@property (weak, nonatomic) IBOutlet UIView *tableViewContainerForGradientMask;
@property (weak, nonatomic) IBOutlet UILabel *userRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *userScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBackButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopTableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingTableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingTableContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomTableContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthUserRank;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomUserRank;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopUserName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingUserName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomUserName;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopUserScore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomUserScore;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightPageControl;

@end
