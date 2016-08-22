//
//  UpgradeView.m
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "UpgradeView.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SpriteAppDelegate.h"

@implementation UpgradeView
{
    CGRect _maximizedMyViewFrame;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if ( self )
    {
        [self setup];
        
        self.view.superview.layer.cornerRadius = 20;
        
        UIImage *originalImage = [UIImage imageNamed:@"buttonMed.png"];
        UIEdgeInsets insets = UIEdgeInsetsMake(25, 25, 25, 25);
        UIImage *stretchableImage = [originalImage resizableImageWithCapInsets:insets];
        [self.borderImageView setImage:stretchableImage];
        
        _maximizedMyViewFrame = CGRectMake(0, 0, 250, 410);
        
        self.unlockWithPointsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.unlockWithMoneyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture)];
        [self addGestureRecognizer:tapGesture];
        
        self.isMaximizing = NO;
        self.isMinimizing = NO;
        self.minimizedFrame = self.frame;
        [self minimizeViewAnimated:NO];
        
        [_AppDelegate addGlowToLayer:self.titleLabel.layer withColor:[self.titleLabel.textColor CGColor]];
        [_AppDelegate addGlowToLayer:self.descriptionLabel.layer withColor:[self.descriptionLabel.textColor CGColor]];
        [_AppDelegate addGlowToLayer:self.purchasedLabel.layer withColor:[self.purchasedLabel.textColor CGColor]];
        [_AppDelegate addGlowToLayer:self.unlockWithMoneyButton.titleLabel.layer withColor:[self.unlockWithMoneyButton.titleLabel.textColor CGColor]];
        [_AppDelegate addGlowToLayer:self.unlockWithPointsButton.titleLabel.layer withColor:[self.unlockWithPointsButton.titleLabel.textColor CGColor]];
    }
    return self;
}

- (void) setup
{
    self.clipsToBounds = YES;
    [[NSBundle mainBundle] loadNibNamed:@"UpgradeView" owner:self options:nil];
    [self addSubview:self.view];
    
    if ( [(NSString*)[UIDevice currentDevice].model hasPrefix:@"iPad"] )
        self.myTopConstraint.constant = -135;
}

- (void) handleTapGesture
{
    if ( self.isMinimized )
        [self maximizeViewAnimated:YES];
    else
        [self minimizeViewAnimated:YES];
}

- (void) maximizeViewAnimated:(BOOL)animated
{
    if ( [self.delegate respondsToSelector:@selector(willMaximizeUpgradeView:)] )
        [self.delegate willMaximizeUpgradeView:self];
    
    self.skView = [[SKView alloc] initWithFrame:CGRectMake(0, 0, self.viewForSKView.frame.size.width, self.view.frame.size.height)];
    [self.viewForSKView addSubview:self.skView];
    [self.skView presentScene:[[UpgradeScene alloc] initWithUpgradeType:self.upgrade.upgradeType]];
    
    
    if ( animated )
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUpgradeMaximize];
        self.isMaximizing = YES;
        self.isMinimized = NO;
        
        self.constraintBottomBorderImage.constant = 0;
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:.35 animations:^
         {
             [self layoutIfNeeded];
             self.layer.borderWidth = 1;
             self.view.superview.backgroundColor = [UIColor blackColor];
             
             self.minimizedIcon.alpha = 0;
             self.viewForSKView.alpha = 1;
             
             self.frame = CGRectMake((self.superview.frame.size.width - _maximizedMyViewFrame.size.width)/2, (self.superview.frame.size.height - self.myView.frame.size.height)/2, _maximizedMyViewFrame.size.width, self.myView.frame.size.height);
             self.view.frame = CGRectMake(self.view.frame.origin.x,
                                          self.view.frame.origin.y,
                                          _maximizedMyViewFrame.size.width,
                                          self.view.frame.size.height);
             self.maximizedFrame = self.frame;
         }
         completion:^(BOOL finished)
         {
             self.isMaximizing = NO;
             if ( [self.delegate respondsToSelector:@selector(didMaximizeUpgradeView:)] )
                 [self.delegate didMaximizeUpgradeView:self];
         }];
    }
    else
    {
        NSLog(@"ERROR - maximize without animation should never occur");
    }
}

- (void) minimizeViewAnimated:(BOOL)animated
{
    if ( animated )
        self.isMinimizing = YES;
    
    if ( [self.delegate respondsToSelector:@selector(willMinimizeUpgradeView:)] )
        [self.delegate willMinimizeUpgradeView:self];
    
    if ( animated )
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMenuUpgradeMinimize];
        self.constraintBottomBorderImage.constant = _maximizedMyViewFrame.size.height - self.minimizedFrame.size.height;
        [self setNeedsUpdateConstraints];
        [UIView animateWithDuration:.35 animations:^
        {
            [self layoutIfNeeded];
            self.layer.borderWidth = 0;
            for ( UIView * view in [self.view subviews] )
                view.backgroundColor = [UIColor clearColor];
            self.view.backgroundColor = [UIColor clearColor];
            self.view.superview.backgroundColor = [UIColor clearColor];
            self.minimizedIcon.backgroundColor = [UIColor clearColor];
            
            self.frame = self.minimizedFrame;
            self.view.frame = CGRectMake(self.view.frame.origin.x,
                                         self.view.frame.origin.y,
                                         self.minimizedFrame.size.width,
                                         self.view.frame.size.height);
            
            self.viewForSKView.alpha = 0;
        }
        completion:^(BOOL finished)
        {
            self.isMinimizing = NO;
            if ( [self.delegate respondsToSelector:@selector(didMinimizeUpgradeView:)] )
                [self.delegate didMinimizeUpgradeView:self];
            
            [[(UpgradeScene *)self.skView.scene moveShipTimer] invalidate];
            [self.skView.scene enumerateChildNodesWithName:@"//*" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
            {
                [node removeAllActions];
            }];
            Spaceship * tmpSpace = [(UpgradeScene *)self.skView.scene mySpaceship];
            [tmpSpace.energyBoosterTimer invalidate];
            [(UpgradeScene *)self.skView.scene setMySpaceship:nil];
            [self.skView.scene removeAllActions];
            [self.skView setPaused:YES]; //i dont think this should be necessary but it is because sprite kit is lame //actually its probly my fault  & it may not be necessary anymore anyhow
            [self.skView presentScene:nil];
            [self.skView removeFromSuperview];
            self.skView = nil;
            self.isMinimized = YES;
        }];
    }
    else
    {
        self.layer.borderWidth = 0;
        for ( UIView * view in [self.view subviews] )
            view.backgroundColor = [UIColor clearColor];
        self.view.backgroundColor = [UIColor clearColor];
        self.view.superview.backgroundColor = [UIColor clearColor];
        self.minimizedIcon.backgroundColor = [UIColor clearColor];
        
        self.viewForSKView.alpha = 0;
        
        self.frame = self.minimizedFrame;
        self.view.frame = CGRectMake(self.view.frame.origin.x,
                                     self.view.frame.origin.y,
                                     self.minimizedFrame.size.width,
                                     self.view.frame.size.height);
        self.constraintBottomBorderImage.constant = _maximizedMyViewFrame.size.height - self.minimizedFrame.size.height;
        
        if ( [self.delegate respondsToSelector:@selector(didMinimizeUpgradeView:)] )
            [self.delegate didMinimizeUpgradeView:self];
        [self.skView removeFromSuperview];
        self.isMinimized = YES;
    }
}

- (void) setupForUpgrade:(Upgrade *)upgrade
{
    self.upgrade = upgrade;
    self.minimizedIcon.image = upgrade.icon;
    self.titleLabel.text = upgrade.title;
    self.descriptionLabel.text = upgrade.upgradeDescription;
    upgrade.demoScene.size = CGSizeMake(self.viewForSKView.frame.size.width*2, self.viewForSKView.frame.size.height*3);
    
    if ( upgrade.isUnlocked )
    {
        self.purchasedLabel.alpha = 1;
        self.unlockWithMoneyButton.alpha = 0;
        self.unlockWithPointsButton.alpha = 0;
        [self.minimizedIcon setTintColor:[UIColor colorWithRed:1 green:204.0/255 blue:0 alpha:1]];
    }
    else
    {
        if ( self.upgrade.isValidForMoneyPurchase )
        {
            [self.unlockWithMoneyButton setTitle:[NSString stringWithFormat:@"%@!\n%@", NSLocalizedString(@"Unlock Now", nil), upgrade.priceString] forState:UIControlStateNormal];
            [self.unlockWithMoneyButton setTitleColor:[UIColor colorWithRed:0 green:212.0/255 blue:14.0/255 alpha:1] forState:UIControlStateNormal];
            self.unlockWithMoneyButton.enabled = YES;
            self.unlockWithMoneyButton.backgroundColor = [UIColor colorWithWhite:85.0/255 alpha:.5];
        }
        else
        {
            [self.unlockWithMoneyButton setTitle:[NSString stringWithFormat:@"%@", NSLocalizedString(@"Unavailable", nil)] forState:UIControlStateNormal];
            [self.unlockWithMoneyButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.unlockWithMoneyButton.enabled = NO;
            self.unlockWithMoneyButton.backgroundColor = [UIColor clearColor];
        }
        
        if ( [AccountManager availablePoints] >= upgrade.pointsToUnlock )
        {
            [self.minimizedIcon setTintColor:[UIColor colorWithRed:.2 green:.8 blue:.2 alpha:1]];
            [self.unlockWithPointsButton setTitle:[NSString stringWithFormat:@"%@!\n%ik %@", NSLocalizedString(@"Unlock Now", nil), upgrade.pointsToUnlock/1000, NSLocalizedString(@"points", nil)] forState:UIControlStateNormal];
        }
        else
        {
            [self.minimizedIcon setTintColor:[UIColor colorWithWhite:1 alpha:1]];
            [self.unlockWithPointsButton setTitle:[NSString stringWithFormat:@"%ik %@\n%@", upgrade.pointsToUnlock/1000, NSLocalizedString(@"points", nil), NSLocalizedString(@"to Unlock", nil)] forState:UIControlStateNormal];
            [self.unlockWithPointsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            self.unlockWithPointsButton.enabled = NO;
            self.unlockWithPointsButton.backgroundColor = [UIColor clearColor];
        }
    }
}

- (void) refreshView
{
    [self setupForUpgrade:self.upgrade];
}

- (IBAction)unlockWithPointsAction:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(unlockWithPointsPressed:)] )
        [self.delegate unlockWithPointsPressed:self];
}

- (IBAction)unlockWithMoneyAction:(id)sender
{
    if ( [self.delegate respondsToSelector:@selector(unlockWithMoneyPressed:)] )
        [self.delegate unlockWithMoneyPressed:self];
}
@end
