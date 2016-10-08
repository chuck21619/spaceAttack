//
//  SettingsViewController.m
//  SpaceAttack
//
//  Created by charles johnston on 6/19/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "SettingsViewController.h"
#import "AudioManager.h"
#import <SpriteKit/SpriteKit.h>
#import "AccountManager.h"
#import "SpriteAppDelegate.h"

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.backButton.titleLabel.font.pointSize];
    self.settingsTitleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.settingsTitleLabel.font.pointSize];
    self.musicLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.musicLabel.font.pointSize];
    self.soundEffectsLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.soundEffectsLabel.font.pointSize];
    self.vibrateLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.vibrateLabel.font.pointSize];
    self.controlsLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.controlsLabel.font.pointSize];
    self.controlsButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.controlsButton.titleLabel.font.pointSize];
    self.resetTutorialButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.resetTutorialButton.titleLabel.font.pointSize];
    self.helpButton.titleLabel.font = [UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.helpButton.titleLabel.font.pointSize];
    
    
    self.controlsButton.titleLabel.numberOfLines = 1;
    self.controlsButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.controlsButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    self.resetTutorialButton.titleLabel.numberOfLines = 1;
    self.resetTutorialButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.resetTutorialButton.titleLabel.lineBreakMode = NSLineBreakByClipping;
    
    [self adjustForDeviceSize];
    
    [_AppDelegate addGlowToLayer:self.settingsTitleLabel.layer withColor:self.settingsTitleLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.soundEffectsLabel.layer withColor:self.soundEffectsLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.musicLabel.layer withColor:self.musicLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.vibrateLabel.layer withColor:self.vibrateLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.controlsLabel.layer withColor:self.controlsLabel.textColor.CGColor];
    [_AppDelegate addGlowToLayer:self.controlsButton.layer withColor:self.controlsButton.currentTitleColor.CGColor];
    [_AppDelegate addGlowToLayer:self.resetTutorialButton.layer withColor:self.resetTutorialButton.currentTitleColor.CGColor];
}

- (void) viewWillAppear:(BOOL)animated
{
    for ( UIView * subview in [self.view subviews] )
        subview.alpha = 0;
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag == 9 )
            {
                subview.alpha = .1;
                continue;
            }
            
            subview.alpha = 1;
        }
    }];
    
    [self.musicVolumeSlider setValue:[[AudioManager sharedInstance] musicVolume]];
    [self.soundEffectsVolumeSlider setValue:[[AudioManager sharedInstance] soundEffectsVolume]];
    
    [self.vibrateSwitch setOn:[AccountManager isVibrateOn]];
    if ( self.vibrateSwitch.isOn )
        [_AppDelegate addGlowToLayer:self.vibrateSwitch.layer withColor:self.vibrateSwitch.onTintColor.CGColor];
    else
        [_AppDelegate addGlowToLayer:self.vibrateSwitch.layer withColor:[UIColor whiteColor].CGColor];
    
    [UIView performWithoutAnimation:^
    {
        [self updateControlsButton];
        [self.controlsButton layoutIfNeeded];
    }];
    
}

#pragma mark - sliders
#pragma mark music
- (IBAction)musicTouchDown:(id)sender
{
    self.musicUpdater = [NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(musicVolumeUpdate) userInfo:nil repeats:YES];
    [self musicVolumeUpdate];
}

- (void) musicVolumeUpdate
{
    [[AudioManager sharedInstance] setMusicVolume:self.musicVolumeSlider.value];
}

- (IBAction)musicSliderUpInside:(id)sender
{
    [self musicVolumeUpdate];
    [self.musicUpdater invalidate];
}

- (IBAction)musicSliderUpOutside:(id)sender
{
    [self musicVolumeUpdate];
    [self.musicUpdater invalidate];
}

#pragma mark sound effects
- (IBAction)soundEffectsTouchDown:(id)sender
{
    self.soundEffectUpdater =[ NSTimer scheduledTimerWithTimeInterval:.2 target:self selector:@selector(soundEffectsVolumeUpdate) userInfo:nil repeats:YES];
    [self soundEffectsVolumeUpdate];
}

- (void) soundEffectsVolumeUpdate
{
    [[AudioManager sharedInstance] setSoundEffectsVolume:self.soundEffectsVolumeSlider.value];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectLaser];
}

- (IBAction)soundEffectsSliderUpInside:(id)sender
{
    [self soundEffectsVolumeUpdate];
    [self.soundEffectUpdater invalidate];
}

- (IBAction)soundEffectsSliderUpOutside:(id)sender
{
    [self soundEffectsVolumeUpdate];
    [self.soundEffectUpdater invalidate];
}


#pragma mark - Vibrate
- (IBAction)vibrateSwitchChanged:(id)sender
{
    [AccountManager setVibrate:self.vibrateSwitch.isOn];
    if ( self.vibrateSwitch.isOn )
    {
        [[AudioManager sharedInstance] vibrate];
        [_AppDelegate addGlowToLayer:self.vibrateSwitch.layer withColor:self.vibrateSwitch.onTintColor.CGColor];
    }
    else
        [_AppDelegate addGlowToLayer:self.vibrateSwitch.layer withColor:[UIColor whiteColor].CGColor];
}

#pragma mark - controls
- (IBAction)controlsAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
    [[AccountManager sharedInstance] setTouchControls:![[AccountManager sharedInstance] touchControls]];
    [self updateControlsButton];
}

- (void) updateControlsButton
{
    if ( [[AccountManager sharedInstance] touchControls] )
        [self.controlsButton setTitle:NSLocalizedString(@"Touch", nil) forState:UIControlStateNormal];
    else
        [self.controlsButton setTitle:NSLocalizedString(@"Tilt Screen", nil) forState:UIControlStateNormal];
}

#pragma mark - reset tutorial
- (IBAction)resetTutorialAction:(id)sender
{
    [self.resetTutorialButton setTitle:NSLocalizedString(@"Tutorial Reset!", nil) forState:UIControlStateNormal];
    [self.resetTutorialButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_AppDelegate addGlowToLayer:self.resetTutorialButton.layer withColor:self.resetTutorialButton.currentTitleColor.CGColor];
    [self.resetTutorialButton setEnabled:NO];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectToolTip];
    [AccountManager resetTooltips];
}

#pragma mark - misc.
- (IBAction)backButtonAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuBackButton];
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
            subview.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)helpAction:(id)sender
{
    NSURL * zinStudioUrl = [NSURL URLWithString:@"http://zin.studio/#contact"];
    [[UIApplication sharedApplication] openURL:zinStudioUrl];
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    [self.backButton.titleLabel setFont:[self.backButton.titleLabel.font fontWithSize:width*.044]];
    [self.settingsTitleLabel setFont:[self.settingsTitleLabel.font fontWithSize:width*.119]];
    [self.soundEffectsLabel setFont:[self.soundEffectsLabel.font fontWithSize:width*.056]];
    [self.musicLabel setFont:[self.musicLabel.font fontWithSize:width*.056]];
    [self.vibrateLabel setFont:[self.vibrateLabel.font fontWithSize:width*.056]];
    [self.helpButton.titleLabel setFont:[self.helpButton.titleLabel.font fontWithSize:width*.056]];
    [self.controlsLabel setFont:[self.controlsLabel.font fontWithSize:width*.056]];
    [self.controlsButton.titleLabel setFont:[self.controlsButton.titleLabel.font fontWithSize:width*0.04375]];
    [self.resetTutorialButton.titleLabel setFont:[self.resetTutorialButton.titleLabel.font fontWithSize:width*0.046875]];
    
    self.constraintTrailingBack.constant = width*.669;
    self.constraintLeadingSettings.constant = width*.063;
    self.constraintTrailingSettings.constant = width*.063;
    
    self.constraintLeadingSFX.constant = width*.116;
    self.constraintTopSFX.constant = width*0.203125;
    self.constraintTrailingSFX.constant = width*.631;
    
    self.constraintLeadingSFXSlider.constant = width*.447;
    self.constraintTopSFXSlider.constant = width*-.0125;
    self.constraintTrailingSFXSlider.constant = width*.119;
    
    self.constraintTopMusic.constant = width*.169;
    
    self.constraintTopMusicSlider.constant = width*-.0125;
    
    self.constraintTopVibrate.constant = width*.178;
    self.constraintTrailingVibrate.constant = width*.416;
    
    self.constraintTopVibrateSwitch.constant = width*-.0156;
    
    self.constraintHeightHelp.constant = width*.166;
    
    self.constraintTopControls.constant = width*0.190625;
    self.constraintTrailingControls.constant = width*0.515625;
    
    self.constraintWidthControlsButton.constant = width*0.309375;
    
    self.constraintTopResetTutorial.constant = width*0.140625;
    
    [self.soundEffectsVolumeSlider adjustForDeviceWidth:width];
    [self.musicVolumeSlider adjustForDeviceWidth:width];
}

@end
