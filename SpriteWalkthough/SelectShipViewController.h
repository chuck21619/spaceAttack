//
//  SelectShipViewController.h
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShipSelectionButton.h"
@interface SelectShipViewController : UIViewController


@property (nonatomic) NSArray * spaceships;

@property (weak, nonatomic) IBOutlet GlowingButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *selectTitleLabel;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton1;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton2;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton3;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton4;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton5;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton6;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton7;
@property (weak, nonatomic) IBOutlet ShipSelectionButton *shipButton8;

- (IBAction)backAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSelect;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingSelect;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopFirstButton;






@end
