//
//  AudioManager.m
//  SpaceAttack
//
//  Created by charles johnston on 6/11/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "AudioManager.h"
#import "AccountManager.h"

@implementation AudioManager

static AudioManager * sharedAudioManager = nil;
+ (AudioManager *)sharedInstance
{
    if ( sharedAudioManager == nil )
    {
        sharedAudioManager = [[AudioManager alloc] init];
        sharedAudioManager->_musicVolume = [AccountManager musicVolume]; //setter is overridden
        sharedAudioManager->_soundEffectsVolume = [AccountManager soundEffectsVolume]; //setter is overridden
        
        sharedAudioManager.timeSinceLastSoundEffect = [[NSDate date] timeIntervalSince1970];
        sharedAudioManager.currentSounds = [NSMutableArray new];
        
        //gameplay songs
        NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"somewhere" ofType:@"mp3"]];
        NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"81s" ofType:@"mp3"]];
        NSURL *url3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"escape" ofType:@"mp3"]];
        NSURL *url4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"80s" ofType:@"mp3"]];
        sharedAudioManager.gameplayTrackUrls = @[url1, url2, url3, url4];
        
        //menu songs
        NSURL * url5 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Main-Title" ofType:@"mp3"]];
        sharedAudioManager.menuTrackUrls = @[url5];
        
        //sound effects
        //tooltip
        //machine gun
        sharedAudioManager.machineGunSources = [NSMutableDictionary new];

        //weapons
        NSArray * bulletFileNames = @[@"bullet1", @"bullet2", @"bullet3", @"bullet4"];
        NSArray * bulletPlayers = [sharedAudioManager createAudioBuffers:bulletFileNames];
        
        NSArray * electricityFileNames = @[@"electricity1", @"electricity2", @"electricity3", @"electricity4", @"electricity5", @"electricity6"];
        NSArray * electricityPlayers = [sharedAudioManager createAudioBuffers:electricityFileNames];
        
        NSArray * photonFileNames = @[@"photon1", @"photon2", @"photon3", @"photon4", @"photon5"];
        NSArray * photonPlayers = [sharedAudioManager createAudioBuffers:photonFileNames];
        
        NSArray * laserFileNames = @[@"laser1", @"laser2", @"laser3", @"laser4"];
        NSArray * laserPlayers = [sharedAudioManager createAudioBuffers:laserFileNames];
        
        sharedAudioManager.weaponSounds = @{@"bulletSounds": bulletPlayers,
                                            @"electricitySounds" : electricityPlayers,
                                            @"photonSounds" : photonPlayers,
                                            @"laserSounds" : laserPlayers};
        
        //photon explosion
        
        //enemy explosions
        NSArray * basicExplosionPlayers = [sharedAudioManager createAudioBuffers:@[@"basic"]];
        NSArray * fastExplosionPlayers = [sharedAudioManager createAudioBuffers:@[@"fast"]];
        NSArray * bigExplosionPlayers = [sharedAudioManager createAudioBuffers:@[@"big"]];
        
        sharedAudioManager.enemyExplosionSounds = @{@"basic" : basicExplosionPlayers,
                                                    @"fast" : fastExplosionPlayers,
                                                    @"big" : bigExplosionPlayers};
        
        //spaceship explosion
        
        //asteroid crumbling
        NSArray * asteroidCrumblingFileNames = @[@"asteroid1", @"asteroid2", @"asteroid3", @"asteroid4", @"asteroid5"];
        sharedAudioManager.asteroidCrumblingSounds = [sharedAudioManager createAudioBuffers:asteroidCrumblingFileNames];
        
        //shield
        NSArray * shieldDamageFileNames = @[@"shieldDamage1", @"shieldDamage2", @"shieldDamage3", @"shieldDamage4"];
        sharedAudioManager.shieldDamage = [sharedAudioManager createAudioBuffers:shieldDamageFileNames];
        
        NSArray * shieldExplosionFileNames = @[@"shieldDestroy1", @"shieldDestroy2", @"shieldDestroy3"];
        sharedAudioManager.shieldExplosions = [sharedAudioManager createAudioBuffers:shieldExplosionFileNames];
        
        //equip weapons
        
        //enemy damage
        NSArray * enemyDamageFileNames = @[@"enemyDamage1", @"enemyDamage2", @"enemyDamage3", @"enemyDamage4", @"enemyDamage5"];
        sharedAudioManager.enemyDamageSounds = [sharedAudioManager createAudioBuffers:enemyDamageFileNames];
        
        //spaceship damage
        NSArray * spaceshipDamageFileNames = @[@"spaceshipDamage1", @"spaceshipDamage2", @"spaceshipDamage3", @"spaceshipDamage4", @"spaceshipDamage5"];
        sharedAudioManager.spaceshipDamage = [sharedAudioManager createAudioBuffers:spaceshipDamageFileNames];
        
        //multiplier lost
        
        
    }
    
    return sharedAudioManager;
}

- (void) vibrate
{
    if ( [AccountManager isVibrateOn] )
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

#pragma mark - settings
- (void) setMusicVolume:(float)volume
{
    [AccountManager setMusicVolume:volume];
    _musicVolume = volume;
    
    if ( self.menuMusicPlayer )
        self.menuMusicPlayer.volume = volume;
}

- (void) setSoundEffectsVolume:(float)volume
{
    [AccountManager setSoundEffectsVolume:volume];
    _soundEffectsVolume = volume;
}

#pragma mark - music
- (void) playMenuMusic
{
#if (TARGET_IPHONE_SIMULATOR) //simulator sucks at sounds
    return;
#endif
    
    NSURL * trackUrl = [self.menuTrackUrls objectAtIndex:arc4random_uniform((int)self.menuTrackUrls.count)];
    self.menuMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:trackUrl fileTypeHint:@"AVFileTypeWAVE" error:NULL];
    self.menuMusicPlayer.delegate = self;
    self.menuMusicPlayer.volume = self.musicVolume;
    [self.menuMusicPlayer play];
}

- (void) playGameplayMusic
{
#if (TARGET_IPHONE_SIMULATOR) //simulator sucks at sounds
    return;
#endif
    
    NSURL * trackUrl = [self.gameplayTrackUrls objectAtIndex:arc4random_uniform((int)self.gameplayTrackUrls.count)];
    self.gameplayMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:trackUrl fileTypeHint:@"AVFileTypeMPEGLayer3" error:NULL];
    self.gameplayMusicPlayer.delegate = self;
    self.gameplayMusicPlayer.volume = self.musicVolume;
    [self.gameplayMusicPlayer play];
}

-(void)fadeOutMenuMusic
{
    if (self.menuMusicPlayer.volume > 0.05)
    {
        self.menuMusicPlayer.volume = self.menuMusicPlayer.volume - 0.05;
        [self performSelector:@selector(fadeOutMenuMusic) withObject:nil afterDelay:0.075];
    }
    else
        [self.menuMusicPlayer stop];
}

-(void)fadeOutGameplayMusic
{
    if (self.gameplayMusicPlayer.volume > 0.05)
    {
        self.gameplayMusicPlayer.volume = self.gameplayMusicPlayer.volume - 0.05;
        [self performSelector:@selector(fadeOutGameplayMusic) withObject:nil afterDelay:0.075];
    }
    else
        [self.gameplayMusicPlayer stop];
}

#pragma mark AVAudioPlayerDelegate
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ( player == self.menuMusicPlayer )
        [self performSelector:@selector(playMenuMusic) withObject:nil afterDelay:.5];
    else if ( player == self.gameplayMusicPlayer)
        [self playGameplayMusic];
}

#pragma mark - sound effects
- (NSMutableArray *) createAudioBuffers:(NSArray *)fileNames
{
    NSMutableArray * audioBuffers = [NSMutableArray new];
    for ( NSString * fileName in fileNames )
    {
        NSString * audioPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    }
    return audioBuffers;
}


- (void) playSoundEffect:(SoundEffect)soundEffect
{
#if (TARGET_IPHONE_SIMULATOR) //simulator sucks at sounds
    return;
#endif
    
    if ( self.soundEffectsVolume == 0 )
        return;
  
    if ( self.currentSounds.count > 10 )
        return;
    
    
    switch (soundEffect)
    {
            //--gameplay
        case kSoundEffectElectricity:
        {
            NSArray * electricitySounds = [self.weaponSounds objectForKey:@"electricitySounds"];
            break;
        }
            
        case kSoundEffectBullet:
        {
            NSMutableArray * bulletSounds = [self.weaponSounds objectForKey:@"bulletSounds"];
            break;
        }
            
        case kSoundEffectLaser:
        {
            NSArray * laserSounds = [self.weaponSounds objectForKey:@"laserSounds"];
            break;
        }
            
        case kSoundEffectPhoton:
        {
            NSArray * photonSounds = [self.weaponSounds objectForKey:@"photonSounds"];
            break;
        }
            
        case kSoundEffectExplosionEnemyBasic:
        {
            NSArray * basicExplosionSounds = [self.enemyExplosionSounds objectForKey:@"basic"];
            break;
        }
            
        case kSoundEffectExplosionEnemyFast:
        {
            NSArray * fastExplosionSounds = [self.enemyExplosionSounds objectForKey:@"fast"];
            break;
        }
            
        case kSoundEffectExplosionEnemyBig:
        {
            NSArray * bigExplosionSounds = [self.enemyExplosionSounds objectForKey:@"big"];
            break;
        }
            
        case kSoundEffectExplosionSpaceship:
            break;
            
        case kSoundEffectAsteroidCrumble:
        {
            NSArray * crumbleSounds = self.asteroidCrumblingSounds;
            break;
        }
            
        case kSoundEffectShieldDestroy:
        {
            NSArray * shieldExplosions = self.shieldExplosions;
            break;
        }
            
        case kSoundEffectShieldEquip:
            break;
            
        case kSoundEffectEnergyBoosterStart:
            break;
            
        case kSoundEffectEnergyBoosterEnd:
            break;
            
        case kSoundEffectEquipMachineGun:
            break;
            
        case kSoundEffectEquipLaserCannon:
            break;
            
        case kSoundEffectEquipPhotonCannon:
            break;
            
        case kSoundEffectEquipElectricalGenerator:
            break;
            
        case kSoundEffectEnemyDamage:
        {
            NSArray * enemyDamageSouns = self.enemyDamageSounds;
            break;
        }
            
        case kSoundEffectSpaceshipDamage:
        {
            NSArray * spaceshipDamageSounds = self.spaceshipDamage;
            break;
        }
            
        case kSoundEffectShieldDamage:
        {
            NSArray * shieldDamageSounds = self.shieldDamage;
            break;
        }
            
        case kSoundEffectMultiplierIncrease:
            break;
            
        case kSoundEffectMultiplierLost:
            break;
            
        case kSoundEffectToolTip:
            break;
            
        case kSoundEffectPhotonExplosion:
            break;
            
            //--menu
        case kSoundEffectMenuUnlock:
            break;
            
        case kSoundEffectMenuSettings:
            break;
            
        case kSoundEffectMenuUpgradeMinimize:
            break;
            
        case kSoundEffectMenuUpgradeMaximize:
            break;
            
        case kSoundEffectMenuBackButton:
            break;
            
        case kSoundEffectMenuHighScoreAchievements:
            break;
            
        case kSoundEffectMenuUpgrade:
            break;
            
        case kSoundEffectMenuEngage:
            break;
            
        case kSoundEffectMenuDidUnlock:
            break;
            
        case kSoundEffectMenuSelectShip:
            break;
        
        case kSoundEffectMinimizeCell:
            break;
            
        case kSoundEffectMaximizeCell:
            break;
            
        case kSoundEffectMenuPageTurn:
            break;
            
        default:
            return;
    }
    
    if ( false )
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            if ( false ) // STR - play game, hold down the home button, press home button again
            {
                //[self.currentSounds performSelector:@selector(removeObject:) withObject:soundSource afterDelay:audioBuffer.duration];
                
            }
            
        });
    }
}

#pragma mark - machine gun
- (NSValue *) dictionaryKeyForMachineGun:(MachineGun *)machineGun
{
    return [NSValue valueWithNonretainedObject:machineGun];
}

- (void) machineGunLevelChanged:(MachineGun *)machineGun
{
    //this is used for levels 3 and 4 of the machine gun
    //levels 1 and 2 should still call [playSoundEffect:]
    if ( machineGun.level == 1 || machineGun.level == 2 )
        return;
    
    
    if ( false )
    {
        if ( machineGun.level == 3 )
        {
            if ( machineGun.fireRateUpgraded )
                ;
            else
                ;
            
        }
        else
            NSLog(@"machineGunLevelChanged - something went wrong");
    }
    else
    {
        
        if ( machineGun.fireRateUpgraded )
            ;
        else
            ;
        
        if ( machineGun.level == 4 )
            ;
        else
            NSLog(@"machineGunLevelChanged - something went wrong");
    }
}

- (void) pauseMachineGuns:(BOOL)pause
{
    for ( NSValue * key in [self.machineGunSources allKeys] )
    {
        if ( pause )
            ;
        else
            ;
    }
}

- (void) removeMachineGun:(MachineGun *)machineGun
{
}

@end
