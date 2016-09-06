//
//  GameplayControls.m
//  SpaceAttack
//
//  Created by chuck johnston on 3/16/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "GameplayControls.h"

@implementation GameplayControls
static GameplayControls * sharedGameplayControls = nil;
+ (GameplayControls *)sharedInstance
{
    if ( sharedGameplayControls == nil )
    {
        sharedGameplayControls = [[GameplayControls alloc] init];
        sharedGameplayControls.isCalibrated = NO;
        sharedGameplayControls.myMotionManager = [[CMMotionManager alloc] init];
        [sharedGameplayControls configureAcceleromterHandler];
        sharedGameplayControls.myMotionManager.accelerometerUpdateInterval = .1;
        CMAcceleration defaultCalibration = {0, 0, -1}; //not sure if i need this
        sharedGameplayControls.initialAcceleration = defaultCalibration;
        sharedGameplayControls.calibrationHeadings = [[NSMutableArray alloc] init];
//        sharedGameplayControls.myLocationManager = [[CLLocationManager alloc] init];
//        sharedGameplayControls.myLocationManager.delegate = sharedGameplayControls;
    }
    
    return sharedGameplayControls;
}

- (void)calibrate:(void (^)())callBack
{
    NSMutableArray * accelerometerUpdates = [[NSMutableArray alloc] init];
    [self performSelector:@selector(stopCalibration:) withObject:@[accelerometerUpdates, callBack] afterDelay:2.5];
    [self.calibrationHeadings removeAllObjects];
    [self.myLocationManager startUpdatingHeading];
    [self startControllerUpdates];
}

- (void) configureAcceleromterHandler
{
    __weak typeof(self) weakSelf = self;
    self.accelerometerHandler = ^(CMAccelerometerData *accelerometerData, NSError *error)
    {
        //NSLog(@"Accelerometer : %@", accelerometerData);
        
        if ( ! weakSelf.isCalibrated )
            [weakSelf.calibrationAccelerations addObject:accelerometerData];
        else
        {
            if ( weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didUpdateAcceleration:)] )
                [weakSelf.delegate didUpdateAcceleration:accelerometerData.acceleration];
        }
    };
}

- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    //NSLog(@"Location Heading : %@", newHeading);
    
    if ( ! self.isCalibrated )
        [self.calibrationHeadings addObject:newHeading];
    else if ( [self.delegate respondsToSelector:@selector(didUpdateHeading:)] )
        [self.delegate didUpdateHeading:newHeading];
}

- (void) stopCalibration:(NSArray *)arguments
{
    NSArray * accelerometerUpdates = [arguments firstObject];
    void (^callBack)() = [arguments lastObject];
    
    [self.myMotionManager stopAccelerometerUpdates];
    //[self.myLocationManager stopUpdatingHeading];
    
    CMAcceleration averages;
    for ( CMAccelerometerData * tmpCMAccelerometerData in accelerometerUpdates )
    {
        averages.x += tmpCMAccelerometerData.acceleration.x;
        averages.y += tmpCMAccelerometerData.acceleration.y;
        averages.z += tmpCMAccelerometerData.acceleration.z;
    }
    averages.x /= accelerometerUpdates.count;
    averages.y /= accelerometerUpdates.count;
    averages.z /= accelerometerUpdates.count;
    self.initialAcceleration = averages;
    
    self.initialHeading = 0;
    for ( CLHeading * tmpHeading in self.calibrationHeadings )
        self.initialHeading += tmpHeading.magneticHeading;
    
    self.initialHeading /= self.calibrationHeadings.count;
    
    NSLog(@"calibration : x %f y %f z %f",  averages.x, averages.y, averages.z);
    NSLog(@"heading: %f", self.initialHeading);
    self.isCalibrated = YES;
    
    if (callBack)
        callBack();
}

- (void) startControllerUpdates
{
    [self.myMotionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:self.accelerometerHandler];
    //[self.myLocationManager startUpdatingHeading];
}

- (void) stopControllerUpdates
{
    [self.myMotionManager stopAccelerometerUpdates];
    //[self.myLocationManager stopUpdatingHeading];
}

@end
