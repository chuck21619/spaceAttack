//
//  SpriteAppDelegate.h
//  SpriteWalkthough
//
//  Created by chuck on 3/25/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

#define _AppDelegate ((SpriteAppDelegate *)[[UIApplication sharedApplication] delegate])

//colors
#define _SAPink [UIColor colorWithRed:255.0/255.0 green:113.0/255.0 blue:223.0/255.0 alpha:1]
#define _SAGreen [UIColor colorWithRed:10.0/255.0 green:252.0/255.0 blue:10.0/255.0 alpha:1]

#define kUpgradeTableWillAnimate @"upgradeTableWillAnimate"
#define kUpgradeTableDidAnimate @"upgradeTableDidAnimate"

@interface SpriteAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) Reachability * internetReachability;

- (void) addGlowToLayer:(CALayer *)layer withColor:(CGColorRef)color;
- (void) addGlowToLayer:(CALayer *)layer withColor:(CGColorRef)color size:(float)size;
- (void) removeGlowFromLayer:(CALayer*)layer;

- (void)addEdgeConstraint:(NSLayoutAttribute)edge superview:(UIView *)superview subview:(UIView *)subview;

@end
