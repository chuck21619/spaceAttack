//
//  AudioManager.h
//  SpaceAttack
//
//  Created by charles johnston on 6/11/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EnumTypes.h"
#import <SpriteKit/SpriteKit.h>
#import "ObjectAL.h"
#import "MachineGun.h"

@interface AudioManager : NSObject <AVAudioPlayerDelegate>

+ (AudioManager *) sharedInstance;

@property (nonatomic) float musicVolume;
@property (nonatomic) float soundEffectsVolume;
- (void) setMusicVolume:(float)volume;
- (void) setSoundEffectsVolume:(float)volume;

@property (nonatomic) SKScene * scene;
- (void) vibrate;

#pragma mark music
- (void) playGameplayMusic;
- (void) playMenuMusic;
- (void) fadeOutMenuMusic;
- (void) fadeOutGameplayMusic;
@property (nonatomic) AVAudioPlayer * menuMusicPlayer;
@property (nonatomic) AVAudioPlayer * gameplayMusicPlayer;
@property (nonatomic) NSArray * menuTrackUrls;
@property (nonatomic) NSArray * gameplayTrackUrls;

#pragma mark sound effects
- (void) playSoundEffect:(SoundEffect)soundEffect;
@property (nonatomic) NSTimeInterval timeSinceLastSoundEffect;
@property (nonatomic) NSMutableArray * currentSounds;

@property (nonatomic) ALDevice * device;
@property (nonatomic) ALContext * context;
@property (nonatomic) ALChannelSource * channel;

// buffers (sounds)
@property (nonatomic) ALBuffer * tooltip;

@property (nonatomic) NSDictionary * weaponSounds;

@property (nonatomic) ALBuffer * photonExplosion;

@property (nonatomic) NSArray * enemyDamageSounds;
@property (nonatomic) NSDictionary * enemyExplosionSounds;

@property (nonatomic) NSArray * spaceshipDamage;
@property (nonatomic) ALBuffer * spaceshipExplosionSound;

@property (nonatomic) NSArray * asteroidCrumblingSounds;

@property (nonatomic) NSArray * shieldExplosions;
@property (nonatomic) NSArray * shieldDamage;
@property (nonatomic) ALBuffer * shieldEquip;

@property (nonatomic) ALBuffer * energyBoosterStart;
@property (nonatomic) ALBuffer * energyBoosterEnd;

@property (nonatomic) ALBuffer * equipPhotonCannon;
@property (nonatomic) ALBuffer * equipLaserCannon;
@property (nonatomic) ALBuffer * equipElectricalGenerator;
@property (nonatomic) ALBuffer * equipMachineGun;

@property (nonatomic) ALBuffer * multiplierLost;
@property (nonatomic) ALBuffer * multiplierIncrease;

//machine gun
- (void) machineGunLevelChanged:(MachineGun *)machineGun;
- (void) pauseMachineGuns:(BOOL)pause;
- (void) removeMachineGun:(MachineGun *)machineGun;
@property (nonatomic) NSMutableDictionary * machineGunSources;
@property (nonatomic) ALBuffer * machineGunLevel3Buffer;
@property (nonatomic) ALBuffer * machineGunLevel4Buffer;
@property (nonatomic) ALBuffer * machineGunLevel3UpgradedBuffer;
@property (nonatomic) ALBuffer * machineGunLevel4UpgradedBuffer;

//menu
@property (nonatomic) ALBuffer * unlock;
@property (nonatomic) ALBuffer * settings;
@property (nonatomic) ALBuffer * upgradeMinimize;
@property (nonatomic) ALBuffer * upgradeMaximize;
@property (nonatomic) ALBuffer * backButton;
@property (nonatomic) ALBuffer * highScoreAchievements;
@property (nonatomic) ALBuffer * upgrade;
@property (nonatomic) ALBuffer * engage;
@property (nonatomic) ALBuffer * didUnlock;
@property (nonatomic) ALBuffer * selectShip;

@end
