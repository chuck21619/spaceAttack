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

@implementation ShipSelectionButton
{
    UIImageView * _spaceshipImageView;
    UILabel * _shipNameLabel;
    ShipSelectMeter * _damageMeter;
    ShipSelectMeter * _armorMeter;
    ShipSelectMeter * _speedMeter;
    UIImageView * _lockedIcon;
}

- (void) layoutSubviews
{
    float width = self.frame.size.width;
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layer.cornerRadius = self.frame.size.height/2;
    self.backgroundColor = [UIColor clearColor];
    //[self setBackgroundImage:[UIImage imageNamed:@"buttonSM.png"] forState:UIControlStateNormal];
    self.layer.borderWidth = width*.005;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    float adjustedHeight = self.frame.size.height;//-2;
    
    _spaceshipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*.0405, width*.0304, width*.203, adjustedHeight-(width*.068))];
    [_spaceshipImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:_spaceshipImageView];
    //[_AppDelegate addGlowToLayer:_spaceshipImageView.layer withColor:[UIColor whiteColor].CGColor];
    
    _shipNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.220, width*.047, width*.321, width*.101)];
    _shipNameLabel.text = @"Display Name";
    _shipNameLabel.textColor = [UIColor whiteColor];
    _shipNameLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.047];
    _shipNameLabel.textAlignment = NSTextAlignmentCenter;
    //[_AppDelegate addGlowToLayer:_shipNameLabel.layer withColor:_shipNameLabel.textColor.CGColor];
    [self addSubview:_shipNameLabel];
    
    float yCoordFirstRow = 4;
    float yCoordSecondRow = ((adjustedHeight-10)/3)+3;
    float yCoordThirdRow = (((adjustedHeight-10)/3)*2)+2;
    
    UILabel * damageLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.557, yCoordFirstRow-1, width*.128, (adjustedHeight-5)/3)];
    damageLabel.text = NSLocalizedString(@"damage", nil);
    damageLabel.textColor = [UIColor whiteColor];
    damageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:width*.068];
    damageLabel.textAlignment = NSTextAlignmentRight;
    damageLabel.adjustsFontSizeToFitWidth = YES;
    damageLabel.minimumScaleFactor = .1;
    //[_AppDelegate addGlowToLayer:damageLabel.layer withColor:damageLabel.textColor.CGColor];
    [self addSubview:damageLabel];
    
    UILabel * armorLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.557, yCoordSecondRow+1, width*.128, (adjustedHeight-5)/3)];
    armorLabel.text = NSLocalizedString(@"armor", nil);
    armorLabel.textColor = [UIColor whiteColor];
    armorLabel.font = [UIFont fontWithName:@"Moon-Bold" size:[self getActualFontSizeForLabel:damageLabel]];
    armorLabel.textAlignment = NSTextAlignmentRight;
    //[_AppDelegate addGlowToLayer:armorLabel.layer withColor:armorLabel.textColor.CGColor];
    [self addSubview:armorLabel];
    
    UILabel * speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*.557, yCoordThirdRow, width*.128, (adjustedHeight-5)/3)];
    speedLabel.text = NSLocalizedString(@"speed", nil);
    speedLabel.textColor = [UIColor whiteColor];
    speedLabel.font = [UIFont fontWithName:@"Moon-Bold" size:[self getActualFontSizeForLabel:damageLabel]];
    speedLabel.textAlignment = NSTextAlignmentRight;
    //[_AppDelegate addGlowToLayer:speedLabel.layer withColor:speedLabel.textColor.CGColor];
    [self addSubview:speedLabel];
    
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
}

- (void) setupForSpaceship:(Spaceship *)spaceship
{
    [_spaceshipImageView setImage:[UIImage imageNamed:spaceship.menuImageName]];
    [_shipNameLabel setText:NSLocalizedString(NSStringFromClass([spaceship class]), nil)];
    [_damageMeter fillToPercentage:spaceship.damage/18.0];
    [_armorMeter fillToPercentage:spaceship.armor/18.0];
    [_speedMeter fillToPercentage:spaceship.mySpeed/18.0];
    
    if ( [spaceship isUnlocked] )
        _lockedIcon.alpha = 0;
    else
        _lockedIcon.alpha = 1;
    
    self.spaceship = spaceship;
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

@end
