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
#import <Crashlytics/Crashlytics.h>

@implementation SpaceshipScene

- (void) didMoveToView:(SKView *)view
{
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    if ( !self.contentCreated )
    {
        [AudioManager sharedInstance].scene = self;
        [self createSceneContents];
        self.contentCreated = YES;
        //view.showsFPS = YES;
        self.nodesToRemove = [NSMutableArray new];
        self.cachedAsteroids = [NSMutableArray new];
        self.cachedEnemies = [NSMutableArray new];
        self.cachedBullets = [NSMutableArray new];
        self.cachedLasers = [NSMutableArray new];
        self.cachedPhotons = [NSMutableArray new];
        self.cachedElectricity = [NSMutableArray new];
        self.cachedPowerUps = [NSMutableArray new];
        self.cachedSpaceBackgrounds = [NSMutableArray new];
        
        self.bulletsFired = 0;
        self.photonsFired = 0;
        self.lasersFired = 0;
        self.electricityFired = 0;
        self.enemiesDestroyed = 0;
        self.powerUpsCollected = 0;
        
        [Answers logLevelStart:nil customAttributes:@{}];
        
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
    
    
    self.pointsScoredLabel = [SKLabelNode labelNodeWithFontNamed:@"Moon-Bold"];
    self.pointsScoredLabel.text = [NSString stringWithFormat:@"%i", self.pointsScored];
    self.pointsScoredLabel.fontSize = 15;
    self.pointsScoredLabel.fontColor = [SKColor whiteColor];
    self.pointsScoredLabel.position = CGPointMake(self.size.width/2, 25);
    [self addChild:self.pointsScoredLabel];
    
    self.enemiesDestroyedWithoutTakingDamage = 0;
    self.scoreMultiplier = 1;
    self.scoreMultiplierLabel = [SKLabelNode labelNodeWithFontNamed:@"Moon-Bold"];
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
    
    NSString * starsPath = [[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"];
    SKEmitterNode * stars = [NSKeyedUnarchiver unarchiveObjectWithFile:starsPath];
    stars.name = @"stars";
    stars.zPosition = -75;
    stars.position = CGPointMake(self.size.width/2, self.size.height+20);
    [self addChild:stars];
    
    self.backgroundPlanetsTimer = [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(showPlanetInBackground) userInfo:nil repeats:YES];
    
    self.showingTooltip = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^
    {
        if ( !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypeMoveSpaceship] )
        {
            self.showingTooltip = YES;
            [self pauseGame];
            
            NSString * alertTitle = NSLocalizedString(@"How to Move:", nil);
            NSString * alertMessage = NSLocalizedString(@"Tilt the screen to move your ship", nil);
            SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
            unlockAlert.customFrame = CGRectMake(0, 0, self.size.width, unlockAlert.frame.size.height);
            unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:0];
            unlockAlert.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:18];
            unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13];
            unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
            unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
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
    
//#warning change to randomPowerUp for release
    PowerUp * tmpPowerUp = [[PowerUp alloc] initWithPowerUpType:randomPowerUp];
    tmpPowerUp.delegate = self;
    tmpPowerUp.position = CGPointMake(skRand(0, self.size.width), self.size.height+tmpPowerUp.size.height);
    [self addChild:tmpPowerUp];
    float deviceSizeFactor = self.size.width*0.00008;
    float deviceSizeFactor2 = self.size.width*0.00025;
    float deviceSizeFactor3 = self.size.width*0.000055;
    [tmpPowerUp.physicsBody applyImpulse:CGVectorMake(skRand(-tmpPowerUp.size.width*deviceSizeFactor, tmpPowerUp.size.width*deviceSizeFactor),
                                                      -(tmpPowerUp.size.width + tmpPowerUp.size.height)*deviceSizeFactor2)];
    [tmpPowerUp.physicsBody applyTorque:skRand(-deviceSizeFactor3, deviceSizeFactor3)];
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
                [self pauseGame];
                NSString * alertTitle = NSLocalizedString(@"Ermahgerd!", nil);
                NSString * alertMessage = NSLocalizedString(@"Blowing up aliens without taking damage makes your multiplier go up!", nil);
                SAAlertView * unlockAlert = [[SAAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
                unlockAlert.customFrame = CGRectMake(0, (self.size.height+self.view.frame.origin.y) - 220, self.size.width, 150);
                unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:0];
                unlockAlert.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:18];
                unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13];
                unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
                unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
                [unlockAlert show];
                SKSpriteNode * tooltipArrow = [self tooltipArrowAt:self.scoreMultiplierLabel];
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
    
    SKLabelNode * tmpMultiplierLabel = [SKLabelNode labelNodeWithFontNamed:@"Moon-Bold"];
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
    
    if ( [self.backgroundPlanetsTimer isValid] )
        self.resumeBackgroundPlanetsTimer = YES;
    else
        self.resumeBackgroundPlanetsTimer = NO;
    [self.backgroundPlanetsTimer invalidate];
    
    if ( [self.changeCloudDensityTimer isValid] )
        self.resumeChangeCloudDensityTimer = YES;
    else
        self.resumeChangeCloudDensityTimer = NO;
    [self.changeCloudDensityTimer invalidate];
    
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
    
    if ( self.resumeBackgroundPlanetsTimer )
        self.backgroundPlanetsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(showPlanetInBackground) userInfo:nil repeats:YES];
    
    if ( self.resumeChangeCloudDensityTimer )
        self.changeCloudDensityTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(changeCloudDensity) userInfo:nil repeats:YES];
    
    if ( self.resumePeriodicAchievementUpdatingTimer )
        self.periodicAchievementUpdatingTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(submitAchievementProgress) userInfo:nil repeats:YES];
    
    [[AudioManager sharedInstance] pauseMachineGuns:NO];
}

- (void) showEndGameScreen
{
    [AccountManager incrementNumberOfTimesPlayed];
    [Answers logLevelEnd:nil
                   score:[NSNumber numberWithInt:self.pointsScored]
                 success:nil
        customAttributes:@{@"Flight Number" : [NSNumber numberWithInt:[AccountManager numberOfTimesPlayed]]}];
    
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
    if ( [self.view isPaused] )
        return;
    
    int xCoord = self.size.width/2 + (acceleration.x * self.size.width/2);
    int yCoord = self.size.height/2 + (acceleration.y * self.size.height/2);
    SKAction * moveSpaceship = [SKAction moveTo:CGPointMake(xCoord, yCoord) duration:5.0/self.mySpaceship.mySpeed];
    
    //float degreeDifference = (360 - self.sharedGameplayControls.initialHeading) - (360 - heading.magneticHeading);
    //float newAngle = -DEGREES_TO_RADIANS(degreeDifference);
    //SKAction * rotateSpaceship = [SKAction rotateToAngle:newAngle duration:5.0/self.mySpaceship.mySpeed shortestUnitArc:YES];
    
    //[self.mySpaceship runAction:rotateSpaceship];
    [self.mySpaceship runAction:moveSpaceship]; //crash occurs here intermittenly
                                                //it may be a spriekit bug for older devices:
                                                //https://forums.developer.apple.com/thread/17267
}

#pragma mark photon/electricity stuff
- (SKNode *) nextPriorityTargetForPhoton:(Photon *)photon
{
    __block SKNode * closestTarget = nil;
    __block float closestDistance = -1;
    
    for ( Asteroid * tmpAsteroid in self.cachedAsteroids )
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
    
    for ( Enemy * tmpEnemy in self.cachedEnemies )
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
    
    for ( Asteroid * node in self.cachedAsteroids )
    {
        float distance = pow(node.position.x - electricityPointInScene.x, 2) + pow(node.position.y - electricityPointInScene.y, 2);
        // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
        if ( (distance < closestDistance || closestDistance == -1) && ![(Asteroid *)node isBeingElectrocuted] )
        {
            closestDistance = distance;
            closestTarget = node;
        }
    }
    
    for ( Enemy * node in self.cachedEnemies )
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
    for ( Photon * node in self.cachedPhotons )
        [(Photon *)node update:currentTime];
    
    //electricity
    NSMutableArray * asteroidsToTakeDmgFromElectricity = [NSMutableArray new];
    NSMutableArray * enemiesToTakeDmgFromElectricity = [NSMutableArray new];
    for ( Electricity * tmpElectricityNode in self.cachedElectricity )
    {
        [tmpElectricityNode update:currentTime];
        
        for ( Asteroid * node1 in self.cachedAsteroids )
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
        
        for ( Enemy * node1 in self.cachedEnemies )
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
    for ( Laser * node in self.cachedLasers )
    {
        Laser * tmpLaser = (Laser *)node;
        
        for ( Asteroid * node1 in self.cachedAsteroids )
        {
            if ( [tmpLaser intersectsNode:node1] )
                [asteroidsToTakeDmgFromLaser addObject:node1];
        }
        
        for ( Enemy * node1 in self.cachedEnemies )
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
    for ( Bullet * node in self.cachedBullets )
    {
        if ( node.position.y > self.scene.size.height + node.frame.size.height ||
            node.position.y < -node.frame.size.height ||
            node.position.x > self.scene.size.width + node.frame.size.width ||
            node.position.x < -node.frame.size.width )
            [self.nodesToRemove addObject:node];
    }
    
    for ( Photon * node in self.cachedPhotons )
    {
        if ( node.position.y > self.scene.size.height + 100 ||
            node.position.y < -100 ||
            node.position.x > self.scene.size.width + 100 ||
            node.position.x < -100)
            [self.nodesToRemove addObject:node];
    }
    
    for ( Enemy * node in self.cachedEnemies )
    {
        if ( node.position.y <= -node.frame.size.height ||
            node.position.x > node.frame.size.width + self.scene.size.width ||
            node.position.x < -node.frame.size.height )
            [self.nodesToRemove addObject:node];
    }
    
    for ( Asteroid * node in self.cachedAsteroids )
    {
        if ( node.position.y < -node.frame.size.height )
            [self.nodesToRemove addObject:node];
    }
    
    for ( PowerUp * node in self.cachedPowerUps )
    {
        if ( node.position.y < -node.frame.size.height ||
            node.position.x > self.scene.size.width + node.frame.size.width ||
            node.position.x < -node.frame.size.width )
            [self.nodesToRemove addObject:node];
    }
    
    //[self removeChildrenInArray:self.nodesToRemove]; //this doesnt work for some reason
    for ( SKNode * node in self.nodesToRemove )
        [node removeFromParent];
    
    [self.nodesToRemove removeAllObjects];
    
    __block BOOL allSpaceBackgroundsAreBelowTopOfScreen = YES;
    for ( SpaceBackground * spaceBackground in self.cachedSpaceBackgrounds )
    {
        if ( spaceBackground.position.y > -(spaceBackground.size.height/2 - self.size.height) )
            allSpaceBackgroundsAreBelowTopOfScreen = NO;
    }
    
    //float alpha = CGColorGetAlpha(self.backgroundColor.CGColor);
    
    if ( allSpaceBackgroundsAreBelowTopOfScreen )//&& alpha < .5 )
    {
        [self.spaceObjectKit addSpaceBackground];
        SKEmitterNode * stars = (SKEmitterNode *)[self childNodeWithName:@"stars"];
        float newBirthRate = stars.particleBirthRate*8;
        float newScaleRange = stars.particleScaleRange*3;
        float newSpeedRange = stars.particleSpeedRange*2;
        
        if ( newBirthRate > 20 )
            newBirthRate = 20;
        if ( newScaleRange > .18 )
            newScaleRange = .18;
        if ( newSpeedRange > 20 )
            newSpeedRange = 20;
        
        stars.particleBirthRate = newBirthRate;
        stars.particleScaleRange = newScaleRange;
        stars.particleSpeedRange = newSpeedRange;
    }
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
    
    //NSLog(@"body a : %@ %i", firstBody.node.name, firstBody.categoryBitMask);
    //NSLog(@"body b : %@ %i", secondBody.node.name, secondBody.categoryBitMask);
    
    
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
        /*
        if ( [firstBody.node.name isEqualToString:@"pellet"] )
        {
            [(Pellet *)firstBody.node explode];
            [(Shield *)secondBody.node takeDamage];
        }
        else */
        if ( [firstBody.node.name containsString:@"enemy"] )
        {
            [(Enemy *)firstBody.node explode];
            [(Shield *)secondBody.node takeDamage];
        }
    }
}

#pragma mark background
- (void) showPlanetInBackground
{
    float alpha = 1 - CGColorGetAlpha(self.backgroundColor.CGColor);
    [self.spaceObjectKit addPlanetToBackgroundWithAlpha:alpha];
}

- (void) changeCloudDensity
{
//    SKEmitterNode * clouds = (SKEmitterNode *)[self childNodeWithName:@"cloudsEmitter"];
//    clouds.particleBirthRate = skRand(.02, 1.2);
//    clouds.particleSpeed = clouds.particleSpeed + 10;
//    
//    SKEmitterNode * cloudsOnTop = (SKEmitterNode *)[self childNodeWithName:@"cloudsOnTopEmitter"];
//    cloudsOnTop.particleBirthRate = skRand(.01, .5);
//    cloudsOnTop.particleSpeed = cloudsOnTop.particleSpeed + 10;
    
    [self.mySpaceship increaseExhaustSpeed];
    [self adjustBackground];
}

- (void) adjustBackground
{
    return;
    
    const CGFloat * colors = CGColorGetComponents(self.backgroundColor.CGColor);
    float alpha = CGColorGetAlpha(self.backgroundColor.CGColor);
    
    UIColor * newColor = [UIColor colorWithRed:colors[0]-.1 green:colors[1]-.05 blue:colors[2]-.05 alpha:alpha-=.05];
    
    [UIView animateWithDuration:1 animations:^{
        self.backgroundColor = newColor;
    }];
    
    for ( SpaceBackground * node in self.cachedSpaceBackgrounds )
        [node runAction:[SKAction fadeAlphaTo:1-alpha duration:5]];
}

#pragma mark enemies
- (void) addEnemies
{
    int randomEnemyType = arc4random_uniform(kEnemyTypeCount);
    int amountOfEnemies = skRand(1, self.rangeOfEnemiesToAdd);
    //NSLog(@"amountOfEnemies : %i", amountOfEnemies);
    
    NSArray * enemies;
    if ( randomEnemyType == kEnemyTypeBasic )
        enemies = [self.enemyKit addEnemiesBasic:amountOfEnemies toScene:self withSpeed:self.enemySpeedCoefficient];
    else if ( randomEnemyType == kEnemyTypeFast )
        enemies = [self.enemyKit addEnemiesFast:amountOfEnemies toScene:self withSpeed:self.enemySpeedCoefficient];
    else if ( randomEnemyType == kEnemyTypeBig )
        enemies = [self.enemyKit addEnemiesBig:1 toScene:self withSpeed:self.enemySpeedCoefficient];
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
    
    if ( !self.showingTooltip && [AccountManager shouldShowTooltip:kTooltipTypeScoringPoints] )
    {
        self.showingTooltip = YES;
        [self pauseGame];
        NSString * alertTitle = NSLocalizedString(@"Ermahgerd!", nil);
        NSString * alertMessage = NSLocalizedString(@"You just blew up an alien spaceship! The more stuff you blow up, The more points you score!", nil);
        DQAlertView * unlockAlert = [[DQAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
        unlockAlert.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        unlockAlert.customFrame = CGRectMake(0, (self.size.height+self.view.frame.origin.y) - 230, self.size.width, 150);
        unlockAlert.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
        unlockAlert.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
        unlockAlert.appearTime = .4;
        unlockAlert.disappearTime = .4;
        unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:0];
        unlockAlert.titleLabel.numberOfLines = 2;
        unlockAlert.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:18];
        unlockAlert.titleLabel.textColor = [UIColor whiteColor];
        unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13];
        unlockAlert.messageLabel.textColor = [UIColor whiteColor];
        unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
        [unlockAlert.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
        [unlockAlert.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [unlockAlert show];
        SKSpriteNode * tooltipArrow = [self tooltipArrowAt:self.pointsScoredLabel];
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
    self.asteroidSpeedCoefficient += .03;
    
    BOOL randomBool = arc4random_uniform(2);
    if ( randomBool )
        self.minimumAsteroidDegree -= 1.5;
    else
        self.maximumAsteroidDegree += 1.5;
    
    SKAction * makeAsteroids = [SKAction sequence:
                                @[[SKAction performSelector:@selector(addAsteroid) onTarget:self],
                                  [SKAction waitForDuration:self.makeAsteroidsInterval withRange:.15]]];
    
    [self runAction:[SKAction repeatActionForever:makeAsteroids] withKey:@"makeAsteroids"];
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
        [self pauseGame];
        
        NSString * alertTitle = NSLocalizedString(@"Weapon PowerUp!", nil);
        NSString * alertMessage = NSLocalizedString(@"You just picked up a weapon! Pick up the same weapon again to upgrade it", nil);
        DQAlertView * unlockAlert = [[DQAlertView alloc] initWithTitle:alertTitle message:alertMessage cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
        unlockAlert.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        //unlockAlert.customFrame = CGRectMake(30, 30, 200, 150);
        //unlockAlert.contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"missile.png"]];
        unlockAlert.customFrame = CGRectMake(0, 0, self.size.width, 170);
        unlockAlert.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
        unlockAlert.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
        unlockAlert.appearTime = .4;
        unlockAlert.disappearTime = .4;
        unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:0];
        unlockAlert.titleLabel.numberOfLines = 2;
        unlockAlert.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:18];
        unlockAlert.titleLabel.textColor = [UIColor whiteColor];
        unlockAlert.messageLabel.font = [UIFont fontWithName:@"Moon-Bold" size:13];
        unlockAlert.messageLabel.textColor = [UIColor whiteColor];
        unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
        [unlockAlert.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
        [unlockAlert.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [unlockAlert show];
        SKSpriteNode * tooltipArrow = [self tooltipArrowAt:weapon];
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
        if ( spaceship.armor != 0 )
            [self pauseGame];
        
        DQAlertView * unlockAlert = [[DQAlertView alloc] initWithTitle:@"" message:@"" cancelButtonTitle:NSLocalizedString(@"Disable Tips", nil) otherButtonTitle:NSLocalizedString(@"Got It", nil)];
        
        unlockAlert.cancelButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        UIView * alertContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.size.width, 140)];
        UILabel * alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.size.width, 20)];
        alertTitleLabel.textColor = [UIColor whiteColor];
        [alertTitleLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:18]];
        [alertTitleLabel setTextAlignment:NSTextAlignmentCenter];
        alertTitleLabel.text = NSLocalizedString(@"Ouch!", nil);
        [alertContentView addSubview:alertTitleLabel];
        UILabel * alertMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, self.size.width, 20)];
        alertMessageLabel.textColor = [UIColor whiteColor];
        [alertMessageLabel setFont:[UIFont fontWithName:@"Moon-Bold" size:13]];
        [alertMessageLabel setTextAlignment:NSTextAlignmentCenter];
        alertMessageLabel.text = NSLocalizedString(@"Try to avoid objects like these:", nil);
        [alertContentView addSubview:alertMessageLabel];

        UIImageView * obstacle1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"asteroidImage.png"]];
        obstacle1.frame = CGRectMake((((self.size.width/4) * 1)-obstacle1.frame.size.width/2)-(self.size.width/8), 92 - obstacle1.frame.size.height/2, obstacle1.frame.size.width, obstacle1.frame.size.height);
        [alertContentView addSubview:obstacle1];
        UIImageView * obstacle2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyBasic.png"]];
        obstacle2.frame = CGRectMake((((self.size.width/4) * 2)-obstacle2.frame.size.width/2)-(self.size.width/8), 92 - obstacle2.frame.size.height/2, obstacle2.frame.size.width, obstacle2.frame.size.height);
        [alertContentView addSubview:obstacle2];
        UIImageView * obstacle3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyFast.png"]];
        obstacle3.frame = CGRectMake((((self.size.width/4) * 3)-obstacle3.frame.size.width/2)-(self.size.width/8), 92 - obstacle3.frame.size.height/2, obstacle3.frame.size.width, obstacle3.frame.size.height);
        [alertContentView addSubview:obstacle3];
        UIImageView * obstacle4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enemyBig.png"]];
        obstacle4.frame = CGRectMake((((self.size.width/4) * 4)-obstacle4.frame.size.width/2)-(self.size.width/8), 92 - obstacle4.frame.size.height/2, obstacle4.frame.size.width, obstacle4.frame.size.height);
        [alertContentView addSubview:obstacle4];
        
        unlockAlert.contentView = alertContentView;
        unlockAlert.customFrame = CGRectMake(0, 0, unlockAlert.frame.size.width, unlockAlert.frame.size.height);
        unlockAlert.appearAnimationType = DQAlertViewAnimationTypeFadeIn;
        unlockAlert.disappearAnimationType = DQAlertViewAnimationTypeFaceOut;
        unlockAlert.appearTime = .4;
        unlockAlert.disappearTime = .4;
        unlockAlert.backgroundColor = [UIColor colorWithWhite:.2 alpha:0];
        unlockAlert.cancelButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
        [unlockAlert.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        unlockAlert.otherButton.titleLabel.font = [UIFont fontWithName:@"Moon-Bold" size:15];
        [unlockAlert.otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [self.changeCloudDensityTimer invalidate];
    self.resumeChangeCloudDensityTimer = NO;
    [self.periodicAchievementUpdatingTimer invalidate];
    self.resumePeriodicAchievementUpdatingTimer = NO;
    [self.backgroundPlanetsTimer invalidate];
    self.resumeBackgroundPlanetsTimer = NO;
    [self removeActionForKey:@"makeAsteroids"];
    [self removeActionForKey:@"makeEnemies"];
    [self removeActionForKey:@"makePowerUps"];
    SKEmitterNode * clouds = (SKEmitterNode *)[self childNodeWithName:@"cloudsEmitter"];
    clouds.particleBirthRate = 0;
    SKEmitterNode * cloudsOnTop = (SKEmitterNode *)[self childNodeWithName:@"cloudsOnTopEmitter"];
    cloudsOnTop.particleBirthRate = 0;
    [self updateScoreMultiplierLabel];
    [self showEndGameScreen];
    [[AudioManager sharedInstance] fadeOutGameplayMusic];
    for ( Enemy * enemy in self.cachedEnemies )
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
        [self.cachedEnemies addObject:node];
    else if ( [node class] == [Asteroid class] )
        [self.cachedAsteroids addObject:node];
    else if ( [node class] == [Photon class] )
    {
        [self.cachedPhotons addObject:node];
        self.photonsFired++;
    }
    else if ( [node class] == [Bullet class] )
    {
        [self.cachedBullets addObject:node];
        self.bulletsFired++;
    }
    else if ( [node class] == [PowerUp class] )
    {
        [self.cachedPowerUps addObject:node];
        self.powerUpsCollected++;
    }
    else if ( [node.name isEqualToString:@"spaceBackground"] )
        [self.cachedSpaceBackgrounds addObject:node];
}

- (void) removeCachedSpriteNode:(SKSpriteNode *)spriteNode
{
    if ( [spriteNode isKindOfClass:[Enemy class]] )
        [self.cachedEnemies removeObject:spriteNode];
    else if ( [spriteNode class] == [Asteroid class] )
        [self.cachedAsteroids removeObject:spriteNode];
    else if ( [spriteNode class] == [Photon class] )
        [self.cachedPhotons removeObject:spriteNode];
    else if ( [spriteNode class] == [Bullet class] )
        [self.cachedBullets removeObject:spriteNode];
    else if ( [spriteNode class] == [PowerUp class] )
        [self.cachedPowerUps removeObject:spriteNode];
    else if ( [spriteNode class] == [SpaceBackground class] )
        [self.cachedSpaceBackgrounds removeObject:spriteNode];
    else if ( [spriteNode class] == [Electricity class] )
        [self.cachedElectricity removeObject:spriteNode];
    else if ( [spriteNode class] == [Laser class] )
        [self.cachedLasers removeObject:spriteNode];
    
}

#pragma player weapon delegate
- (void) didAddProjectile:(SKSpriteNode *)projectile forWeapon:(PlayerWeapon *)weapon
{
    if ( [projectile class] == [Electricity class] )
    {
        [self.cachedElectricity addObject:projectile];
        self.electricityFired++;
    }
    else if ( [projectile class] == [Laser class] )
    {
        [self.cachedLasers addObject:projectile];
        self.lasersFired++;
    }
}

#pragma mark SASpriteNode delegate
- (void) SASpriteNodeRemovingFromParent:(SASpriteNode *)node
{
    [self removeCachedSpriteNode:node];
}

@end
