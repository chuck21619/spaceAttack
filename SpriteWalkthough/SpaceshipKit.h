//
//  SpaceshipKit.h
//  SpaceAttack
//
//  Created by chuck johnston on 2/22/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Abdul_Kadir.h"
#import "Babenberg.h"
#import "Caiman.h"
#import "Dandolo.h"
#import "Edinburgh.h"
#import "Flandre.h"
#import "Gascogne.h"
#import "Habsburg.h"

@interface SpaceshipKit : NSObject

+ (SpaceshipKit *)sharedInstance;

@property (nonatomic) NSDictionary * shipTextures;
@property (nonatomic) NSArray * explosionFrames;
- (NSArray *) texturesForPreloading:(Spaceship*)spaceship;

@end
