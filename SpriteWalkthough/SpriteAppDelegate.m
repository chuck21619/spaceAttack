//
//  SpriteAppDelegate.m
//  SpriteWalkthough
//
//  Created by chuck on 3/25/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "SpriteAppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "FullScreenAdSingleton.h"
#import "AccountManager.h"
#import "AudioManager.h"
@import StoreKit;

@implementation SpriteAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //crashlytics
    [Fabric with:@[[Crashlytics class]]];
    
    //ads
    [[FullScreenAdSingleton sharedInstance] createAndLoadFullScreenAd];
    
    //store kit
    AccountManager * accountManager = [AccountManager sharedInstance];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:accountManager];
    
    //background music
    [[AudioManager sharedInstance] playMenuMusic];
    
    //reachability
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appWillResignActive" object:nil];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"applicationWillTerminate");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[AccountManager sharedInstance].userDefaults synchronize];
}

- (void) applicationProtectedDataDidBecomeAvailable:(UIApplication *)application
{
    NSLog(@"applicationProtectedDataDidBecomeAvailable");
    [NSUserDefaults resetStandardUserDefaults];
}

- (void) applicationProtectedDataWillBecomeUnavailable:(UIApplication *)application
{
    NSLog(@"applicationProtectedDataWillBecomeUnavailable");
}

- (void) addGlowToLayer:(CALayer *)layer withColor:(CGColorRef)color
{
    [self addGlowToLayer:layer withColor:color size:4.0];
}

- (void) addGlowToLayer:(CALayer *)layer withColor:(CGColorRef)color size:(float)size
{
    layer.shadowColor = color;
    layer.shadowRadius = size;
    layer.shadowOpacity = 1;
    layer.shadowOffset = CGSizeZero;
    layer.masksToBounds = NO;
    layer.shouldRasterize = YES;
    layer.rasterizationScale = UIScreen.mainScreen.scale;
}

@end
