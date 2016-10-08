//
//  HighScoreCell.h
//  SpaceAttack
//
//  Created by charles johnston on 9/25/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

@interface HighScoreCell : UITableViewCell

- (void) updateContentWithScore:(GKScore *)score;

@end
