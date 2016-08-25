//
//  UpgradeCell.h
//  SpaceAttack
//
//  Created by charles johnston on 8/22/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Upgrade.h"

@interface UpgradeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet UIView *heightConstraintView;

- (void) showMinimizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion;
- (void) showMaximizedContent:(BOOL)show animated:(BOOL)animated completion:(void (^)())completion;

- (void) createContentFromUpgrade:(Upgrade *)upgrade;

@end
