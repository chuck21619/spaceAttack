//
//  AchievementCell.h
//  SpaceAttack
//
//  Created by charles johnston on 9/25/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface AchievementCell : UITableViewCell

- (void) updateContentWithAchievement:(GKAchievement *)achievement description:(NSString*)description;

@end
