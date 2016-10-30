//
//  Upgrade.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumTypes.h"
#import "FLAnimatedImage.h"

@interface Upgrade : NSObject

- (instancetype) initWithUpgradeType:(UpgradeType)upgradeType;

@property (nonatomic) NSString * storeKitIdentifier;
@property (nonatomic) UpgradeType upgradeType;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * upgradeDescription;
@property (nonatomic) int pointsToUnlock;
@property (nonatomic) UIImage * icon;
@property (nonatomic) FLAnimatedImage * animatedImage;
@property (nonatomic) BOOL isUnlocked;
@property (nonatomic) NSString * priceString;
@property (nonatomic) NSDecimalNumber * price;
@property (nonatomic) BOOL isValidForMoneyPurchase;

//menu
@property (nonatomic) BOOL isMaximized;

@end
