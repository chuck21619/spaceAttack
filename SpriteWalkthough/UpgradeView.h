//
//  UpgradeView.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Upgrade.h"
#import "UpgradeScene.h"

@class UpgradeView;
@protocol UpgradeViewDelegate <NSObject>
- (void) willMaximizeUpgradeView:(UpgradeView *)upgradeView;
- (void) didMaximizeUpgradeView:(UpgradeView *)upgradeView;
- (void) willMinimizeUpgradeView:(UpgradeView *)upgradeView;
- (void) didMinimizeUpgradeView:(UpgradeView *)upgradeView;
- (void) unlockWithPointsPressed:(UpgradeView *)upgradeView;
- (void) unlockWithMoneyPressed:(UpgradeView *)upgradeView;
@end


@interface UpgradeView : UIView

@property (nonatomic, strong) IBOutlet UIView * view;
@property (nonatomic, weak) id <UpgradeViewDelegate> delegate;

- (void) setupForUpgrade:(Upgrade *)upgrade;
- (void) refreshView;
- (void) minimizeViewAnimated:(BOOL)animated;
- (void) maximizeViewAnimated:(BOOL)animated;
@property (nonatomic) CGRect minimizedFrame;
@property (nonatomic) CGRect maximizedFrame;
@property (nonatomic) BOOL isMinimized;
@property (nonatomic) BOOL isMinimizing;
@property (nonatomic) BOOL isMaximizing;
@property (weak, nonatomic) IBOutlet UIImageView *minimizedIcon;
@property (nonatomic) Upgrade * upgrade;
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForSKView;
@property (nonatomic) SKView * skView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *unlockWithPointsButton;
@property (weak, nonatomic) IBOutlet UIButton *unlockWithMoneyButton;
- (IBAction)unlockWithPointsAction:(id)sender;
- (IBAction)unlockWithMoneyAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *purchasedLabel;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints1;
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myTopConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *borderImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomBorderImage;

@end
