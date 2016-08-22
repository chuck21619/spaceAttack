//
//  ShipSelectMeter.m
//  SpaceAttack
//
//  Created by charles johnston on 8/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "ShipSelectMeter.h"

@implementation ShipSelectMeter
{
    UIImageView * _notch1;
    UIImageView * _notch2;
    UIImageView * _notch3;
    UIImageView * _notch4;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] )
    {
        _notch1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width/4, frame.size.height)];
        _notch2 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/4, 0, frame.size.width/4, frame.size.height)];
        _notch3 = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2, 0, frame.size.width/4, frame.size.height)];
        _notch4 = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width/4)*3, 0, frame.size.width/4, frame.size.height)];
        
        [_notch1 setContentMode:UIViewContentModeScaleAspectFit];
        [_notch2 setContentMode:UIViewContentModeScaleAspectFit];
        [_notch3 setContentMode:UIViewContentModeScaleAspectFit];
        [_notch4 setContentMode:UIViewContentModeScaleAspectFit];
        
        [self addSubview:_notch1];
        [self addSubview:_notch2];
        [self addSubview:_notch3];
        [self addSubview:_notch4];
    }
    return self;
}

- (void) fillToPercentage:(float)percent
{
    UIImage * nodeOn = [UIImage imageNamed:@"Node_on.png"];
    UIImage * nodeOff = [UIImage imageNamed:@"Node_off.png"];
    
    if ( percent > .125)
        [_notch1 setImage:nodeOn];
    else
        [_notch1 setImage:nodeOff];
    
    if ( percent > .375 )
        [_notch2 setImage:nodeOn];
    else
        [_notch2 setImage:nodeOff];
    
    if ( percent > .625)
        [_notch3 setImage:nodeOn];
    else
        [_notch3 setImage:nodeOff];
    
    if ( percent > .875)
        [_notch4 setImage:nodeOn];
    else
        [_notch4 setImage:nodeOff];
}

@end
