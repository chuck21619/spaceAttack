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
        
        sharedAudioManager.device = [ALDevice deviceWithDeviceSpecifier:nil];
        sharedAudioManager.context = [ALContext contextOnDevice:sharedAudioManager.device attributes:nil];
        [OpenALManager sharedInstance].currentContext = sharedAudioManager.context;
        [OALAudioSession sharedInstance].handleInterruptions = YES;
        [OALAudioSession sharedInstance].allowIpod = NO;
        [OALAudioSession sharedInstance].honorSilentSwitch = YES;
        sharedAudioManager.channel = [ALChannelSource channelWithSources:32];
        sharedAudioManager.channel.gain = sharedAudioManager.soundEffectsVolume;
        sharedAudioManager.timeSinceLastSoundEffect = [[NSDate date] timeIntervalSince1970];
        sharedAudioManager.currentSounds = [NSMutableArray new];
        
        //gameplay songs
        NSURL *url1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"UnknownPlanet" ofType:@"mp3"]];
        NSURL *url2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SpaceTrip" ofType:@"mp3"]];
        NSURL *url3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SpaceTravel" ofType:@"mp3"]];
        NSURL *url4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TimePortal" ofType:@"mp3"]];
        NSURL *url5 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Mercury" ofType:@"mp3"]];
        NSURL *url6 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Kalliope" ofType:@"mp3"]];
        sharedAudioManager.gameplayTrackUrls = @[url1, url2, url3, url4, url5, url6];
        
        //menu songs
        NSURL * url7 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"StarMasterLoop" ofType:@"wav"]];
        NSURL * url8 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"SpaceCube" ofType:@"wav"]];
        NSURL * url9 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CosmicMessages" ofType:@"wav"]];
        NSURL * url10 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Starlight" ofType:@"wav"]];
        sharedAudioManager.menuTrackUrls = @[url7, url8, url9, url10];
        
        //sound effects
        //tooltip
        sharedAudioManager.tooltip = [[sharedAudioManager createAudioBuffers:@[@"tooltip"]] firstObject];
        
        //machine gun
        sharedAudioManager.machineGunSources = [NSMutableDictionary new];
        sharedAudioManager.machineGunLevel3Buffer = [[sharedAudioManager createAudioBuffers:@[@"machineGunLevel3"]] firstObject];
        sharedAudioManager.machineGunLevel4Buffer = [[sharedAudioManager createAudioBuffers:@[@"machineGunLevel4"]] firstObject];
        sharedAudioManager.machineGunLevel3UpgradedBuffer = [[sharedAudioManager createAudioBuffers:@[@"machineGunLevel3Upgraded"]] firstObject];
        sharedAudioManager.machineGunLevel4UpgradedBuffer = [[sharedAudioManager createAudioBuffers:@[@"machineGunLevel4Upgraded"]] firstObject];

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
        sharedAudioManager.photonExplosion = [[sharedAudioManager createAudioBuffers:@[@"photonExplosion"]] firstObject];
        
        //enemy explosions
        NSArray * basicExplosionPlayers = [sharedAudioManager createAudioBuffers:@[@"basic"]];
        NSArray * fastExplosionPlayers = [sharedAudioManager createAudioBuffers:@[@"fast"]];
        NSArray * bigExplosionPlayers = [sharedAudioManager createAudioBuffers:@[@"big"]];
        
        sharedAudioManager.enemyExplosionSounds = @{@"basic" : basicExplosionPlayers,
                                                    @"fast" : fastExplosionPlayers,
                                                    @"big" : bigExplosionPlayers};
        
        //spaceship explosion
        sharedAudioManager.spaceshipExplosionSound = [[sharedAudioManager createAudioBuffers:@[@"spaceshipExplosion"]] firstObject];
        
        //asteroid crumbling
        NSArray * asteroidCrumblingFileNames = @[@"asteroid1", @"asteroid2", @"asteroid3", @"asteroid4", @"asteroid5"];
        sharedAudioManager.asteroidCrumblingSounds = [sharedAudioManager createAudioBuffers:asteroidCrumblingFileNames];
        
        //shield
        NSArray * shieldDamageFileNames = @[@"shieldDamage1", @"shieldDamage2", @"shieldDamage3", @"shieldDamage4"];
        sharedAudioManager.shieldDamage = [sharedAudioManager createAudioBuffers:shieldDamageFileNames];
        
        NSArray * shieldExplosionFileNames = @[@"shieldDestroy1", @"shieldDestroy2", @"shieldDestroy3"];
        sharedAudioManager.shieldExplosions = [sharedAudioManager createAudioBuffers:shieldExplosionFileNames];
        
        sharedAudioManager.shieldEquip = [[sharedAudioManager createAudioBuffers:@[@"shieldEquip"]] firstObject];
        
        //energy booster
        sharedAudioManager.energyBoosterStart = [[sharedAudioManager createAudioBuffers:@[@"energyBoosterStart"]] firstObject];
        sharedAudioManager.energyBoosterEnd = [[sharedAudioManager createAudioBuffers:@[@"energyBoosterEnd"]] firstObject];
        
        //equip weapons
        sharedAudioManager.equipMachineGun = [[sharedAudioManager createAudioBuffers:@[@"machineGunEquip"]] firstObject];
        sharedAudioManager.equipLaserCannon = [[sharedAudioManager createAudioBuffers:@[@"laserCannonEquip"]] firstObject];
        sharedAudioManager.equipElectricalGenerator = [[sharedAudioManager createAudioBuffers:@[@"electricalGeneratorEquip"]] firstObject];
        sharedAudioManager.equipPhotonCannon = [[sharedAudioManager createAudioBuffers:@[@"photonCannonEquip"]] firstObject];
        
        //enemy damage
        NSArray * enemyDamageFileNames = @[@"enemyDamage1", @"enemyDamage2", @"enemyDamage3", @"enemyDamage4", @"enemyDamage5"];
        sharedAudioManager.enemyDamageSounds = [sharedAudioManager createAudioBuffers:enemyDamageFileNames];
        
        //spaceship damage
        NSArray * spaceshipDamageFileNames = @[@"spaceshipDamage1", @"spaceshipDamage2", @"spaceshipDamage3", @"spaceshipDamage4", @"spaceshipDamage5"];
        sharedAudioManager.spaceshipDamage = [sharedAudioManager createAudioBuffers:spaceshipDamageFileNames];
        
        //multiplier lost
        sharedAudioManager.multiplierLost = [[sharedAudioManager createAudioBuffers:@[@"lostMultiplier"]] firstObject];
        sharedAudioManager.multiplierIncrease = [[sharedAudioManager createAudioBuffers:@[@"increaseMultiplier"]] firstObject];
        
        //menu
        sharedAudioManager.unlock = [[sharedAudioManager createAudioBuffers:@[@"unlock"]] firstObject];
        sharedAudioManager.settings = [[sharedAudioManager createAudioBuffers:@[@"settings"]] firstObject];
        sharedAudioManager.upgradeMinimize = [[sharedAudioManager createAudioBuffers:@[@"upgradeMinimize"]] firstObject];
        sharedAudioManager.upgradeMaximize = [[sharedAudioManager createAudioBuffers:@[@"upgradeMaximize"]] firstObject];
        sharedAudioManager.backButton = [[sharedAudioManager createAudioBuffers:@[@"backButton"]] firstObject];
        sharedAudioManager.highScoreAchievements = [[sharedAudioManager createAudioBuffers:@[@"highScoreAchievements"]] firstObject];
        sharedAudioManager.upgrade = [[sharedAudioManager createAudioBuffers:@[@"upgrade"]] firstObject];
        sharedAudioManager.engage = [[sharedAudioManager createAudioBuffers:@[@"engage"]] firstObject];
        sharedAudioManager.didUnlock = [[sharedAudioManager createAudioBuffers:@[@"didUnlock"]] firstObject];
        sharedAudioManager.selectShip = [[sharedAudioManager createAudioBuffers:@[@"selectShip"]] firstObject];
        sharedAudioManager.minimizeCell = [[sharedAudioManager createAudioBuffers:@[@"minimizeCell"]] firstObject];
        sharedAudioManager.maximizeCell = [[sharedAudioManager createAudioBuffers:@[@"maximizeCell"]] firstObject];
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
    self.channel.volume = volume;
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
        ALBuffer * audioBuffer = [[OpenALManager sharedInstance] bufferFromFile:audioPath];
        [audioBuffers addObject:audioBuffer];
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
    
    ALBuffer * audioBuffer = nil;
    
    switch (soundEffect)
    {
            //--gameplay
        case kSoundEffectElectricity:
        {
            NSArray * electricitySounds = [self.weaponSounds objectForKey:@"electricitySounds"];
            audioBuffer = [electricitySounds objectAtIndex:arc4random_uniform((int)electricitySounds.count)];
            break;
        }
            
        case kSoundEffectBullet:
        {
            NSMutableArray * bulletSounds = [self.weaponSounds objectForKey:@"bulletSounds"];
            audioBuffer = [bulletSounds objectAtIndex:arc4random_uniform((int)bulletSounds.count)];
            break;
        }
            
        case kSoundEffectLaser:
        {
            NSArray * laserSounds = [self.weaponSounds objectForKey:@"laserSounds"];
            audioBuffer = [laserSounds objectAtIndex:arc4random_uniform((int)laserSounds.count)];
            break;
        }
            
        case kSoundEffectPhoton:
        {
            NSArray * photonSounds = [self.weaponSounds objectForKey:@"photonSounds"];
            audioBuffer = [photonSounds objectAtIndex:arc4random_uniform((int)photonSounds.count)];
            break;
        }
            
        case kSoundEffectExplosionEnemyBasic:
        {
            NSArray * basicExplosionSounds = [self.enemyExplosionSounds objectForKey:@"basic"];
            audioBuffer = [basicExplosionSounds objectAtIndex:arc4random_uniform((int)basicExplosionSounds.count)];
            break;
        }
            
        case kSoundEffectExplosionEnemyFast:
        {
            NSArray * fastExplosionSounds = [self.enemyExplosionSounds objectForKey:@"fast"];
            audioBuffer = [fastExplosionSounds objectAtIndex:arc4random_uniform((int)fastExplosionSounds.count)];
            break;
        }
            
        case kSoundEffectExplosionEnemyBig:
        {
            NSArray * bigExplosionSounds = [self.enemyExplosionSounds objectForKey:@"big"];
            audioBuffer = [bigExplosionSounds objectAtIndex:arc4random_uniform((int)bigExplosionSounds.count)];
            break;
        }
            
        case kSoundEffectExplosionSpaceship:
            audioBuffer = self.spaceshipExplosionSound;
            break;
            
        case kSoundEffectAsteroidCrumble:
        {
            NSArray * crumbleSounds = self.asteroidCrumblingSounds;
            audioBuffer = [crumbleSounds objectAtIndex:arc4random_uniform((int)crumbleSounds.count)];
            break;
        }
            
        case kSoundEffectShieldDestroy:
        {
            NSArray * shieldExplosions = self.shieldExplosions;
            audioBuffer = [shieldExplosions objectAtIndex:arc4random_uniform((int)shieldExplosions.count)];
            break;
        }
            
        case kSoundEffectShieldEquip:
            audioBuffer = self.shieldEquip;
            break;
            
        case kSoundEffectEnergyBoosterStart:
            audioBuffer = self.energyBoosterStart;
            break;
            
        case kSoundEffectEnergyBoosterEnd:
            audioBuffer = self.energyBoosterEnd;
            break;
            
        case kSoundEffectEquipMachineGun:
            audioBuffer = self.equipMachineGun;
            break;
            
        case kSoundEffectEquipLaserCannon:
            audioBuffer = self.equipLaserCannon;
            break;
            
        case kSoundEffectEquipPhotonCannon:
            audioBuffer = self.equipPhotonCannon;
            break;
            
        case kSoundEffectEquipElectricalGenerator:
            audioBuffer = self.equipElectricalGenerator;
            break;
            
        case kSoundEffectEnemyDamage:
        {
            NSArray * enemyDamageSouns = self.enemyDamageSounds;
            audioBuffer = [enemyDamageSouns objectAtIndex:arc4random_uniform((int)enemyDamageSouns.count)];
            break;
        }
            
        case kSoundEffectSpaceshipDamage:
        {
            NSArray * spaceshipDamageSounds = self.spaceshipDamage;
            audioBuffer = [spaceshipDamageSounds objectAtIndex:arc4random_uniform((int)spaceshipDamageSounds.count)];
            break;
        }
            
        case kSoundEffectShieldDamage:
        {
            NSArray * shieldDamageSounds = self.shieldDamage;
            audioBuffer = [shieldDamageSounds objectAtIndex:arc4random_uniform((int)shieldDamageSounds.count)];
            break;
        }
            
        case kSoundEffectMultiplierIncrease:
            audioBuffer = self.multiplierIncrease;
            break;
            
        case kSoundEffectMultiplierLost:
            audioBuffer = self.multiplierLost;
            break;
            
        case kSoundEffectToolTip:
            audioBuffer = self.tooltip;
            break;
            
        case kSoundEffectPhotonExplosion:
            audioBuffer = self.photonExplosion;
            break;
            
            //--menu
        case kSoundEffectMenuUnlock:
            audioBuffer = self.unlock;
            break;
            
        case kSoundEffectMenuSettings:
            audioBuffer = self.settings;
            break;
            
        case kSoundEffectMenuUpgradeMinimize:
            audioBuffer = self.upgradeMinimize;
            break;
            
        case kSoundEffectMenuUpgradeMaximize:
            audioBuffer = self.upgradeMaximize;
            break;
            
        case kSoundEffectMenuBackButton:
            audioBuffer = self.backButton;
            break;
            
        case kSoundEffectMenuHighScoreAchievements:
            audioBuffer = self.highScoreAchievements;
            break;
            
        case kSoundEffectMenuUpgrade:
            audioBuffer = self.upgrade;
            break;
            
        case kSoundEffectMenuEngage:
            audioBuffer = self.engage;
            break;
            
        case kSoundEffectMenuDidUnlock:
            audioBuffer = self.didUnlock;
            break;
            
        case kSoundEffectMenuSelectShip:
            audioBuffer = self.selectShip;
            break;
        
        case kSoundEffectMinimizeCell:
            audioBuffer = self.minimizeCell;
            break;
            
        case kSoundEffectMaximizeCell:
            audioBuffer = self.maximizeCell;
            break;
            
        default:
            return;
    }
    
    if ( audioBuffer )
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
        {
            ALSource * soundSource = (ALSource *)[self.channel play:audioBuffer];
            [self.currentSounds addObject:soundSource];
            //[self.currentSounds performSelector:@selector(removeObject:) withObject:soundSource afterDelay:audioBuffer.duration];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, audioBuffer.duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^
            {
                [self.currentSounds removeObject:soundSource];
            });
            
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
    
    ALBuffer * audioBuffer;
    
    ALSource * machineGunSource = [self.machineGunSources objectForKey:[self dictionaryKeyForMachineGun:machineGun]];
    if ( ! machineGunSource )
    {
        if ( machineGun.level == 3 )
        {
            if ( machineGun.fireRateUpgraded )
                audioBuffer = self.machineGunLevel3UpgradedBuffer;
            else
                audioBuffer = self.machineGunLevel3Buffer;
            
            machineGunSource = [[ALSource alloc] initOnContext:self.context];
            machineGunSource.volume = self.soundEffectsVolume;
            [machineGunSource play:audioBuffer loop:YES];
            [self.machineGunSources setObject:machineGunSource forKey:[self dictionaryKeyForMachineGun:machineGun]];
        }
        else
            NSLog(@"machineGunLevelChanged - something went wrong");
    }
    else
    {
        [machineGunSource stop];
        
        if ( machineGun.fireRateUpgraded )
            audioBuffer = self.machineGunLevel4UpgradedBuffer;
        else
            audioBuffer = self.machineGunLevel4Buffer;
        
        if ( machineGun.level == 4 )
            [machineGunSource play:audioBuffer loop:YES];
        else
            NSLog(@"machineGunLevelChanged - something went wrong");
    }
}

- (void) pauseMachineGuns:(BOOL)pause
{
    for ( NSValue * key in [self.machineGunSources allKeys] )
    {
        ALSource * machineGunSource = [self.machineGunSources objectForKey:key];
        if ( pause )
            machineGunSource.paused = YES;
        else
            machineGunSource.paused = NO;
    }
}

- (void) removeMachineGun:(MachineGun *)machineGun
{
    ALSource * machineGunSource = [self.machineGunSources objectForKey:[self dictionaryKeyForMachineGun:machineGun]];
    [machineGunSource stop];
}

@end
