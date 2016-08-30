//
//  SelectShipViewController.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/15/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "SelectShipViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "SpaceshipKit.h"
#import "MenuBackgroundScene.h"
#import "GameplayViewController.h"
#import "GameplayControls.h"
#import "AccountManager.h"
#import "SAAlertView.h"
#import "AudioManager.h"
#import <Crashlytics/Crashlytics.h>
#import "SpriteAppDelegate.h"

@implementation SelectShipViewController
{
//    NSNumberFormatter * numberFormatter = [NSNumberFormatter new];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_AppDelegate addGlowToLayer:self.selectTitleLabel.layer withColor:self.selectTitleLabel.textColor.CGColor];
    
    self.spaceships = [[AccountManager sharedInstance] spaceships];
    
    [self.shipButton1 setupForSpaceship:[self.spaceships objectAtIndex:0]];
    [self.shipButton2 setupForSpaceship:[self.spaceships objectAtIndex:1]];
    [self.shipButton3 setupForSpaceship:[self.spaceships objectAtIndex:2]];
    [self.shipButton4 setupForSpaceship:[self.spaceships objectAtIndex:3]];
    [self.shipButton5 setupForSpaceship:[self.spaceships objectAtIndex:4]];
    [self.shipButton6 setupForSpaceship:[self.spaceships objectAtIndex:5]];
    [self.shipButton7 setupForSpaceship:[self.spaceships objectAtIndex:6]];
    [self.shipButton8 setupForSpaceship:[self.spaceships objectAtIndex:7]];
    
    [self adjustForDeviceSize];
    
//    MenuBackgroundScene * backgroundScene = [MenuBackgroundScene sharedInstance];
//    SKView * spriteView = (SKView *)self.view;
//    [spriteView presentScene:backgroundScene];
}

- (void) viewWillAppear:(BOOL)animated
{
    for ( UIView * subview in [self.view subviews] )
    {
        if ( subview.tag != 10 ) //10 is the background image
            subview.alpha = 0;
    }
    [UIView animateWithDuration:.2 animations:^
     {
         for ( UIView * subview in [self.view subviews] )
         {
             subview.alpha = 1;
         }
     }];
}

- (void) adjustForDeviceSize
{
    float width = self.view.frame.size.width;
    
    [self.selectTitleLabel setFont:[self.selectTitleLabel.font fontWithSize:width*.119]];
    [self.backButton.titleLabel setFont:[self.backButton.titleLabel.font fontWithSize:width*.044]];
    
    
    self.constraintTrailingBack.constant = width*.669;
    
    self.constraintLeadingSelect.constant = width*.125;
    self.constraintTopSelect.constant = width*.038;
    self.constraintTrailingSelect.constant = width*.125;
    
    self.constraintTopFirstButton.constant = width*.041;
}

#pragma mark - misc.
- (IBAction)engageAction:(id)sender
{
    Spaceship * selectedShip = [(ShipSelectionButton *)sender spaceship];
    
    [[AudioManager sharedInstance] fadeOutMenuMusic];
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuEngage];
    [AccountManager setLastSelectedShip:selectedShip];
    SKView * spriteView = (SKView *)self.view;
    
    UIViewController * mainMenuVC = [self presentingViewController];
    mainMenuVC.view.alpha = 0;
    [UIView animateWithDuration:.2 animations:^
    {
        spriteView.alpha = 0;
    }
    completion:^(BOOL finished)
    {
        [spriteView presentScene:nil];
        [self dismissViewControllerAnimated:NO completion:^
        {
            UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            GameplayViewController * gameplayVC = [storyboard instantiateViewControllerWithIdentifier:@"gameplayVC"];
            [gameplayVC setSpaceshipForScene:[selectedShip copy]];
            [mainMenuVC presentViewController:gameplayVC animated:NO completion:^
            {
                mainMenuVC.view.alpha = 1;
            }];
        }];
    }];
}

//- (IBAction)unlockAction:(id)sender
//{
//    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUnlock];
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    NSString *numberString = [numberFormatter stringFromNumber:@(self.currentShip.pointsToUnlock)];
//    SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Unlock %@\nfor %@ points?", NSStringFromClass([self.currentShip class]), numberString] cancelButtonTitle:@"Cancel" otherButtonTitle:@"Unlock"];
//    unlockAlert.appearTime = .2;
//    unlockAlert.disappearTime = .2;
//    unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:.8];
//    unlockAlert.messageLabel.font = [UIFont fontWithName:@"Chalkduster" size:20];
//    unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:15];
//    unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Chalkduster" size:15];
//    unlockAlert.otherButtonAction = ^
//    {
//        [Answers logPurchaseWithPrice:[[NSDecimalNumber alloc] initWithFloat:self.currentShip.pointsToUnlock]
//                             currency:@"game points"
//                              success:@YES
//                             itemName:self.currentShip.name
//                             itemType:@"Spaceship"
//                               itemId:nil
//                     customAttributes:@{}];
//        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuDidUnlock];
//        [AccountManager unlockShip:self.currentShip];
//        [AccountManager subtractPoints:self.currentShip.pointsToUnlock];
//        [self animateAvailablePoints:[NSNumber numberWithInt:self.currentShip.pointsToUnlock]];
//        [self updateShipDetails];
//    };
//    [unlockAlert show];
//}

//- (void) animateAvailablePoints:(NSNumber *)pointsToSubtractNumber
//{
//    int pointsToSubtract = [pointsToSubtractNumber intValue];
//    
//    NSString * availablePointsPart = [NSString stringWithFormat:@"%@ : ", NSLocalizedString(@"Available Points", nil)];
//    
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
//    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    int points = [[numberFormatter numberFromString:[self.availablePointsValueLabel.text stringByReplacingOccurrencesOfString:availablePointsPart withString:@""]] intValue];
//    NSString *numberString = [numberFormatter stringFromNumber:@(points - 50)];
//    self.availablePointsValueLabel.text = [NSString stringWithFormat:@"%@ : %@", NSLocalizedString(@"Available Points", nil), numberString];
//    
//    if ( pointsToSubtract != 50 )
//        [self performSelector:@selector(animateAvailablePoints:) withObject:[NSNumber numberWithInt:pointsToSubtract-50] afterDelay:.05];
//}


- (IBAction)backAction:(id)sender
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuBackButton];
    [UIView animateWithDuration:.2 animations:^
    {
        for ( UIView * subview in [self.view subviews] )
        {
            if ( subview.tag != 10 ) //10 is the background image
                subview.alpha = 0;
        }
    }
    completion:^(BOOL finished)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

@end
