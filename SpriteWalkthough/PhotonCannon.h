//
//  PhotonCannon.h
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "PlayerWeapon.h"
#import "Photon.h"

@interface PhotonCannon : PlayerWeapon

@property (nonatomic) SKTexture * projectileTexture;
@property (nonatomic) BOOL smartPhotons;

@end
