//
//  ElectricalGenerator.h
//  SpriteWalkthough
//
//  Created by chuck on 6/7/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerWeapon.h"
#import "Electricity.h"

@interface ElectricalGenerator : PlayerWeapon

@property (nonatomic) NSMutableArray * electricityFrames;
@property (nonatomic) float electricityDamageFrequency;
@property (nonatomic) BOOL electricityChainUnlocked;

- (void) firstElectricityTargetUpdate:(SKNode *)target;

@end
