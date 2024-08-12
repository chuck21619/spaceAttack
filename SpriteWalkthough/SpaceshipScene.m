//
//  SpaceshipScene.m
//  SpriteWalkthough
//
//  Created by chuck on 3/25/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "SpaceshipScene.h"
#import "CategoryBitMasks.h"
#import "PlayerWeaponsKit.h"
#import "PowerUp.h"
#import "AccountManager.h"
#import "SAAlertView.h"
#import <GameKit/GameKit.h>
#import "AudioManager.h"
#import "SpriteAppDelegate.h"
#import "HealthBar.h"

@implementation SpaceshipScene
{
    NSMutableArray * _nodesToRemove;
    
    NSMutableArray * _cachedAsteroids;
    NSMutableArray * _cachedEnemies;
    NSMutableArray * _cachedBullets;
    NSMutableArray * _cachedLasers;
    NSMutableArray * _cachedPhotons;
    NSMutableArray * _cachedElectricity;
    NSMutableArray * _cachedPowerUps;
    NSMutableArray * _cachedSpaceBackgrounds;
    
    HealthBar * _healthBar;
}

- (void) didMoveToView:(SKView *)view
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if ( !self.contentCreated )
    {
        [AudioManager sharedInstance].scene = self;
        [self createSceneContents];
        self.contentCreated = YES;
        //view.showsFPS = YES;
        _nodesToRemove = [NSMutableArray new];
        
        _cachedAsteroids = [NSMutableArray new];
        _cachedEnemies = [NSMutableArray new];
        _cachedBullets = [NSMutableArray new];
        _cachedLasers = [NSMutableArray new];
        _cachedPhotons = [NSMutableArray new];
        _cachedElectricity = [NSMutableArray new];
        _cachedPowerUps = [NSMutableArray new];
        _cachedSpaceBackgrounds = [NSMutableArray new];
        
        self.bulletsFired = 0;
        self.photonsFired = 0;
        self.lasersFired = 0;
        self.electricityFired = 0;
        self.enemiesDestroyed = 0;
        self.powerUpsCollected = 0;
        
        
        if ( !_healthBar )
        {
            float healthBarHeight = self.size.width*0.0075;
            _healthBar = [[HealthBar alloc] initWithFrame:CGRectMake(0, self.size.height-healthBarHeight, self.size.width, healthBarHeight)];
            [self.view addSubview:_healthBar];
        }
        else
            [_healthBar setProgress:1];
        
        [UIView animateWithDuration:1 animations:^{
            self.backgroundColor = [UIColor clearColor];
        }];
    }
}

- (void) createSceneContents
{
    
    [[AudioManager sharedInstance] playGameplayMusic];
    
    //NSLog(@"[[UIDevice currentDevice] model] : %@", [[UIDevice currentDevice] model]);
    self.physicsWorld.contactDelegate = self;
    self.backgroundColor = [SKColor clearColor];
    self.scaleMode = SKSceneScaleModeResizeFill;
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    
    self.sharedGameplayControls = [GameplayControls sharedInstance];
    self.sharedGameplayControls.delegate = self;
    
    if ( ! [[AccountManager sharedInstance] touchControls] )
        [self.sharedGameplayControls startControllerUpdates];
    
    self.spaceObjectKit = [SpaceObjectsKit sharedInstanceWithScene:self];
    //[self.spaceObjectKit addStartingBackground];
    self.lastSpaceBackgroundDuration = 150;
    self.enemyKit = [EnemyKit sharedInstanceWithScene:self];
    
    self.mySpaceship.position = CGPointMake( CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-150);
    [self.mySpaceship setExhaustTargetNode:self];
    [self addChild:self.mySpaceship];
    self.mySpaceship.delegate = self;
    
    self.pointsScored = 0;
    self.makeAsteroidsInterval = 3;
    self.asteroidSpeedCoefficient = .7;
    self.minimumAsteroidDegree = 3.0;
    self.maximumAsteroidDegree = 3.0;
    self.enemySpeedCoefficient = 1.2;
    SKAction * makeAsteroids = [SKAction sequence:
                                @[[SKAction performSelector:@selector(addAsteroid) onTarget:self],
                                  [SKAction waitForDuration:self.makeAsteroidsInterval withRange:.15]]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        //dont start making asteroids if the spaceship exploded
        if ( self.mySpaceship.parent )
            [self runAction:[SKAction repeatActionForever:makeAsteroids] withKey:@"makeAsteroids"];
    });
    
    self.asteroidTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(moreAsteroids) userInfo:nil repeats:YES];
    
    
    
    self.makeEnemiesInterval = 20;
    SKAction * makeEnemies = [SKAction sequence:
                              @[[SKAction performSelector:@selector(addEnemies) onTarget:self],
                                [SKAction waitForDuration:self.makeEnemiesInterval withRange:3]]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        //dont start making enemies if the spaceship exploded
        if ( self.mySpaceship.parent )
            [self runAction:[SKAction repeatActionForever:makeEnemies] withKey:@"makeEnemies"];
    });
    
    self.enemyTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(moreEnemies) userInfo:nil repeats:YES];
    
    
    self.pointsScoredLabel = [SKLabelNode labelNodeWithFontNamed:NSLocalizedString(@"font1", nil)];
    self.pointsScoredLabel.text = [NSString stringWithFormat:@"%i", self.pointsScored];
    self.pointsScoredLabel.fontSize = 15;
    self.pointsScoredLabel.fontColor = [SKColor whiteColor];
    self.pointsScoredLabel.position = CGPointMake(self.size.width/2, 25);
    [self addChild:self.pointsScoredLabel];
    
    self.enemiesDestroyedWithoutTakingDamage = 0;
    self.scoreMultiplier = 1;
    self.scoreMultiplierLabel = [SKLabelNode labelNodeWithFontNamed:NSLocalizedString(@"font1", nil)];
    self.scoreMultiplierLabel.text = [NSString stringWithFormat:@"%i", self.scoreMultiplier];
    self.scoreMultiplierLabel.fontSize = 13;
    self.scoreMultiplierLabel.fontColor = [SKColor whiteColor];
    self.scoreMultiplierLabel.position = CGPointMake(self.size.width/2, 42);
    self.scoreMultiplierLabel.alpha = 0;
    [self addChild:self.scoreMultiplierLabel];
    
    SKAction * makePowerUps = [SKAction sequence:@[[SKAction performSelector:@selector(addPowerUp) onTarget:self], [SKAction waitForDuration:10]]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        //dont start making power ups if the spaceship exploded
        if ( self.mySpaceship.parent )
            [self runAction:[SKAction repeatActionForever:makePowerUps] withKey:@"makePowerUps"];
    });
    
    self.periodicAchievementUpdatingTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(submitAchievementProgress) userInfo:nil repeats:YES];
    
    NSString * cloudDustString = [[NSBundle mainBundle] pathForResource:@"jefParticle" ofType:@"sks"];
    SKEmitterNode * cloudDust = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudDustString];
    cloudDust.name = @"stars";
    cloudDust.zPosition = -75;
    cloudDust.position = CGPointMake(self.size.width/2, self.size.height);
    [self addChild:cloudDust];
    
    NSString * cloudDustString2 = [[NSBundle mainBundle] pathForResource:@"SpaceDust" ofType:@"sks"];
    SKEmitterNode * cloudDust2 = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudDustString2];
    cloudDust2.name = @"stars2";
    cloudDust2.zPosition = -75;
    cloudDust2.position = CGPointMake(self.size.width/2, self.size.height);
    [self addChild:cloudDust2];
    
    self.showingTooltip = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if ( !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypeMoveSpaceship] )
        {
            self.showingTooltip = YES;
            [self pauseGame];
            NSString * alertTitle = NSLocalizedString(@"Choose how to Move:", nil);
            NSString * alertMessage = NSLocalizedString(@"You can change this later in settings", nil);
            SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Tilt Screen", nil) otherButtonTitle:NSLocalizedString(@"Touch", nil)];
            unlockAlert.customFrame = CGRectMake(0, 0, self.size.width, unlockAlert.frame.size.height);
            [unlockAlert show];
            unlockAlert.otherButtonAction = ^
            {
                [[AccountManager sharedInstance] setTouchControls:YES];
                [[GameplayControls sharedInstance] stopControllerUpdates];
                [self resumeGame];
                self.showingTooltip = NO;
            };
            unlockAlert.cancelButtonAction = ^
            {
                [[AccountManager sharedInstance] setTouchControls:NO];
                [self resumeGame];
                self.showingTooltip = NO;
            };
        }

    });
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

- (void) addPowerUp
{
    PowerUpType randomPowerUp = arc4random_uniform(kPowerUpTypeCount);
    //this while loop is probly a crappy workaround - but i dont care at the moment
    while ( (randomPowerUp == kPowerUpTypeShield  && ![AccountManager shieldUnlocked]) ||
            (randomPowerUp == kPowerUpTypeEnergyBooster && ![AccountManager energyBoosterUnlocked]) )
    {
        randomPowerUp = arc4random_uniform(kPowerUpTypeCount);
    }
    
//#warning change to randomPowerUp
    PowerUp * tmpPowerUp = [[PowerUp alloc] initWithPowerUpType:randomPowerUp];
    tmpPowerUp.delegate = self;
    tmpPowerUp.position = CGPointMake(skRand(0, self.size.width), self.size.height+tmpPowerUp.size.height);
    [self addChild:tmpPowerUp];
    
    [tmpPowerUp.physicsBody applyImpulse:CGVectorMake(skRand(-tmpPowerUp.physicsBody.mass*22, tmpPowerUp.physicsBody.mass*22),
                                                      -tmpPowerUp.physicsBody.mass*180)];
    [tmpPowerUp.physicsBody applyTorque:skRand(-tmpPowerUp.physicsBody.mass*.8, tmpPowerUp.physicsBody.mass*.8)];
}

- (void) updateScoreMultiplierLabel
{
    [self.scoreMultiplierLabel removeAllActions];
    
    if ( self.scoreMultiplier == 1 || self.mySpaceship.armor == 0 )
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMultiplierLost];
        [self.scoreMultiplierLabel runAction:[SKAction fadeOutWithDuration:2]];
        [self.scoreMultiplierLabel runAction:[SKAction scaleTo:0 duration:2]];
    }
    else
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectMultiplierIncrease];
        self.scoreMultiplierLabel.text = [NSString stringWithFormat:@"x%i", self.scoreMultiplier];
        self.scoreMultiplierLabel.alpha = 1;
        SKAction * scaleUp = [SKAction scaleTo:8 duration:.3];
        SKAction * scaleDown = [SKAction scaleTo:1 duration:.7];
        [self.scoreMultiplierLabel runAction:[SKAction sequence:@[scaleUp, scaleDown]] completion:^
        {
            if ( !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypeScoreMultiplier] )
            {
                self.showingTooltip = YES;
                SKSpriteNode * tooltipArrow = [self tooltipArrowAt:self.scoreMultiplierLabel];
                [self pauseGame];
                NSString * alertTitle = NSLocalizedString(@"Ermahgerd!", nil);
                NSString * alertMessage = NSLocalizedString(@"Blowing up aliens without taking damage makes your multiplier go up!", nil);
                SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
                unlockAlert.customFrame = CGRectMake(0, (self.size.height+self.view.frame.origin.y) - 220, self.size.width, 150);
                [unlockAlert show];
                unlockAlert.otherButtonAction = ^
                {
                    [self removeTooltipArrow:tooltipArrow];
                    [self resumeGame];
                    self.showingTooltip = NO;
                };
                unlockAlert.cancelButtonAction = ^
                {
                    [self removeTooltipArrow:tooltipArrow];
                    [AccountManager disableTips];
                    [self resumeGame];
                    self.showingTooltip = NO;
                };
            }
        }];
    }
}

- (void) pointsScored:(int)points
{
    points = points*self.scoreMultiplier;
    if ( self.mySpaceship.energyBoosterActive )
        points *= 2;
    
    self.pointsScored += points;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *numberString = [numberFormatter stringFromNumber:@(self.pointsScored)];
    self.pointsScoredLabel.text = numberString;
}

- (void) flashMultiplierOnNode:(SKSpriteNode *)node
{
    if ( !self.mySpaceship.energyBoosterActive )
        return;
    
    SKLabelNode * tmpMultiplierLabel = [SKLabelNode labelNodeWithFontNamed:NSLocalizedString(@"font1", nil)];
    tmpMultiplierLabel.text = [NSString stringWithFormat:@"x%i", self.scoreMultiplier];
    tmpMultiplierLabel.fontSize = 15;
    tmpMultiplierLabel.fontColor = [SKColor whiteColor];
    
    float yCoord = node.position.y - (node.size.height/2);
    CGPoint position = CGPointMake(node.position.x, yCoord);
    tmpMultiplierLabel.position = position;
    
    tmpMultiplierLabel.alpha = 0;
    [self addChild:tmpMultiplierLabel];
    
    SKAction * fadeIn = [SKAction fadeInWithDuration:.1];
    SKAction * fadeOut = [SKAction fadeOutWithDuration:1];
    [tmpMultiplierLabel runAction:[SKAction sequence:@[fadeIn, fadeOut]] completion:^
    {
        [tmpMultiplierLabel removeFromParent];
    }];
}

//using this for debugging shiznits
//- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    UITouch * touch = [touches anyObject];
//    
//    if ( touch.tapCount == 1 )
//    {
//        
//    }
//    
//    if ( touch.tapCount == 2 )
//    {
//        if ( ! self.view.isPaused )
//            [self pauseGame];
//        else
//            [self resumeGame];
//    }
//}

- (void) pauseGame
{
    if ( self.view.paused )
        return;
    
    self.view.paused = YES;
    
    if ( [self.enemyTimer isValid] )
        self.resumeEnemyTimer = YES;
    else
        self.resumeEnemyTimer = NO;
    [self.enemyTimer invalidate];
    
    if ( [self.asteroidTimer isValid] )
        self.resumeAsteroidTimer = YES;
    else
        self.resumeAsteroidTimer = NO;
    [self.asteroidTimer invalidate];
    
    if ( [self.periodicAchievementUpdatingTimer isValid] )
        self.resumePeriodicAchievementUpdatingTimer = YES;
    else
        self.resumePeriodicAchievementUpdatingTimer = NO;
    [self.periodicAchievementUpdatingTimer invalidate];
    
    [[AudioManager sharedInstance] pauseMachineGuns:YES];
}

- (void) resumeGame
{
    if ( ! self.view.paused )
        return;
    
    self.view.paused = NO;
    
    NSError * error;
    if ( !self.audioEngine.isRunning && ![self.audioEngine startAndReturnError:&error] )
        NSLog(@"audioEngine - startAndReturnError - error : %@", error);
    
    if ( self.resumeEnemyTimer )
        self.enemyTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(moreEnemies) userInfo:nil repeats:YES];
    
    if ( self.resumeAsteroidTimer )
        self.asteroidTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(moreAsteroids) userInfo:nil repeats:YES];

    if ( self.resumePeriodicAchievementUpdatingTimer )
        self.periodicAchievementUpdatingTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(submitAchievementProgress) userInfo:nil repeats:YES];
    
    [[AudioManager sharedInstance] pauseMachineGuns:NO];
}

- (void) showEndGameScreen
{
    [AccountManager incrementNumberOfTimesPlayed];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if ( ! self.sharedGameplayControls.delegate ) // if there is no delegate for controls, then no game is being played
            [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    });
    
    [self.pointsScoredLabel runAction:[SKAction fadeOutWithDuration:1] completion:^
    {
        [self.customDelegate gameOver:self.pointsScored];
        [AccountManager addPoints:self.pointsScored];
        [self submitAchievementProgress];
        [self submitGameKitScore];
    }];
}

#pragma mark background
- (void) checkBackground
{
    __block BOOL allSpaceBackgroundsAreBelowTopOfScreen = YES;
    for ( SpaceBackground * spaceBackground in _cachedSpaceBackgrounds )
    {
        if ( spaceBackground.position.y > -(spaceBackground.size.height/2 - self.size.height) )
            allSpaceBackgroundsAreBelowTopOfScreen = NO;
    }
    
    if ( allSpaceBackgroundsAreBelowTopOfScreen )
        [self.spaceObjectKit addSpaceBackground];
}

#pragma mark game kit
- (void) submitGameKitScore
{
    if ( ! [[GKLocalPlayer localPlayer] isAuthenticated] )
        return;
    
    GKScore * pointsScored = [[GKScore alloc] initWithLeaderboardIdentifier:@"SingleFlightPoints"];
    pointsScored.value = [[NSNumber numberWithInt:self.pointsScored] longLongValue];
    NSLog(@"pointsScore.value : %lld", pointsScored.value);
    [GKScore reportScores:@[pointsScored] withCompletionHandler:^(NSError * _Nullable error)
    {
        if ( error )
            NSLog(@"issue reporting gkscore : %@", error);
        else
            NSLog(@"gkscore has been reported");
    }];
}

- (void) submitAchievementProgress
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
    {
        NSDictionary * achievements = @{[NSString stringWithFormat:@"%i", kAchievementBulletsFired100] : [NSNumber numberWithInteger:self.bulletsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementBulletsFired1000] : [NSNumber numberWithInteger:self.bulletsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementBulletsFired10000] : [NSNumber numberWithInteger:self.bulletsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementBulletsFired100000] : [NSNumber numberWithInteger:self.bulletsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementPhotonsFired25] : [NSNumber numberWithInteger:self.photonsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementPhotonsFired250] : [NSNumber numberWithInteger:self.photonsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementPhotonsFired2500] : [NSNumber numberWithInteger:self.photonsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementPhotonsFired25000] : [NSNumber numberWithInteger:self.photonsFired],
                                        [NSString stringWithFormat:@"%i", kAchievementLasersFired15] : [NSNumber numberWithInteger:self.lasersFired],
                                        [NSString stringWithFormat:@"%i", kAchievementLasersFired150] : [NSNumber numberWithInteger:self.lasersFired],
                                        [NSString stringWithFormat:@"%i", kAchievementLasersFired1500] : [NSNumber numberWithInteger:self.lasersFired],
                                        [NSString stringWithFormat:@"%i", kAchievementLasersFired15000] : [NSNumber numberWithInteger:self.lasersFired],
                                        [NSString stringWithFormat:@"%i", kAchievementElectricityFired20] : [NSNumber numberWithInteger:self.electricityFired],
                                        [NSString stringWithFormat:@"%i", kAchievementElectricityFired200] : [NSNumber numberWithInteger:self.electricityFired],
                                        [NSString stringWithFormat:@"%i", kAchievementElectricityFired2000] : [NSNumber numberWithInteger:self.electricityFired],
                                        [NSString stringWithFormat:@"%i", kAchievementElectricityFired20000] : [NSNumber numberWithInteger:self.electricityFired],
                                        [NSString stringWithFormat:@"%i", kAchievementEnemiesDestroyed50] : [NSNumber numberWithInteger:self.enemiesDestroyed],
                                        [NSString stringWithFormat:@"%i", kAchievementEnemiesDestroyed500] : [NSNumber numberWithInteger:self.enemiesDestroyed],
                                        [NSString stringWithFormat:@"%i", kAchievementEnemiesDestroyed5000] : [NSNumber numberWithInteger:self.enemiesDestroyed],
                                        [NSString stringWithFormat:@"%i", kAchievementEnemiesDestroyed50000] : [NSNumber numberWithInteger:self.enemiesDestroyed],
                                        [NSString stringWithFormat:@"%i", kAchievementPowerUpsCollected3] : [NSNumber numberWithInteger:self.powerUpsCollected],
                                        [NSString stringWithFormat:@"%i", kAchievementPowerUpsCollected30] : [NSNumber numberWithInteger:self.powerUpsCollected],
                                        [NSString stringWithFormat:@"%i", kAchievementPowerUpsCollected300] : [NSNumber numberWithInteger:self.powerUpsCollected],
                                        [NSString stringWithFormat:@"%i", kAchievementPowerUpsCollected3000] : [NSNumber numberWithInteger:self.powerUpsCollected]};
        
        [AccountManager submitAchievementsProgress:achievements];
        
        self.bulletsFired = 0;
        self.photonsFired = 0;
        self.lasersFired = 0;
        self.electricityFired = 0;
        self.enemiesDestroyed = 0;
        self.powerUpsCollected = 0;
    });
}

#pragma mark gameplay controls
- (void) didUpdateAcceleration:(CMAcceleration)acceleration
{
    if ( [[AccountManager sharedInstance] touchControls] )
    {
        NSLog(@"this shouldnt occur. accelerometer updates should be turned off if user is using touchControls");
        return;
    }
    
    if ( [self.view isPaused] )
        return;
    
    acceleration.x *= 3;
    if ( acceleration.x > 1 )
        acceleration.x = 1;
    else if ( acceleration.x < -1 )
        acceleration.x = -1;
    
    acceleration.y *= 2;
    acceleration.y += .35;
    if ( acceleration.y > 1 )
        acceleration.y = 1;
    else if ( acceleration.y < -1 )
        acceleration.y = -1;
        
    int xCoord = self.size.width/2 + (acceleration.x * self.size.width/2);
    int yCoord = self.size.height/2 + (acceleration.y * self.size.height/2);
    SKAction * moveSpaceship = [SKAction moveTo:CGPointMake(xCoord, yCoord) duration:15.0/(self.mySpaceship.mySpeed*2)];
    
    //float degreeDifference = (360 - self.sharedGameplayControls.initialHeading) - (360 - heading.magneticHeading);
    //float newAngle = -DEGREES_TO_RADIANS(degreeDifference);
    //SKAction * rotateSpaceship = [SKAction rotateToAngle:newAngle duration:5.0/self.mySpaceship.mySpeed shortestUnitArc:YES];
    
    //[self.mySpaceship runAction:rotateSpaceship];
    [self.mySpaceship runAction:moveSpaceship];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ( ! [[AccountManager sharedInstance] touchControls] )
        return;
    
    UITouch * touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    SKAction * moveSpaceship = [SKAction moveTo:CGPointMake(touchLocation.x, (self.size.height-touchLocation.y)+(self.size.width*.1))  duration:10.0/(self.mySpaceship.mySpeed*2)];
    [self.mySpaceship runAction:moveSpaceship];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    SKAction * moveSpaceship = [SKAction moveTo:self.mySpaceship.position  duration:10.0/self.mySpaceship.mySpeed];
    [self.mySpaceship runAction:moveSpaceship];
}


#pragma mark photon/electricity stuff
- (SKNode *) nextPriorityTargetForPhoton:(Photon *)photon
{
    __block SKNode * closestTarget = nil;
    __block float closestDistance = -1;
    
    for ( Asteroid * tmpAsteroid in _cachedAsteroids )
    {
        float distance = pow(tmpAsteroid.position.x - photon.position.x, 2) + pow(tmpAsteroid.position.y - (photon.position.y + 100), 2);
        // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
        if ( distance < closestDistance || closestDistance == -1 )
        {
            if ( photon.isSmart )
            {
                if ( tmpAsteroid.photonsTargetingMe.count * [Photon baseDamage]*self.mySpaceship.damage < tmpAsteroid.health )
                {
                    closestDistance = distance;
                    closestTarget = tmpAsteroid;
                }
            }
            else
            {
                closestDistance = distance;
                closestTarget = tmpAsteroid;
            }
        }
    }
    
    for ( Enemy * tmpEnemy in _cachedEnemies )
    {
        float distance = pow(tmpEnemy.position.x - photon.position.x, 2) + pow(tmpEnemy.position.y - (photon.position.y + 100), 2);
        // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
        if ( distance < closestDistance || closestDistance == -1 )
        {
            if ( photon.isSmart )
            {
                if ( tmpEnemy.photonsTargetingMe.count * [Photon baseDamage]*self.mySpaceship.damage < tmpEnemy.armor )
                {
                    closestDistance = distance;
                    closestTarget = tmpEnemy;
                }
            }
            else
            {
                closestDistance = distance;
                closestTarget = tmpEnemy;
            }
        }
    }
    
    return closestTarget;
}

- (SKNode *) nextPriorityTargetForElectricity:(Electricity *)electricity
{
    __block SKNode * closestTarget = nil;
    __block float closestDistance = -1;
    CGPoint electricityPointInScene = electricity.parent.parent.parent.position;
    
    for ( Asteroid * node in _cachedAsteroids )
    {
        float distance = pow(node.position.x - electricityPointInScene.x, 2) + pow(node.position.y - electricityPointInScene.y, 2);
        // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
        if ( (distance < closestDistance || closestDistance == -1) && ![(Asteroid *)node isBeingElectrocuted] )
        {
            closestDistance = distance;
            closestTarget = node;
        }
    }
    
    for ( Enemy * node in _cachedEnemies )
    {
        float distance = pow(node.position.x - electricityPointInScene.x, 2) + pow(node.position.y - electricityPointInScene.y, 2);
        // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
        if ( (distance < closestDistance || closestDistance == -1) && ![(Enemy *)node isBeingElectrocuted] )
        {
            closestDistance = distance;
            closestTarget = node;
        }
    }
    
    return closestTarget;
}

- (float) distanceBetweenNodeA:(SKNode *)nodeA andNodeB:(SKNode *)nodeB
{
    float distance = sqrtf(pow(nodeA.position.x - nodeB.position.x, 2) + pow(nodeA.position.y - nodeB.position.y, 2));
    return distance;
}

#pragma mark contact/collisions
- (void) update:(NSTimeInterval)currentTime
{
    for ( Photon * node in _cachedPhotons )
        [(Photon *)node update:currentTime];
    
    //electricity
    NSMutableArray * asteroidsToTakeDmgFromElectricity = [NSMutableArray new];
    NSMutableArray * enemiesToTakeDmgFromElectricity = [NSMutableArray new];
    for ( Electricity * tmpElectricityNode in _cachedElectricity )
    {
        [tmpElectricityNode update:currentTime];
        
        for ( Asteroid * node1 in _cachedAsteroids )
        {
            if ( [tmpElectricityNode intersectsNode:node1] )
            {
                if ( tmpElectricityNode.timeSinceLastDamageDealt + tmpElectricityNode.damageFrequency < currentTime )
                {
                    [asteroidsToTakeDmgFromElectricity addObject:node1];
                    tmpElectricityNode.timeSinceLastDamageDealt = currentTime;
                }
            }
        }
        
        for ( Enemy * node1 in _cachedEnemies )
        {
            if ( [tmpElectricityNode intersectsNode:node1] )
            {
                if ( tmpElectricityNode.timeSinceLastDamageDealt + tmpElectricityNode.damageFrequency < currentTime )
                {
                    [enemiesToTakeDmgFromElectricity addObject:node1];
                    tmpElectricityNode.timeSinceLastDamageDealt = currentTime;
                }
            }
        }
    }
    
    
    //laser
    NSMutableArray * asteroidsToTakeDmgFromLaser = [NSMutableArray new];
    NSMutableArray * enemiesToTakeDmgFromLaser = [NSMutableArray new];
    for ( Laser * node in _cachedLasers )
    {
        Laser * tmpLaser = (Laser *)node;
        
        for ( Asteroid * node1 in _cachedAsteroids )
        {
            if ( [tmpLaser intersectsNode:node1] )
                [asteroidsToTakeDmgFromLaser addObject:node1];
        }
        
        for ( Enemy * node1 in _cachedEnemies )
        {
            if ( [tmpLaser intersectsNode:node1] )
                [enemiesToTakeDmgFromLaser addObject:node1];
        }
    }
    
    //electricity
    for ( Asteroid * asteroid in asteroidsToTakeDmgFromElectricity )
        [asteroid takeDamage:[Electricity baseDamage]*self.mySpaceship.damage];
    for ( Enemy * enemy in enemiesToTakeDmgFromElectricity )
        [enemy takeDamage:[Electricity baseDamage]*self.mySpaceship.damage];
    
    //laser
    for ( Asteroid * asteroid in asteroidsToTakeDmgFromLaser )
        [asteroid takeDamage:[Laser baseDamage]*self.mySpaceship.damage];
    for ( Enemy * enemy in enemiesToTakeDmgFromLaser )
        [enemy takeDamage:[Laser baseDamage]*self.mySpaceship.damage];
}

- (void) didSimulatePhysics
{
    // This is your last chance to make changes to the scene.
    for ( Bullet * node in _cachedBullets )
    {
        if ( node.position.y > self.scene.size.height + node.frame.size.height ||
            node.position.y < -node.frame.size.height ||
            node.position.x > self.scene.size.width + node.frame.size.width ||
            node.position.x < -node.frame.size.width )
            [_nodesToRemove addObject:node];
    }
    
    for ( Photon * node in _cachedPhotons )
    {
        if ( node.position.y > self.scene.size.height + 100 ||
            node.position.y < -100 ||
            node.position.x > self.scene.size.width + 100 ||
            node.position.x < -100)
            [_nodesToRemove addObject:node];
    }
    
    for ( Enemy * node in _cachedEnemies )
    {
        if ( node.position.y <= -node.frame.size.height ||
            node.position.x > node.frame.size.width + self.scene.size.width ||
            node.position.x < -node.frame.size.height )
            [_nodesToRemove addObject:node];
    }
    
    for ( Asteroid * node in _cachedAsteroids )
    {
        if ( node.position.y < -node.frame.size.height )
            [_nodesToRemove addObject:node];
    }
    
    for ( PowerUp * node in _cachedPowerUps )
    {
        if ( node.position.y < -node.frame.size.height ||
            node.position.x > self.scene.size.width + node.frame.size.width ||
            node.position.x < -node.frame.size.width )
            [_nodesToRemove addObject:node];
    }
    
    for ( SKNode * node in _nodesToRemove )
        [node removeFromParent];
    
    [_nodesToRemove removeAllObjects];
    
    [self checkBackground];
}

- (void) didBeginContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody * firstBody;
    SKPhysicsBody * secondBody;
    
    // order the bodies, as they can appear in any order
    if ( contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask )
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ( ! firstBody.node.parent || ! secondBody.node.parent )
        return; //glitch with spritekit collision bodies - didBeginContact gets called twice
                //since i am usually removing at least one body, this will 'solve' it
    
//    NSLog(@"body a : %@ %i", firstBody.node.name, firstBody.categoryBitMask);
//    NSLog(@"body b : %@ %i", secondBody.node.name, secondBody.categoryBitMask);
    
    
    /*---  laser and electricity are handled in the update method  ---*/
    
    if ( [firstBody.node.name isEqualToString:@"asteroid"] )
    {
        if ( [secondBody.node.name isEqualToString:@"bullet"] )
        {
            [(Asteroid *)firstBody.node takeDamage:[Bullet baseDamage]*self.mySpaceship.damage];
            [secondBody.node removeFromParent];
        }
        else if ( [secondBody.node.name isEqualToString:@"photon"] )
        {
            [(Asteroid *)firstBody.node takeDamage:[Photon baseDamage]*self.mySpaceship.damage];
            [(Photon *)secondBody.node explode];
        }
        else if ( [secondBody.node.name isEqualToString:@"shield"] )
        {
            [(Asteroid *)firstBody.node crumble];
            [(Shield *)secondBody.node takeDamage];
        }
    }
    else if ( [firstBody.node.name isEqualToString:@"spaceship"] && [secondBody.node.name isEqualToString:@"asteroid"] )
    {
        [(Spaceship *)firstBody.node takeDamage];
        [(Asteroid *)secondBody.node crumble];
    }
    else if ( [secondBody.node.name containsString:@"enemy"] )
    {
        if ( [firstBody.node.name isEqualToString:@"spaceship"] )
        {
            [(Spaceship *)firstBody.node takeDamage];
            [(Enemy *)secondBody.node explode];
        }
        else if ( [firstBody.node.name isEqualToString:@"photon"] )
        {
            [(Enemy *)secondBody.node takeDamage:[Photon baseDamage]*self.mySpaceship.damage];
            [(Photon *)firstBody.node explode];
        }
        else if ( [firstBody.node.name isEqualToString:@"bullet"] )
        {
            [(Enemy *)secondBody.node takeDamage:[Bullet baseDamage]*self.mySpaceship.damage];
            [firstBody.node removeFromParent];
        }
    }
    /*else if ( [firstBody.node.name isEqualToString:@"spaceship"] && [secondBody.node.name isEqualToString:@"pellet"] )
    {
        [(Spaceship *)firstBody.node takeDamage];
        [(Pellet *)secondBody.node explode];
    }
    else if ( [secondBody.node.name isEqualToString:@"boss"] )
    {
        Boss1 * tmpBoss = (Boss1 *)secondBody.node;
        if ( [firstBody.node.name isEqualToString:@"bullet"] )
            [tmpBoss takeDamage:[Bullet baseDamage]*self.mySpaceship.damage];
        else if ( [firstBody.node.name isEqualToString:@"photon"] )
            [tmpBoss takeDamage:[Photon baseDamage]*self.mySpaceship.damage];
    }*/
    else if ( [secondBody.node.name containsString:@"powerUp"] && [firstBody.node.name isEqualToString:@"spaceship"] )
    {
        PowerUp * tmpPowerUp = (PowerUp *)secondBody.node;
        [self.mySpaceship powerUpCollected:tmpPowerUp.powerUpType];
        tmpPowerUp.physicsBody = nil;
        [tmpPowerUp runAction:[SKAction fadeOutWithDuration:.2] completion:^
        {
            [tmpPowerUp removeFromParent];
        }];
    }
    else if ( [secondBody.node.name isEqualToString:@"shield"] )
    {
        if ( [firstBody.node.name containsString:@"powerUp"] )
        {
            PowerUp * tmpPowerUp = (PowerUp *)firstBody.node;
            [self.mySpaceship powerUpCollected:tmpPowerUp.powerUpType];
            tmpPowerUp.physicsBody = nil;
            [tmpPowerUp runAction:[SKAction fadeOutWithDuration:.2] completion:^
             {
                 [tmpPowerUp removeFromParent];
             }];
        }
        /*
        if ( [firstBody.node.name isEqualToString:@"pellet"] )
        {
            [(Pellet *)firstBody.node explode];
            [(Shield *)secondBody.node takeDamage];
        }
        else */
        else if ( [firstBody.node.name containsString:@"enemy"] )
        {
            [(Enemy *)firstBody.node explode];
            [(Shield *)secondBody.node takeDamage];
        }
    }
}

#pragma mark enemies
- (void) addEnemies
{
    int randomEnemyType = arc4random_uniform(kEnemyTypeCount);
    int amountOfEnemies = skRand(1, self.rangeOfEnemiesToAdd);
    //NSLog(@"amountOfEnemies : %i", amountOfEnemies);
    
    if ( randomEnemyType == kEnemyTypeBasic )
        [self.enemyKit addEnemiesBasic:amountOfEnemies toScene:self withSpeed:self.enemySpeedCoefficient];
    else if ( randomEnemyType == kEnemyTypeFast )
        [self.enemyKit addEnemiesFast:amountOfEnemies toScene:self withSpeed:self.enemySpeedCoefficient];
    else if ( randomEnemyType == kEnemyTypeBig )
        [self.enemyKit addEnemiesBig:1 toScene:self withSpeed:self.enemySpeedCoefficient];
}

- (void) moreEnemies
{
    [self removeActionForKey:@"makeEnemies"];
    self.makeEnemiesInterval = .95*self.makeEnemiesInterval;
    self.rangeOfEnemiesToAdd++;
    self.enemySpeedCoefficient *= .97;
    SKAction * makeEnemies = [SKAction sequence:
                              @[[SKAction performSelector:@selector(addEnemies) onTarget:self],
                                [SKAction waitForDuration:self.makeEnemiesInterval withRange:3]]];
    
    [self runAction:[SKAction repeatActionForever:makeEnemies] withKey:@"makeEnemies"];
}

- (void) enemyExploded:(Enemy *)enemy
{
    //NSLog(@"enemyExploded");
    self.enemiesDestroyed++;
    [self pointsScored:enemy.pointValue];
    [self flashMultiplierOnNode:enemy];
    
    self.enemiesDestroyedWithoutTakingDamage++;
    self.scoreMultiplier = (self.enemiesDestroyedWithoutTakingDamage/10)+1;
    if ( self.mySpaceship.energyBoosterActive )
        self.scoreMultiplier *= 2;
    
    if ( [[self.scoreMultiplierLabel.text stringByReplacingOccurrencesOfString:@"x" withString:@""] intValue] != self.scoreMultiplier )
        [self updateScoreMultiplierLabel];
    
    if ( self.mySpaceship.armor && !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypeScoringPoints] )
    {
        self.showingTooltip = YES;
        //the delay is so the pause occurs while the explosion is on screen
        SKSpriteNode * tooltipArrow = [self tooltipArrowAt:self.pointsScoredLabel];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
        {
            
            [self pauseGame];
            NSString * alertTitle = NSLocalizedString(@"Ermahgerd!", nil);
            NSString * alertMessage = NSLocalizedString(@"You just blew up an alien spaceship! The more stuff you blow up, The more points you score!", nil);
            SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
            unlockAlert.customFrame = CGRectMake(0, (self.size.height+self.view.frame.origin.y) - 230, self.size.width, 150);
            [unlockAlert show];
            unlockAlert.otherButtonAction = ^
            {
                [self removeTooltipArrow:tooltipArrow];
                [self resumeGame];
                self.showingTooltip = NO;
            };
            unlockAlert.cancelButtonAction = ^
            {
                [self removeTooltipArrow:tooltipArrow];
                [AccountManager disableTips];
                [self resumeGame];
                self.showingTooltip = NO;
            };
        });
    }
}

#pragma mark asteroids
- (void) addAsteroid
{
    float angle = skRand(self.minimumAsteroidDegree, self.maximumAsteroidDegree);
    [self.spaceObjectKit addAsteroidWithSpeed:(self.asteroidSpeedCoefficient*3)+2 angle:angle];
}

- (void) moreAsteroids
{
    [self removeActionForKey:@"makeAsteroids"];
    self.makeAsteroidsInterval -= .08*self.makeAsteroidsInterval;
    self.asteroidSpeedCoefficient += .06;
    
    BOOL randomBool = arc4random_uniform(2);
    if ( randomBool )
        self.minimumAsteroidDegree -= 1.5;
    else
        self.maximumAsteroidDegree += 1.5;
    
    SKAction * makeAsteroids = [SKAction sequence:
                                @[[SKAction performSelector:@selector(addAsteroid) onTarget:self],
                                  [SKAction waitForDuration:self.makeAsteroidsInterval withRange:.15]]];
    
    [self runAction:[SKAction repeatActionForever:makeAsteroids] withKey:@"makeAsteroids"];
    
    //also using this method to increase particle speed
    SKEmitterNode * spaceDust1 = (SKEmitterNode *)[self childNodeWithName:@"stars"];
    spaceDust1.particleSpeed += 5;
    SKEmitterNode * spaceDust2 = (SKEmitterNode *)[self childNodeWithName:@"stars2"];
    spaceDust2.particleSpeed += 5;
    
    [self.mySpaceship enumerateChildNodesWithName:@"exhaust" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
    {
        SKEmitterNode * exhaust = (SKEmitterNode *)node;
        exhaust.particleSpeed += 1;
    }];
}

- (void) asteroidCrumbled:(Asteroid *)asteroid
{
    [self pointsScored:asteroid.pointValue];
    [self flashMultiplierOnNode:asteroid];
}

#pragma mark spaceship delegate
- (void) spaceshipEquippedWeapon:(PlayerWeapon *)weapon
{
    if ( !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypePowerUp ] )
    {
        self.showingTooltip = YES;
        SKSpriteNode * tooltipArrow = [self tooltipArrowAt:weapon];
        [self pauseGame];
        
        NSString * alertTitle = NSLocalizedString(@"Weapon PowerUp!", nil);
        NSString * alertMessage = NSLocalizedString(@"You just picked up a weapon! Pick up the same weapon again to upgrade it", nil);
        SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
        unlockAlert.customFrame = CGRectMake(0, 0, self.size.width, 170);
        [unlockAlert show];
        unlockAlert.otherButtonAction = ^
        {
            [self removeTooltipArrow:tooltipArrow];
            [self resumeGame];
            self.showingTooltip = NO;
        };
        unlockAlert.cancelButtonAction = ^
        {
            [self removeTooltipArrow:tooltipArrow];
            [AccountManager disableTips];
            [self resumeGame];
            self.showingTooltip = NO;
        };
        
    }
}

- (void) energyBoosterChanged:(Spaceship *)spaceship
{
    if ( spaceship.energyBoosterActive )
        self.scoreMultiplier *= 2;
    else
        self.scoreMultiplier /= 2;
    
    [self updateScoreMultiplierLabel];
}

- (void) spaceshipTookDamage:(Spaceship *)spaceship
{
    [_healthBar setProgress:[spaceship healthPercentage] animated:YES];
    
    //NSLog(@"spaceshipTookDamage");
    self.enemiesDestroyedWithoutTakingDamage = 0;
    
    if ( self.mySpaceship.energyBoosterActive )
        self.scoreMultiplier = 2;
    else
        self.scoreMultiplier = 1;
    
    if ( [[self.scoreMultiplierLabel.text stringByReplacingOccurrencesOfString:@"x" withString:@""] intValue] != self.scoreMultiplier )
        [self updateScoreMultiplierLabel];
    
    if ( !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypeAvoidObstacles ] )
    {
        self.showingTooltip = YES;
        //the delay is so the pause occurs while the explosion is on screen
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^
        {
            if ( spaceship.armor != 0 )
                [self pauseGame];
            
            SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:@"" message:@"" cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
            
            UIView * alertContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 140)];
            UILabel * alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.size.width, 20)];
            alertTitleLabel.textColor = _SAPink;
            [alertTitleLabel setFont:[UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.size.width*0.05625]];
            [alertTitleLabel setTextAlignment:NSTextAlignmentCenter];
            alertTitleLabel.text = NSLocalizedString(@"Ouch!", nil);
            [alertContentView addSubview:alertTitleLabel];
            UILabel * alertMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.size.width, 20)];
            alertMessageLabel.textColor = _SAPink;
            [alertMessageLabel setFont:[UIFont fontWithName:NSLocalizedString(@"font1", nil) size:self.size.width*0.040625]];
            [alertMessageLabel setTextAlignment:NSTextAlignmentCenter];
            alertMessageLabel.text = NSLocalizedString(@"Try to avoid objects like these:", nil);
            [alertContentView addSubview:alertMessageLabel];

            UIImageView * obstacle1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"asteroidImage.png"]];
            obstacle1.frame = CGRectMake((((self.size.width/4) * 1)-30/2)-(self.size.width/8), 92 - 30/2,
                                         30, 30);
            [alertContentView addSubview:obstacle1];
            UIImageView * obstacle2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyBasic.png"]];
            obstacle2.frame = CGRectMake((((self.size.width/4) * 2)-50/2)-(self.size.width/8), 92 - 50/2,
                                         50, 50);
            [alertContentView addSubview:obstacle2];
            UIImageView * obstacle3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyFast.png"]];
            obstacle3.frame = CGRectMake((((self.size.width/4) * 3)-65/2)-(self.size.width/8), 92 - 65/2,
                                         65, 65);
            [alertContentView addSubview:obstacle3];
            UIImageView * obstacle4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyBig.png"]];
            obstacle4.frame = CGRectMake((((self.size.width/4) * 4)-50/2)-(self.size.width/8), 92 - 50/2,
                                         50, 50);
            [alertContentView addSubview:obstacle4];
            
            unlockAlert.contentView = alertContentView;
            unlockAlert.customFrame = CGRectMake(0, 0, unlockAlert.frame.size.width, unlockAlert.frame.size.height);
            [unlockAlert show];
            unlockAlert.otherButtonAction = ^
            {
                [self resumeGame];
                self.showingTooltip = NO;
            };
            unlockAlert.cancelButtonAction = ^
            {
                [AccountManager disableTips];
                [self resumeGame];
                self.showingTooltip = NO;
            };
        });
    }
}

- (void) spaceshipExploded:(Spaceship *)spaceship
{
    NSLog(@"spaceshipExploded");
    [self.sharedGameplayControls stopControllerUpdates];
    self.sharedGameplayControls.delegate = nil;
    [self.asteroidTimer invalidate];
    self.resumeAsteroidTimer = NO;
    [self.enemyTimer invalidate];
    self.resumeEnemyTimer = NO;
    [self.periodicAchievementUpdatingTimer invalidate];
    self.resumePeriodicAchievementUpdatingTimer = NO;
    [self removeActionForKey:@"makeAsteroids"];
    [self removeActionForKey:@"makeEnemies"];
    [self removeActionForKey:@"makePowerUps"];
    [self updateScoreMultiplierLabel];
    [self showEndGameScreen];
    [[AudioManager sharedInstance] fadeOutGameplayMusic];
    for ( Enemy * enemy in _cachedEnemies )
        [enemy runAction:[SKAction fadeOutWithDuration:1]];
}

#pragma mark shield delegate
- (void) shieldTookDamage:(Shield *)shield
{
    
}

- (void) shieldDestroyed:(Shield *)shield
{
    [shield removeFromParent];
}

#pragma mark tooltips
- (SKSpriteNode *)tooltipArrowAt:(SKNode *)node
{
    SKSpriteNode * arrow;
    CGPoint positionInScene = node.position;
    
    if ( [node class] == [MachineGun class] ||
         [node class] == [PhotonCannon class] ||
         [node class] == [LaserCannon class] ||
         [node class] == [ElectricalGenerator class] )
        positionInScene = [self convertPoint:node.position fromNode:node.parent];
    
    
    if ( positionInScene.x > self.size.width/2 )
    {
        if ( [node class] == [SKLabelNode class] )
            arrow = [SKSpriteNode spriteNodeWithImageNamed:@"tooltipArrowRight"];
        else
            arrow = [SKSpriteNode spriteNodeWithImageNamed:@"tooltipArrowDownRight"];
        
        positionInScene = CGPointMake(positionInScene.x-arrow.size.width, positionInScene.y+(node.frame.size.height/2)+(arrow.size.height/2));
    }
    else
    {
        if ( [node class] == [SKLabelNode class] )
            arrow = [SKSpriteNode spriteNodeWithImageNamed:@"tooltipArrowLeft"];
        else
            arrow = [SKSpriteNode spriteNodeWithImageNamed:@"tooltipArrowDownLeft"];
        
        positionInScene = CGPointMake(positionInScene.x+arrow.size.width, positionInScene.y+(node.frame.size.height/2)+(arrow.size.height/2));
    }
    
    if ( [node class] == [SKLabelNode class] )
        positionInScene = CGPointMake((self.size.width/2) + (arrow.size.width/2) + 8, positionInScene.y + 5) ;
    
    arrow.position = positionInScene;
    [self addChild:arrow];
    return arrow;
}

- (void) removeTooltipArrow:(SKSpriteNode *)tooltipArrow
{
    [tooltipArrow runAction:[SKAction fadeAlphaTo:0 duration:.3] completion:^
    {
        [tooltipArrow removeFromParent];
    }];
}

#pragma mark - caching sprite nodes
#pragma mark also used for achievements
- (void) addChild:(SKNode *)node
{
    [super addChild:node];
    
    //electricity and laser projectiles are added from player weapon delegate method (didAddProjectile:forWeapon:)
    if ( [node isKindOfClass:[Enemy class]] )
        [_cachedEnemies addObject:node];
    else if ( [node class] == [Asteroid class] )
        [_cachedAsteroids addObject:node];
    else if ( [node class] == [Photon class] )
    {
        [_cachedPhotons addObject:node];
        self.photonsFired++;
    }
    else if ( [node class] == [Bullet class] )
    {
        [_cachedBullets addObject:node];
        self.bulletsFired++;
    }
    else if ( [node class] == [PowerUp class] )
    {
        [_cachedPowerUps addObject:node];
        self.powerUpsCollected++;
    }
    else if ( [node.name isEqualToString:@"spaceBackground"] )
        [_cachedSpaceBackgrounds addObject:node];
}

- (void) removeCachedSpriteNode:(SKSpriteNode *)spriteNode
{
    if ( [spriteNode isKindOfClass:[Enemy class]] )
        [_cachedEnemies removeObject:spriteNode];
    else if ( [spriteNode class] == [Asteroid class] )
        [_cachedAsteroids removeObject:spriteNode];
    else if ( [spriteNode class] == [Photon class] )
        [_cachedPhotons removeObject:spriteNode];
    else if ( [spriteNode class] == [Bullet class] )
        [_cachedBullets removeObject:spriteNode];
    else if ( [spriteNode class] == [PowerUp class] )
        [_cachedPowerUps removeObject:spriteNode];
    else if ( [spriteNode class] == [SpaceBackground class] )
        [_cachedSpaceBackgrounds removeObject:spriteNode];
    else if ( [spriteNode class] == [Electricity class] )
        [_cachedElectricity removeObject:spriteNode];
    else if ( [spriteNode class] == [Laser class] )
        [_cachedLasers removeObject:spriteNode];
    
}

#pragma player weapon delegate
- (void) didAddProjectile:(SKSpriteNode *)projectile forWeapon:(PlayerWeapon *)weapon
{
    if ( [projectile class] == [Electricity class] )
    {
        [_cachedElectricity addObject:projectile];
        self.electricityFired++;
    }
    else if ( [projectile class] == [Laser class] )
    {
        [_cachedLasers addObject:projectile];
        self.lasersFired++;
    }
}

#pragma mark SASpriteNode delegate
- (void) SASpriteNodeRemovingFromParent:(SASpriteNode *)node
{
    [self removeCachedSpriteNode:node];
}

@end
