//
//  AchievementCell.m
//  SpaceAttack
//
//  Created by charles johnston on 9/25/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "AchievementCell.h"
#import "AccountManager.h"

@implementation AchievementCell
{
    UIImageView * _imageView;
    UILabel * _nameLabel;
    UILabel * _dateLabel;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    _imageView = [UIImageView new];
    _nameLabel = [UILabel new];
    _dateLabel = [UILabel new];
    
    [_nameLabel setFont:[UIFont fontWithName:NSLocalizedString(@"font3", nil) size:17]];
    [_dateLabel setFont:[UIFont fontWithName:NSLocalizedString(@"font2", nil) size:12]];
    
    _nameLabel.textColor = [UIColor colorWithWhite:.5 alpha:1];
    _dateLabel.textColor = [UIColor colorWithWhite:.67 alpha:1];
    
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    _nameLabel.minimumScaleFactor = .1;
    
    [self.contentView addSubview:_imageView];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_dateLabel];
    
    [self adjustForDeviceSize];
}

- (void) adjustForDeviceSize
{
    float width = [UIScreen mainScreen].bounds.size.width;
    
    _imageView.frame = CGRectMake(width*0.078125, width*0.0375, width*0.265625, width*0.265625);
    _nameLabel.frame = CGRectMake(width*0.3875, width*0.1125, width*0.496875, width*0.065625);
    _dateLabel.frame = CGRectMake(width*0.3875, width*0.159375, width*0.496875, width*0.065625);
    
    [_nameLabel setFont:[_nameLabel.font fontWithSize:width*0.053125]];
    [_dateLabel setFont:[_dateLabel.font fontWithSize:width*0.0375]];
}

- (void) updateContentWithAchievement:(GKAchievement *)achievement description:(NSString *)description
{
    _nameLabel.text = description;
    
    if ( achievement.percentComplete >= 100 )
    {
        NSString * imageName = [NSString stringWithFormat:@"%@.png", achievement.identifier];
        [_imageView setImage:[UIImage imageNamed:imageName]];
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        _dateLabel.text = [dateFormatter stringFromDate:achievement.lastReportedDate];
    }
    else
    {
        [_imageView setImage:[UIImage imageNamed:@"Stick Here.png"]];
        _dateLabel.text = [NSString stringWithFormat:@"%i%%", (int)achievement.percentComplete];
    }
}

@end
