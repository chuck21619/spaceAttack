//
//  SASlider.m
//  SpaceAttack
//
//  Created by Johnston, Charles on 8/29/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "SASlider.h"
#import "SpriteAppDelegate.h"

@implementation SASlider

- (void) awakeFromNib
{
    UIImage * originalThumbImage = [UIImage imageNamed:@"slider bar.png"];
    UIImage * thumbImage = [UIImage imageWithCGImage:[originalThumbImage CGImage] scale:4 orientation:(originalThumbImage.imageOrientation)];
    
    UIImage * originalBarImageMin = [UIImage imageNamed:@"SliderMin.png"];
    UIImage * barImageMin = [UIImage imageWithCGImage:[originalBarImageMin CGImage] scale:5 orientation:(originalBarImageMin.imageOrientation)];
    UIImage * minImage = [barImageMin  resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
    
    UIImage * originalBarImageMax = [UIImage imageNamed:@"Slider.png"];
    UIImage * barImageMax = [UIImage imageWithCGImage:[originalBarImageMax CGImage] scale:5 orientation:(originalBarImageMax.imageOrientation)];
    
    
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    [self setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:barImageMax forState:UIControlStateNormal];
    
    [_AppDelegate addGlowToLayer:self.layer withColor:[UIColor whiteColor].CGColor size:6.0];
}

- (void) adjustForDeviceWidth:(float)width
{
    UIImage * originalThumbImage = [UIImage imageNamed:@"slider bar.png"];
    UIImage * thumbImage = [UIImage imageWithCGImage:[originalThumbImage CGImage] scale:4.0/(width/320) orientation:(originalThumbImage.imageOrientation)];
    
    UIImage * originalBarImageMin = [UIImage imageNamed:@"SliderMin.png"];
    UIImage * barImageMin = [UIImage imageWithCGImage:[originalBarImageMin CGImage] scale:4.0/(width/320)orientation:(originalBarImageMin.imageOrientation)];
    UIImage * minImage = [barImageMin  resizableImageWithCapInsets:UIEdgeInsetsMake(0, width*.0094, 0, width*.0094)];
    
    UIImage * originalBarImageMax = [UIImage imageNamed:@"Slider.png"];
    UIImage * barImageMax = [UIImage imageWithCGImage:[originalBarImageMax CGImage] scale:4.0/(width/320)orientation:(originalBarImageMax.imageOrientation)];
    
    
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    [self setMinimumTrackImage:minImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:barImageMax forState:UIControlStateNormal];
}

@end
