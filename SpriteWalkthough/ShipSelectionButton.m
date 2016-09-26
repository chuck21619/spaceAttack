//
//  ShipSelectionButton.m
//  SpaceAttack
//
//  Created by charles johnston on 8/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "ShipSelectionButton.h"
#import "ShipSelectMeter.h"
#import "SpriteAppDelegate.h"
#import "AccountManager.h"

@implementation ShipSelectionButton
{
    BOOL _contentCreated;
    
    UIView * _borderView;
    UIImageView * _spaceshipImageView;
    UILabel * _shipNameLabel;
    UILabel * _damageLabel;
    UILabel * _armorLabel;
    UILabel * _speedLabel;
    ShipSelectMeter * _damageMeter;
    ShipSelectMeter * _armorMeter;
    ShipSelectMeter * _speedMeter;
    UIImageView * _lockedIcon;
}

- (void) layoutSubviews
{
    if ( ! _contentCreated )
    {
        float width = self.frame.size.width;

        _borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, self.frame.size.height)];
        _borderView.layer.cornerRadius = self.frame.size.height/2;
        _borderView.backgroundColor = [UIColor clearColor];
        _borderView.layer.borderWidth = width*.005;
        _borderView.layer.borderColor = [UIColor whiteColor].CGColor;
        _borderView.userInteractionEnabled = NO;
        [self addSubview:_borderView];
        //[_AppDelegate addGlowToLayer:_borderView.layer withColor:[UIColor whiteColor].CGColor];

        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.backgroundColor = [UIColor clearColor];
        float adjustedHeight = self.frame.size.height;//-2;

        _spaceshipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*.0405, width*.0304, width*.203, adjustedHeight-(width*.068))];
        [_spaceshipImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:_spaceshipImageView];
        //[_AppDelegate addGlowToLayer:_spaceshipImageView.layer withColor:[UIColor whiteColor].CGColor];

        _shipNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.220, width*.047, width*.321, width*.101)];
        _shipNameLabel.text = @"Display Name";
        _shipNameLabel.textColor = [UIColor whiteColor];
        _shipNameLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.047];
        _shipNameLabel.textAlignment = NSTextAlignmentCenter;
        //[_AppDelegate addGlowToLayer:_shipNameLabel.layer withColor:_shipNameLabel.textColor.CGColor];
        [self addSubview:_shipNameLabel];

        float yCoordFirstRow = 4;
        float yCoordSecondRow = ((adjustedHeight-10)/3)+3;
        float yCoordThirdRow = (((adjustedHeight-10)/3)*2)+2;

        _damageLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.557, yCoordFirstRow-1, width*.128, (adjustedHeight-5)/3)];
        _damageLabel.text = NSLocalizedString(@"damage", nil);
        _damageLabel.textColor = [UIColor whiteColor];
        _damageLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:width*.068];
        _damageLabel.textAlignment = NSTextAlignmentRight;
        _damageLabel.adjustsFontSizeToFitWidth = YES;
        _damageLabel.minimumScaleFactor = .1;
        //[_AppDelegate addGlowToLayer:damageLabel.layer withColor:damageLabel.textColor.CGColor];
        [self addSubview:_damageLabel];

        _armorLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.557, yCoordSecondRow+1, width*.128, (adjustedHeight-5)/3)];
        _armorLabel.text = NSLocalizedString(@"armor", nil);
        _armorLabel.textColor = [UIColor whiteColor];
        _armorLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:[self getActualFontSizeForLabel:_damageLabel]];
        _armorLabel.textAlignment = NSTextAlignmentRight;
        _armorLabel.adjustsFontSizeToFitWidth = YES;
        _armorLabel.minimumScaleFactor = .1;
        //[_AppDelegate addGlowToLayer:armorLabel.layer withColor:armorLabel.textColor.CGColor];
        [self addSubview:_armorLabel];

        _speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.557, yCoordThirdRow, width*.128, (adjustedHeight-5)/3)];
        _speedLabel.text = NSLocalizedString(@"speed", nil);
        _speedLabel.textColor = [UIColor whiteColor];
        _speedLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:[self getActualFontSizeForLabel:_damageLabel]];
        _speedLabel.textAlignment = NSTextAlignmentRight;
        _speedLabel.adjustsFontSizeToFitWidth = YES;
        _speedLabel.minimumScaleFactor = .1;
        //[_AppDelegate addGlowToLayer:speedLabel.layer withColor:speedLabel.textColor.CGColor];
        [self addSubview:_speedLabel];

        _damageMeter = [[ShipSelectMeter alloc] initWithFrame:CGRectMake(width*.696, yCoordFirstRow, width*.152, (adjustedHeight-5)/3)];
        [_damageMeter setUserInteractionEnabled:NO];
        [self addSubview:_damageMeter];

        _armorMeter = [[ShipSelectMeter alloc] initWithFrame:CGRectMake(width*.696, yCoordSecondRow, width*.152, (adjustedHeight-5)/3)];
        [_armorMeter setUserInteractionEnabled:NO];
        [self addSubview:_armorMeter];

        _speedMeter = [[ShipSelectMeter alloc] initWithFrame:CGRectMake(width*.696, yCoordThirdRow, width*.152, (adjustedHeight-5)/3)];
        [_speedMeter setUserInteractionEnabled:NO];
        [self addSubview:_speedMeter];


        _lockedIcon = [[UIImageView alloc] initWithFrame:CGRectMake(width*.878, 0, width*.068, adjustedHeight)];
        [_lockedIcon setContentMode:UIViewContentModeScaleAspectFit];
        [_lockedIcon setImage:[UIImage imageNamed:@"Lock.png"]];
        [self addSubview:_lockedIcon];


        if ( self.spaceship )
            [self setupForSpaceship:self.spaceship];
            
        _contentCreated = YES;
    }
}

- (void) refreshContent
{
    if ( [_spaceship isUnlocked] )
        _lockedIcon.alpha = 0;
    else
        _lockedIcon.alpha = 1;
}

- (void) setupForSpaceship:(Spaceship *)spaceship
{
    [_spaceshipImageView setImage:[UIImage imageNamed:NSStringFromClass([spaceship class])]];
    [_shipNameLabel setText:NSLocalizedString(NSStringFromClass([spaceship class]), nil)];
    [_damageMeter fillToPercentage:spaceship.damage/18.0];
    [_armorMeter fillToPercentage:spaceship.armor/18.0];
    [_speedMeter fillToPercentage:spaceship.mySpeed/18.0];
    
    
    if ( [AccountManager availablePoints] >= spaceship.pointsToUnlock )
        [_lockedIcon setImage:[UIImage imageNamed:@"LockGreen.png"]];
    else
        [_lockedIcon setImage:[UIImage imageNamed:@"Lock.png"]];
        
    
    if ( [spaceship isUnlocked] )
        _lockedIcon.alpha = 0;
    else
        _lockedIcon.alpha = 1;
    
    self.spaceship = spaceship;
}

- (void) addGlowAnimated
{
    [_AppDelegate addGlowToLayer:_borderView.layer withColor:[UIColor whiteColor].CGColor size:0];
    [_AppDelegate addGlowToLayer:_spaceshipImageView.layer withColor:[UIColor whiteColor].CGColor size:0];
    [_AppDelegate addGlowToLayer:_shipNameLabel.layer withColor:_shipNameLabel.textColor.CGColor size:0];
    [_AppDelegate addGlowToLayer:_damageLabel.layer withColor:_damageLabel.textColor.CGColor size:0];
    [_AppDelegate addGlowToLayer:_armorLabel.layer withColor:_armorLabel.textColor.CGColor size:0];
    [_AppDelegate addGlowToLayer:_speedLabel.layer withColor:_speedLabel.textColor.CGColor size:0];
    
    _borderView.layer.shadowRadius = 4.0;
    _spaceshipImageView.layer.shadowRadius = 4.0;
    _shipNameLabel.layer.shadowRadius = 4.0;
    _damageLabel.layer.shadowRadius = 4.0;
    _armorLabel.layer.shadowRadius = 4.0;
    _speedLabel.layer.shadowRadius = 4.0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:1.0];
    animation.duration = .5;
    animation.fillMode = kCAFillModeForwards;
    
    [_borderView.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_spaceshipImageView.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_shipNameLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_damageLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_armorLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    [_speedLabel.layer addAnimation:animation forKey:@"shadowOpacity"];
    
    _borderView.layer.shadowOpacity = 1;
    _spaceshipImageView.layer.shadowOpacity = 1;
    _shipNameLabel.layer.shadowOpacity = 1;
    _damageLabel.layer.shadowOpacity = 1;
    _armorLabel.layer.shadowOpacity = 1;
    _speedLabel.layer.shadowOpacity = 1;
    
    self.userInteractionEnabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animation.duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^
    {
        self.userInteractionEnabled = YES;
    });
}

- (CGFloat)getActualFontSizeForLabel:(UILabel *)label
{
    NSStringDrawingContext *labelContext = [NSStringDrawingContext new];
    labelContext.minimumScaleFactor = label.minimumScaleFactor;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:label.text attributes:@{ NSFontAttributeName: label.font }];
    [attributedString boundingRectWithSize:label.frame.size
                                   options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   context:labelContext];
    
    CGFloat actualFontSize = label.font.pointSize * labelContext.actualScaleFactor;
    return actualFontSize;
}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ( _borderView.layer.borderWidth )
    {
        CABasicAnimation * color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        color.duration = .08;
        color.fromValue = (id)self.currentTitleColor.CGColor;
        color.toValue   = (id)[UIColor clearColor].CGColor;
        _borderView.layer.borderColor = [UIColor clearColor].CGColor;
        [_borderView.layer addAnimation:color forKey:@"color"];
    }
    
    [super touchesBegan:touches withEvent:event];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ( _borderView.layer.borderWidth )
    {
        CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
        color.duration = .08;
        color.fromValue = (id)[UIColor clearColor].CGColor;
        color.toValue   = (id)self.currentTitleColor.CGColor;
        _borderView.layer.borderColor = self.currentTitleColor.CGColor;
        [_borderView.layer addAnimation:color forKey:@"color"];
    }
    
    [super touchesEnded:touches withEvent:event];
}


@end
