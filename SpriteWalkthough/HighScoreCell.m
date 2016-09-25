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
    _rankLabel = [UILabel new];
    _nameLabel = [UILabel new];
    _scoreLabel = [UILabel new];
    
    _rankLabel.font = [UIFont fontWithName:@"Cooper Std" size:50];
    _nameLabel.font = [UIFont fontWithName:@"Cooper Std" size:24];
    _scoreLabel.font = [UIFont fontWithName:@"Cooper Std" size:18];
    
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
    _rankLabel.frame = CGRectMake(0, 10, 121, 69);
    _nameLabel.frame = CGRectMake(129, 15, 162, 37);
    _scoreLabel.frame = CGRectMake(129, 50, 151, 21);
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
