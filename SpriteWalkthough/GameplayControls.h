//
//  GameplayControls.h
//  SpaceAttack
//
//  Created by chuck johnston on 3/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreMotion;
@import CoreLocation;



@protocol GameplayControlsDelegate <NSObject>
- (void) didUpdateAcceleration:(CMAcceleration)acceleration;
@optional
- (void) didUpdateHeading:(CLHeading*)newHeading;
@end



typedef void (^AccelerometerHandler)(CMAccelerometerData *accelerometerData, NSError *error);

@interface GameplayControls : NSObject <CLLocationManagerDelegate>

+ (GameplayControls *)sharedInstance;

@property (nonatomic, weak) id <GameplayControlsDelegate> delegate;
@property (nonatomic, copy) AccelerometerHandler accelerometerHandler;

@property (nonatomic) BOOL isCalibrated;

@property (nonatomic) CMMotionManager * myMotionManager;
@property (nonatomic) NSMutableArray * calibrationAccelerations;
@property (nonatomic) CMAcceleration initialAcceleration;

@property (nonatomic) CLLocationManager * myLocationManager;
@property (nonatomic) NSMutableArray * calibrationHeadings;
@property (nonatomic) CLLocationDirection initialHeading;

- (void)calibrate:(void(^)())callBack;
- (void)startControllerUpdates;
- (void)stopControllerUpdates;

@end
