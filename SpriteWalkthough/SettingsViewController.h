//
//  SettingsViewController.h
//  SpaceAttack
//
//  Created by charles johnston on 6/19/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlowingButton.h"
#import "SASlider.h"

@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet GlowingButton *backButton;

@property (weak, nonatomic) IBOutlet UILabel *settingsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *soundEffectsLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicLabel;
@property (weak, nonatomic) IBOutlet UILabel *vibrateLabel;

@property (weak, nonatomic) IBOutlet SASlider *musicVolumeSlider;
@property (weak, nonatomic) IBOutlet SASlider *soundEffectsVolumeSlider;

@property (nonatomic) NSTimer * musicUpdater;
@property (nonatomic) NSTimer * soundEffectUpdater;

@property (weak, nonatomic) IBOutlet UISwitch *vibrateSwitch;

@property (weak, nonatomic) IBOutlet UILabel *controlsLabel;
@property (weak, nonatomic) IBOutlet UIButton *controlsButton;

@property (weak, nonatomic) IBOutlet UIButton *resetTutorialButton;

@property (weak, nonatomic) IBOutlet GlowingButton *helpButton;
- (IBAction)helpAction:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingBack;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingSettings;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingSettings;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingSFX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSFX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingSFX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeadingSFXSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingSFXSlider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopSFXSlider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMusic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopMusicSlider;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopVibrate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingVibrate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopVibrateSwitch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintHeightHelp;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopControls;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTrailingControls;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintWidthControlsButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTopResetTutorial;



@end
