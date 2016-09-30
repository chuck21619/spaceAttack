//
//  HighScoreCell.m
//  SpaceAttack
//
//  Created by charles johnston on 9/25/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "HighScoreCell.h"
#import "SpriteAppDelegate.h"

@implementation HighScoreCell
{
    UILabel * _rankLabel;
    UILabel * _nameLabel;
    UILabel * _scoreLabel;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    _rankLabel = [UILabel new];
    _nameLabel = [UILabel new];
    _scoreLabel = [UILabel new];
    
    _rankLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:50];
    _nameLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:24];
    _scoreLabel.font = [UIFont fontWithName:NSLocalizedString(@"font3", nil) size:18];
    
    _rankLabel.textColor = [UIColor darkGrayColor];
    _nameLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    _scoreLabel.textColor = [UIColor lightGrayColor];
    
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = .2;
    
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:_rankLabel];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_scoreLabel];
    
    [self adjustForDeviceSize];
}

- (void) adjustForDeviceSize
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    _rankLabel.frame = CGRectMake(0, width*0.03125, width*0.378125, width*0.215625);
    _nameLabel.frame = CGRectMake(width*0.403125, width*0.046875, width*0.50625, width*0.115625);
    _scoreLabel.frame = CGRectMake(width*0.403125, width*0.15625, width*0.471875, width*0.065625);
    
    _rankLabel.font = [_rankLabel.font fontWithSize:width*0.15625];
    _nameLabel.font = [_nameLabel.font fontWithSize:width*0.075];
    _scoreLabel.font = [_scoreLabel.font fontWithSize:width*0.05625];
    
}

- (void) updateContentWithScore:(GKScore *)score
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    _rankLabel.text = [numberFormatter stringFromNumber:@((int)score.rank)];
    _nameLabel.text = score.player.alias;
    _scoreLabel.text = [numberFormatter stringFromNumber:@((int)score.value)];
    
    if ( [[GKLocalPlayer localPlayer].alias isEqualToString:score.player.alias] )
        _nameLabel.textColor = _SAPink;
    else
        _nameLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
}

@end
