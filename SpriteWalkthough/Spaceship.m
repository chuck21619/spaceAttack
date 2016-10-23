//
//  Spaceship.m
//  SpriteWalkthough
//
//  Created by chuck on 4/2/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Spaceship.h"
#import "Missile.h"
#import "CategoryBitMasks.h"
#import "AccountManager.h"
#import "AudioManager.h"
#import "SpaceshipScene.h"

@implementation Spaceship
{
    NSArray * _explosionFrames;
}

- (id)init
{
    if (self = [super init])
    {
        self.name = @"spaceship";
        self.zPosition = 1;
        self.energyBoosterActive = NO;
        self.equippedWeapons = [[NSMutableDictionary alloc] init];
        _explosionFrames = [[SpaceshipKit sharedInstance] explosionFrames];
        NSDate * bogusDate = [[NSDate date] dateByAddingTimeInterval:5000]; // this date will never get fired
        self.energyBoosterTimer = [[NSTimer alloc] initWithFireDate:bogusDate interval:0 target:self selector:@selector(endEnergyBooster:) userInfo:nil repeats:NO];
        [self setNumberOfWeaponSlots:[AccountManager numberOfWeaponSlotsUnlocked]];
        self.pulseRed = [SKAction sequence:@[[SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:1.0 duration:0.15],
                                                   [SKAction waitForDuration:0.1],
                                                   [SKAction colorizeWithColorBlendFactor:0.0 duration:0.15]]];
        self.isValidForMoneyPurchase = NO;
	}
    return self;
}

- (void) setNumberOfWeaponSlots:(int)numberOfWeaponSlots
{
    // example //    @{ @"weaponSlotNumber" : @[weaponSlotCoord, zPosition, slotLevel]};
    
    switch ( numberOfWeaponSlots )
    {
        case 1:
            self.weaponSlotPositions = @{ @"weaponSlot1" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:-1], [NSNumber numberWithInteger:1]]]};
            break;
            
        case 2:
            self.weaponSlotPositions = @{ @"weaponSlot1" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:-1], [NSNumber numberWithInteger:1]]],
                                          @"weaponSlot2" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:2], [NSNumber numberWithInteger:1]]]};
            break;
            
        case 4:
            self.weaponSlotPositions = @{ @"weaponSlot1" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:-1], [NSNumber numberWithInteger:1]]],
                                          @"weaponSlot2" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:2], [NSNumber numberWithInteger:1]]],
                                          @"weaponSlot3" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:-1], [NSNumber numberWithInteger:1]]],
                                          @"weaponSlot4" : [NSMutableArray arrayWithArray:@[[NSValue valueWithCGPoint:CGPointMake(0, self.size.height/2)], [NSNumber numberWithInt:-1], [NSNumber numberWithInteger:1]]]};
            break;
            
        default:
            self.weaponSlotPositions = @{};
    }
}

- (BOOL) isUnlocked
{
    return [AccountManager shipIsUnlocked:self];
}

- (void) takeDamage
{
    self.armor--;
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectSpaceshipDamage];
    [self.delegate spaceshipTookDamage:self];
    
    if ( self.armor <= 0 )
        [self explode];
    else
        [self runAction:self.pulseRed];
}

- (void) explode
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectExplosionSpaceship];
    [[AudioManager sharedInstance] vibrate];
    
//    NSString * explosionPath = [[NSBundle mainBundle] pathForResource:@"spaceshipExplosion" ofType:@"sks"];
//    SKEmitterNode * explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
//    explosion.name = @"explosion";
//    explosion.position = self.position;
    EnemyExplosion * explosion = [[EnemyExplosion alloc] initWithAtlas:_explosionFrames size:self.size.width*5];
    explosion.position = self.position;
    [[self scene] addChild:explosion];
    
    [self.energyBoosterTimer invalidate];
    self.energyBoosterTimer = nil;
    [self stopFiring];
    [self.equippedWeapons removeAllObjects];
    for ( SKSpriteNode * node in [self children] )
         [node removeFromParent];
    //[self removeAllChildren];
    [self.delegate spaceshipExploded:self];
    self.delegate = nil;
    [self removeFromParent];
    //[self removeAllActions];
}

- (void) stopFiring
{
    for ( NSString * key in [self.equippedWeapons allKeys] )
    {
        PlayerWeapon * weapon = [self.equippedWeapons objectForKey:key];
        [weapon stopFiring];
    }
}

- (void) powerUpCollected:(PowerUpType)powerUp
{
    if ( [EnumTypes isWeaponPowerUp:powerUp] )
    {
        BOOL matchesExistingWeapon = NO;
        BOOL allWeaponsAreTheSame = YES;
        
        PowerUpType tmpWeaponType = -1;
        if ( self.equippedWeapons.count )
            tmpWeaponType = [(PlayerWeapon *)[self.equippedWeapons valueForKey:[self.equippedWeapons.allKeys firstObject]] weaponType];
        
        for ( int i = 0; i < self.equippedWeapons.count; i++ )
        {
            NSString * tmpWeaponKey = [self.equippedWeapons.allKeys objectAtIndex:i];
            PlayerWeapon * tmpWeapon = [self.equippedWeapons valueForKey:tmpWeaponKey];
            
            if ( tmpWeapon.weaponType != tmpWeaponType )
                allWeaponsAreTheSame = NO;
            tmpWeaponType = tmpWeapon.weaponType;
            
            if ( (tmpWeapon.weaponType == kPowerUpTypeMachineGun && powerUp == kPowerUpTypeMachineGun) ||
                 (tmpWeapon.weaponType == kPowerUpTypePhotonCannon && powerUp == kPowerUpTypePhotonCannon) ||
                 (tmpWeapon.weaponType == kPowerUpTypeElectricalGenerator && powerUp == kPowerUpTypeElectricalGenerator) ||
                 (tmpWeapon.weaponType == kPowerUpTypeLaserCannon && powerUp == kPowerUpTypeLaserCannon) )
            {
                if ( tmpWeapon.level == 4 )
                    return;
                
                [tmpWeapon upgrade];
                int weaponSlotLevel = [[[self.weaponSlotPositions valueForKey:tmpWeaponKey] objectAtIndex:2] intValue];
                [[self.weaponSlotPositions valueForKey:tmpWeaponKey] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:++weaponSlotLevel]];
                matchesExistingWeapon = YES;
                break;
            }
        }
        
        if ( self.equippedWeapons.count < self.weaponSlotPositions.count )
            allWeaponsAreTheSame = NO;
        
        if ( ! matchesExistingWeapon )
        {
            if ( ! allWeaponsAreTheSame || powerUp != tmpWeaponType )
            {
                if ( self.equippedWeapons.count >= self.weaponSlotPositions.count)
                    [self removeWeakestWeaponThatIsNotThisType:powerUp];
                
                [self equipWeapon:powerUp];
                [self adjustTextureForEquippedWeapons];
            }
        }
    }
    else if ( powerUp == kPowerUpTypeShield )
    {
        if ( self.equippedShield )
        {
            if ( self.equippedShield.armor == 3 )
                return;
            
            __block Shield * oldShield = self.equippedShield;
            [oldShield runAction:[SKAction fadeAlphaTo:0 duration:.2] completion:^
            {
                [oldShield removeFromParent];
                oldShield = nil;
            }];
        }
        
        [self equipShield];
    }
    else if ( powerUp == kPowerUpTypeEnergyBooster )
        [self startEnergyBooster];
}

- (void) equipShield
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectShieldEquip];
    Shield * shield = [Shield new];
    shield.position = CGPointMake(0, 0);
    self.equippedShield = shield;
    [self addChild:shield];
}

- (void) startEnergyBooster
{
    BOOL oldEnergyBoosterActive = self.energyBoosterActive;
    self.energyBoosterActive = YES;
    
    if ( ! oldEnergyBoosterActive )
        self.damage *= 2;
    
    SKAction * pulseGreen = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction colorizeWithColor:[SKColor greenColor] colorBlendFactor:1.0 duration:0.2],
                                                                               [SKAction waitForDuration:0.1],
                                                                               [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2],
                                                                               [SKAction colorizeWithColor:[SKColor yellowColor] colorBlendFactor:1.0 duration:0.2],
                                                                               [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2],
                                                                               [SKAction colorizeWithColor:[SKColor orangeColor] colorBlendFactor:1.0 duration:0.2],
                                                                               [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2]]]];
    [self runAction:pulseGreen withKey:@"pulseGreen"];
    
    NSDate * currentDate = [NSDate date];
    [self.energyBoosterTimer invalidate];
    self.energyBoosterTimer = [[NSTimer alloc] initWithFireDate:[currentDate dateByAddingTimeInterval:30] interval:0 target:self selector:@selector(endEnergyBooster:) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.energyBoosterTimer forMode:NSDefaultRunLoopMode];
    
    if ( !oldEnergyBoosterActive )
    {
        [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEnergyBoosterStart];
        [self.delegate energyBoosterChanged:self];
    }
}

- (void) endEnergyBooster:(NSTimer *)timer
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEnergyBoosterEnd];
    
    self.damage /= 2;
    [self removeActionForKey:@"pulseGreen"];
    self.energyBoosterActive = NO;

    [self.delegate energyBoosterChanged:self];
    
    //remove the green colory shiz
    [self runAction:[SKAction colorizeWithColorBlendFactor:0.0 duration:0.2]];
}

- (void) increaseExhaustSpeed
{
    [self enumerateChildNodesWithName:@"exhaust" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
    {
        SKEmitterNode * exhaust = (SKEmitterNode *)node;
        exhaust.particleSpeed += 5;
    }];
}

- (float) healthPercentage
{
    return 1;
}

#pragma mark - equip weapon
- (void) equipWeapon:(PowerUpType)weaponType
{
    self.damage = self.defaultDamage * (1 - (.1*self.equippedWeapons.count));
    
    PlayerWeapon * newWeapon;
    switch (weaponType)
    {
        case kPowerUpTypeMachineGun:
            newWeapon = [[MachineGun alloc] init];
            [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEquipMachineGun];
            break;
            
        case kPowerUpTypePhotonCannon:
            newWeapon = [[PhotonCannon alloc] init];
            [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEquipPhotonCannon];
            break;
            
        case kPowerUpTypeElectricalGenerator:
            newWeapon = [[ElectricalGenerator alloc] init];
            [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEquipElectricalGenerator];
            break;
            
        case kPowerUpTypeLaserCannon:
            newWeapon = [[LaserCannon alloc] init];
            [[AudioManager sharedInstance] playSoundEffect:kSoundEffectEquipLaserCannon];
            break;
            
        default:
            break;
    }
    
    NSString * weaponSlotKey = [self lowestWeaponSlotThatsEmpty];
    newWeapon.zPosition = [[[self.weaponSlotPositions valueForKey:weaponSlotKey] objectAtIndex:1] intValue];
    [self.equippedWeapons setValue:newWeapon forKey:weaponSlotKey];
    newWeapon.position = [[[self.weaponSlotPositions valueForKey:weaponSlotKey] firstObject] CGPointValue];
    
    int weaponSlotLevel = [[[self.weaponSlotPositions valueForKey:weaponSlotKey] objectAtIndex:2] intValue];
    if ( newWeapon.level > weaponSlotLevel ) //this is when the machine gun is higher level from the upgrade
        [[self.weaponSlotPositions valueForKey:weaponSlotKey] replaceObjectAtIndex:2 withObject:[NSNumber numberWithInt:newWeapon.level]];
    else
        newWeapon.level = weaponSlotLevel;
    
    newWeapon.alpha = 0;
    [self addChild:newWeapon];
    [newWeapon startFiring];
    newWeapon.delegate = (SpaceshipScene *)[self scene];
    [newWeapon runAction:[SKAction fadeInWithDuration:.2] completion:^
    {
        [self.delegate spaceshipEquippedWeapon:newWeapon];
    }];
}

- (NSString *) lowestWeaponSlotThatsEmpty
{
    NSString * lowestWeaponSlotKey;
    for ( int i = 0; i < self.weaponSlotPositions.count; i++ )
    {
        lowestWeaponSlotKey = [NSString stringWithFormat:@"weaponSlot%i", i+1];
        if ( ! [self.equippedWeapons valueForKey:lowestWeaponSlotKey] )
            break;
    }
    
    return lowestWeaponSlotKey;
}

- (void) removeWeakestWeaponThatIsNotThisType:(PowerUpType)weaponType
{
    if ( self.equippedWeapons.count == 0 )
        return;
    
    NSArray * weaponSlotKeys = self.equippedWeapons.allKeys;
    
    PlayerWeapon * weakestWeapon = [self.equippedWeapons valueForKey:[weaponSlotKeys firstObject]];
    for ( NSString * weaponSlotkey in self.equippedWeapons )
    {
        weakestWeapon = [self.equippedWeapons valueForKey:weaponSlotkey];
        if ( weakestWeapon.weaponType != weaponType )
            break;
    }
    
    for ( NSString * weaponSlotkey in self.equippedWeapons )
    {
        PlayerWeapon * tmpPlayerWeapon = [self.equippedWeapons valueForKey:weaponSlotkey];
        if ( tmpPlayerWeapon.level < weakestWeapon.level && tmpPlayerWeapon.weaponType != weaponType )
            weakestWeapon = tmpPlayerWeapon;
    }
    
    [weakestWeapon stopFiring];
    NSString * weakestWeaponKey = [[self.equippedWeapons allKeysForObject:weakestWeapon] firstObject];
    [self.equippedWeapons removeObjectForKey:weakestWeaponKey];
    
    [weakestWeapon runAction:[SKAction fadeAlphaTo:0 duration:.2] completion:^
    {
        [weakestWeapon removeFromParent];
    }];
}

- (void) adjustTextureForEquippedWeapons
{
    BOOL machineGun = NO;
    BOOL photonCannon = NO;
    BOOL electricalGenerator = NO;
    BOOL laserCannon = NO;
    
    for ( NSString * weaponSlotkey in self.equippedWeapons.allKeys )
    {
        PlayerWeapon * tmpWeapon = [self.equippedWeapons valueForKey:weaponSlotkey];
        
        switch ( tmpWeapon.weaponType )
        {
            case kPowerUpTypeMachineGun:
                machineGun = YES;
                break;
                
            case kPowerUpTypePhotonCannon:
                photonCannon = YES;
                break;
                
            case kPowerUpTypeElectricalGenerator:
                electricalGenerator = YES;
                break;
                
            case kPowerUpTypeLaserCannon:
                laserCannon = YES;
                break;
                
            default:
                break;
        }
    }
    
    NSString * newTextureKey;
    if ( machineGun )
    {
        if ( photonCannon )
            newTextureKey = @"BulPho";
        else if ( electricalGenerator )
            newTextureKey = @"BulEle";
        else if ( laserCannon )
            newTextureKey = @"BulLaz";
        else
            newTextureKey = @"Bul";
    }
    else if ( photonCannon )
    {
        if ( electricalGenerator )
            newTextureKey = @"PhoEle";
        else if ( laserCannon )
            newTextureKey = @"PhoLaz";
        else
            newTextureKey = @"Pho";
    }
    else if ( electricalGenerator )
    {
        if ( laserCannon )
            newTextureKey = @"LazEle";
        else
            newTextureKey = @"Ele";
    }
    else if ( laserCannon )
    {
        newTextureKey = @"Laz";
    }
    
    self.texture = [[[[SpaceshipKit sharedInstance] shipTextures] objectForKey:NSStringFromClass([self class])] objectForKey:newTextureKey];
}

#pragma mark - debug
- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:0 blue:0 alpha:0.5];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

- (void) setExhaustTargetNode:(SKNode *)node
{
    [self enumerateChildNodesWithName:@"exhaust" usingBlock:^(SKNode * _Nonnull exhaust, BOOL * _Nonnull stop)
    {
        SKEmitterNode * tmpExhaust = (SKEmitterNode *)exhaust;
        tmpExhaust.targetNode = node;
    }];
}

@end
