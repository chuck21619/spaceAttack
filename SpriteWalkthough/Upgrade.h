//
//  Upgrade.h
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumTypes.h"
#import "UpgradeScene.h"

@interface Upgrade : NSObject

- (instancetype) initWithUpgradeType:(UpgradeType)upgradeType;

@property (nonatomic) NSString * storeKitIdentifier;
@property (nonatomic) UpgradeType upgradeType;
@property (nonatomic) NSString * title;
@property (nonatomic) NSString * upgradeDescription;
@property (nonatomic) int pointsToUnlock;
@property (nonatomic) float priceToUnlock;
@property (nonatomic) UpgradeScene * demoScene;
@property (nonatomic) UIImage * icon;
@property (nonatomic) BOOL isUnlocked;
@property (nonatomic) NSString * priceString;
@property (nonatomic) BOOL isValidForMoneyPurchase;

//menu
@property (nonatomic) BOOL isMaximized;

@end
