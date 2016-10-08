//
//  UpgradeCell.h
//  SpaceAttack
//
//  Created by charles johnston on 8/22/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Upgrade.h"

@class UpgradeCell;
@protocol UpgradeCellDelegate <NSObject>
- (void) minimizePressed:(UpgradeCell *)upgradeCell;
- (void) purchasedWithPoints:(float)pointsSpent;
- (void) purchaseWithMoneyPressed:(Upgrade *)upgrade;
@end


@interface UpgradeCell : UITableViewCell

@property (weak, nonatomic) id <UpgradeCellDelegate>delegate;

@property (nonatomic) Upgrade * myUpgrade;
- (instancetype) initWithUpgrade:(Upgrade*)upgrade;

- (void) showMinimizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion;
- (void) showMaximizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion;

- (void) updateContentWithUpgrade:(Upgrade *)upgrade;

- (void) updateMinimizedCellHeight:(float)height;

- (void) showPurchasedLabelAnimated:(BOOL)animated;

@end
