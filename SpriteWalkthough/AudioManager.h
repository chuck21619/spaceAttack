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


// buffers (sounds)

@property (nonatomic) NSDictionary * weaponSounds;


@property (nonatomic) NSArray * enemyDamageSounds;
@property (nonatomic) NSDictionary * enemyExplosionSounds;

@property (nonatomic) NSArray * spaceshipDamage;

@property (nonatomic) NSArray * asteroidCrumblingSounds;

@property (nonatomic) NSArray * shieldExplosions;
@property (nonatomic) NSArray * shieldDamage;


//machine gun
- (void) machineGunLevelChanged:(MachineGun *)machineGun;
- (void) pauseMachineGuns:(BOOL)pause;
- (void) removeMachineGun:(MachineGun *)machineGun;
@property (nonatomic) NSMutableDictionary * machineGunSources;

//menu
@end
