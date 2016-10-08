//
//  PurchaseShipView.h
//  SpaceAttack
//
//  Created by charles johnston on 9/4/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Upgrade.h"
#import "Spaceship.h"

@protocol PurchaseShipViewDelegate <NSObject>
- (void) purchaseWithMoneyPressed:(Spaceship *)spacehship;
- (void) purchasedWithPoints:(Spaceship *)spaceship;
- (void) closeViewPressed;
@end


@interface PurchaseShipView : UIView

@property (nonatomic, weak) id <PurchaseShipViewDelegate>delegate;
- (void) updateContentWithSpaceship:(Spaceship *)spaceship;
- (void) showPurchasedLabelAnimated:(BOOL)animated;

@end
