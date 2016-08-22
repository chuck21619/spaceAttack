//
//  UpgradeScene.m
//  SpaceAttack
//
//  Created by charles johnston on 2/13/16.
//  Copyright © 2016 chuck. All rights reserved.
//

#import "UpgradeScene.h"
#import "PowerUp.h"
#import "AudioManager.h"

@implementation UpgradeScene

- (void) didMoveToView:(SKView *)view
{
    if ( !self.contentCreated )
    {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (instancetype) initWithUpgradeType:(UpgradeType)upgradeType
{
    if ( self = [super init] )
    {
        self.size = CGSizeMake(500, 500);
        self.scaleMode = SKSceneScaleModeAspectFill;
        self.anchorPoint = CGPointMake(0, .5);
        self.upgradeType = upgradeType;
    }
    return self;
}

- (void) createSceneContents
{
    self.backgroundColor = [SKColor blackColor];
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    self.mySpaceship = [[Abdul_Kadir alloc] init];
    [self.mySpaceship setExhaustTargetNode:self];
    self.mySpaceship.position = CGPointMake(self.size.width/2, self.size.height/4);
    [self addChild:self.mySpaceship];
    
    self.moveShipTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(randomlyMoveShip) userInfo:nil repeats:YES];
    
    NSString * cloudsPath = [[NSBundle mainBundle] pathForResource:@"Clouds" ofType:@"sks"];
    SKEmitterNode * clouds = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudsPath];
    clouds.name = @"cloudsEmitter";
    clouds.particleBirthRate = .07;
    clouds.position = CGPointMake(self.size.width/2, self.size.height+300);
    [self addChild:clouds];
    
    SKEmitterNode * cloudsOnTop = [NSKeyedUnarchiver unarchiveObjectWithFile:cloudsPath];
    cloudsOnTop.zPosition = 100;
    cloudsOnTop.particleBirthRate = .05;
    cloudsOnTop.name = @"cloudsOnTopEmitter";
    cloudsOnTop.position = CGPointMake(self.size.width/2, self.size.height+300);
    [self addChild:cloudsOnTop];
    
    NSString * starsPath = [[NSBundle mainBundle] pathForResource:@"Stars" ofType:@"sks"];
    SKEmitterNode * stars = [NSKeyedUnarchiver unarchiveObjectWithFile:starsPath];
    stars.name = @"stars";
    stars.position = CGPointMake(self.size.width/2, self.size.height+20);
    [self addChild:stars];
    
    switch (self.upgradeType)
    {
        case kUpgrade2Weapons:
            [self.mySpaceship setNumberOfWeaponSlots:2];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeElectricalGenerator];
            break;
        
        case kUpgradeSmartPhotons:
        {
            [self.mySpaceship powerUpCollected:kPowerUpTypePhotonCannon];
            [self.mySpaceship powerUpCollected:kPowerUpTypePhotonCannon];
            [self.mySpaceship powerUpCollected:kPowerUpTypePhotonCannon];
            [self.mySpaceship powerUpCollected:kPowerUpTypePhotonCannon];
            self.mySpaceship.damage = 9;
            self.enemyKit = [EnemyKit sharedInstanceWithScene:self];
            SKAction * addEnemies = [SKAction sequence:@[[SKAction performSelector:@selector(addEnemies) onTarget:self], [SKAction waitForDuration:2]]];
            [self runAction:[SKAction repeatActionForever:addEnemies]];
            break;
        }
            
        case kUpgradeMachineGunFireRate:
        {
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            MachineGun * machineGun = [self.mySpaceship.equippedWeapons objectForKey:[[self.mySpaceship.equippedWeapons allKeys ] firstObject]];
            machineGun.fireRateUpgraded = YES;
            break;
        }
            
        case kUpgradeShield:
        {
            self.enemyKit = [EnemyKit sharedInstanceWithScene:self];
            SKAction * addEnemies = [SKAction sequence:@[[SKAction performSelector:@selector(addEnemies) onTarget:self], [SKAction waitForDuration:1.5]]];
            [self runAction:[SKAction repeatActionForever:addEnemies]];
            [self makeShieldPowerUps];
            [self.mySpaceship equippedShield];
            break;
        }
            
        case kUpgradeBiggerLaser:
            [self.mySpaceship powerUpCollected:kPowerUpTypeLaserCannon];
            [self.mySpaceship powerUpCollected:kPowerUpTypeLaserCannon];
            [self.mySpaceship powerUpCollected:kPowerUpTypeLaserCannon];
            break;
            
        case kUpgradeElectricityChain:
        {
            self.enemyKit = [EnemyKit sharedInstanceWithScene:self];
            SKAction * addEnemies = [SKAction sequence:@[[SKAction performSelector:@selector(addEnemies) onTarget:self], [SKAction waitForDuration:2.2]]];
            [self runAction:[SKAction repeatActionForever:addEnemies]];
            
            [self.mySpaceship powerUpCollected:kPowerUpTypeElectricalGenerator];
            [self.mySpaceship powerUpCollected:kPowerUpTypeElectricalGenerator];
            [self.mySpaceship powerUpCollected:kPowerUpTypeElectricalGenerator];
            ElectricalGenerator * electricalGenerator = [self.mySpaceship.equippedWeapons objectForKey:[[self.mySpaceship.equippedWeapons allKeys ] firstObject]];
            electricalGenerator.electricityChainUnlocked = YES;
            break;
        }
            
        case kUpgradeEnergyBooster:
        {
            self.enemyKit = [EnemyKit sharedInstanceWithScene:self];
            SKAction * addEnemies = [SKAction sequence:@[[SKAction performSelector:@selector(addEnemies) onTarget:self], [SKAction waitForDuration:2.2]]];
            [self runAction:[SKAction repeatActionForever:addEnemies]];
            
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self makeEnergyBoosterPowerUps];
            break;
        }
            
        case kUpgrade4Weapons:
            [self.mySpaceship setNumberOfWeaponSlots:4];
            [self.mySpaceship powerUpCollected:kPowerUpTypeMachineGun];
            [self.mySpaceship powerUpCollected:kPowerUpTypeElectricalGenerator];
            [self.mySpaceship powerUpCollected:kPowerUpTypeLaserCannon];
            [self.mySpaceship powerUpCollected:kPowerUpTypePhotonCannon];
            break;
            
        default:
            break;
    }
}

- (void) setPaused:(BOOL)paused
{
    [[AudioManager sharedInstance] pauseMachineGuns:paused];
    [super setPaused:paused];
}

- (void) randomlyMoveShip
{
    SKAction * moveSpaceship = [SKAction moveTo:[self randomPosition] duration:15/self.mySpaceship.mySpeed];
    [self.mySpaceship runAction:moveSpaceship];
}

- (CGPoint) randomPosition
{
    CGPoint position = (CGPoint){(arc4random() % (int)self.scene.size.width) + 1.0f, (arc4random() % (int)(self.scene.size.height/4)) + 1.0f};
    return position;
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

- (void) makeShieldPowerUps
{
    SKAction * makeShieldPowerUps = [SKAction sequence:@[[SKAction performSelector:@selector(addShieldPowerUp) onTarget:self], [SKAction waitForDuration:2]]];
    [self runAction:[SKAction repeatActionForever:makeShieldPowerUps] withKey:@"makePowerUps"];
}

- (void) addShieldPowerUp
{
    PowerUp * tmpPowerUp = [[PowerUp alloc] initWithPowerUpType:kPowerUpTypeShield];
    tmpPowerUp.position = CGPointMake(skRand(0, self.size.width), self.size.height+50);
    [self addChild:tmpPowerUp];
    [tmpPowerUp.physicsBody applyImpulse:CGVectorMake(skRand(-tmpPowerUp.size.width/30, tmpPowerUp.size.width/30), -(tmpPowerUp.size.width + tmpPowerUp.size.height)/2)];
    [tmpPowerUp.physicsBody applyTorque:skRand(-.02, .02)];

}

- (void) makeEnergyBoosterPowerUps
{
    SKAction * makeEnergyBoosterPowerUps = [SKAction sequence:@[[SKAction performSelector:@selector(addEnergyBoosterPowerUp) onTarget:self], [SKAction waitForDuration:2]]];
    [self runAction:[SKAction repeatActionForever:makeEnergyBoosterPowerUps] withKey:@"makePowerUps"];
}

- (void) addEnergyBoosterPowerUp
{
    PowerUp * tmpPowerUp = [[PowerUp alloc] initWithPowerUpType:kPowerUpTypeEnergyBooster];
    tmpPowerUp.position = CGPointMake(skRand(0, self.size.width), self.size.height+50);
    [self addChild:tmpPowerUp];
    [tmpPowerUp.physicsBody applyImpulse:CGVectorMake(skRand(-tmpPowerUp.size.width/30, tmpPowerUp.size.width/30), -(tmpPowerUp.size.width + tmpPowerUp.size.height)/2)];
    [tmpPowerUp.physicsBody applyTorque:skRand(-.02, .02)];
    
}

- (void) addEnemies
{
    [self.enemyKit addEnemiesBasic:3 toScene:self withSpeed:1];
}

- (void) enemyExploded:(Enemy *)enemy
{
    if ( self.upgradeType == kUpgradeEnergyBooster )
        [self flashMultiplierOnNode:enemy];
}

- (void) flashMultiplierOnNode:(SKSpriteNode *)node
{
    SKLabelNode * tmpMultiplierLabel = [SKLabelNode labelNodeWithFontNamed:@"Moon-Bold"];
    tmpMultiplierLabel.text = @"x2";
    tmpMultiplierLabel.fontSize = 15;
    tmpMultiplierLabel.fontColor = [SKColor whiteColor];
    
    float yCoord = node.position.y - node.size.height;
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

- (void) update:(NSTimeInterval)currentTime
{
    [self enumerateChildNodesWithName:@"photon" usingBlock:^(SKNode * node, BOOL *stop)
     {
         [(Photon *)node update:currentTime];
     }];
    
    //electricity
    NSMutableArray * enemiesToTakeDmgFromElectricity = [NSMutableArray new];
    [self enumerateChildNodesWithName:@"//electricity" usingBlock:^(SKNode * node, BOOL *stop)
    {
        Electricity * tmpElectricityNode = (Electricity *)node;
        [tmpElectricityNode update:currentTime];
         
        [self enumerateChildNodesWithName:@"enemy*" usingBlock:^(SKNode * node1, BOOL *stop)
        {
            if ( [tmpElectricityNode intersectsNode:node1] )
            {
                if ( tmpElectricityNode.timeSinceLastDamageDealt + tmpElectricityNode.damageFrequency < currentTime )
                {
                    [enemiesToTakeDmgFromElectricity addObject:node1];
                    tmpElectricityNode.timeSinceLastDamageDealt = currentTime;
                }
            }
        }];
        
    }];
    
    for ( Enemy * enemy in enemiesToTakeDmgFromElectricity )
        [enemy takeDamage:[Electricity baseDamage]*self.mySpaceship.damage];

}

- (void) didSimulatePhysics
{
    // This is your last chance to make changes to the scene.
    [self enumerateChildNodesWithName:@"bullet" usingBlock:^(SKNode *node, BOOL *stop)
     {
         if ( node.position.y > self.scene.size.height + node.frame.size.height ||
             node.position.y < -node.frame.size.height ||
             node.position.x > self.scene.size.width + node.frame.size.width ||
             node.position.x < -node.frame.size.width )
             [node removeFromParent];
     }];
    
    [self enumerateChildNodesWithName:@"photon" usingBlock:^(SKNode *node, BOOL *stop)
     {
         if ( node.position.y > self.scene.size.height + 100 ||
             node.position.y < -100 ||
             node.position.x > self.scene.size.width + 100 ||
             node.position.x < -100)
             [node removeFromParent];
     }];
    
    [self enumerateChildNodesWithName:@"enemy*" usingBlock:^(SKNode * _Nonnull node, BOOL * _Nonnull stop)
     {
         if ( node.position.y <= -node.frame.size.height ||
             node.position.x > node.frame.size.width + self.scene.size.width ||
             node.position.x < -node.frame.size.height )
             [node removeFromParent];
     }];
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
    
    if ( [secondBody.node.name containsString:@"enemy"] )
    {
        if ( [firstBody.node.name isEqualToString:@"photon"] )
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
    else if ( [secondBody.node.name isEqualToString:@"laser"] )
    {
        if ( [firstBody.node.name containsString:@"enemy"] )
            [(Enemy *)firstBody.node takeDamage:[Laser baseDamage]*self.mySpaceship.damage];
    }
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
        if ( [firstBody.node.name containsString:@"enemy"] )
        {
            [(Enemy *)firstBody.node explode];
            [(Shield *)secondBody.node takeDamage];
        }
    }
}

#pragma mark photon/electricity stuff
- (SKNode *) nextPriorityTargetForPhoton:(Photon *)photon
{
    __block SKNode * closestTarget = nil;
    __block float closestDistance = -1;
    
    [[self scene] enumerateChildNodesWithName:@"enemy*" usingBlock:^(SKNode *node, BOOL *stop)
     {
         Enemy * tmpEnemy = (Enemy *)node;
         float distance = pow(tmpEnemy.position.x - photon.position.x, 2) + pow(tmpEnemy.position.y - (photon.position.y + 100), 2);
         // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
         if ( distance < closestDistance || closestDistance == -1 )
         {
             if ( tmpEnemy.photonsTargetingMe.count * [Photon baseDamage]*self.mySpaceship.damage < tmpEnemy.armor )
             {
                 closestDistance = distance;
                 closestTarget = tmpEnemy;
             }
         }
     }];
    
    return closestTarget;
}

- (SKNode *) nextPriorityTargetForElectricity:(Electricity *)electricity
{
    __block SKNode * closestTarget = nil;
    __block float closestDistance = -1;
    CGPoint electricityPointInScene = electricity.parent.parent.parent.position;
    
    [[self scene] enumerateChildNodesWithName:@"enemy*" usingBlock:^(SKNode *node, BOOL *stop)
     {
         float distance = pow(node.position.x - electricityPointInScene.x, 2) + pow(node.position.y - electricityPointInScene.y, 2);
         // float actualDistance = sqrtf(pow(node.position.x - point.x, 2) + pow(node.position.y - point.y, 2));
         if ( (distance < closestDistance || closestDistance == -1) && ![(Enemy *)node isBeingElectrocuted] )
         {
             closestDistance = distance;
             closestTarget = node;
         }
     }];
    
    return closestTarget;
}

- (float) distanceBetweenNodeA:(SKNode *)nodeA andNodeB:(SKNode *)nodeB
{
    float distance = sqrtf(pow(nodeA.position.x - nodeB.position.x, 2) + pow(nodeA.position.y - nodeB.position.y, 2));
    return distance;
}

- (void) didAddProjectile:(SKSpriteNode *)projectile forWeapon:(PlayerWeapon *)weapon
{
    
}

- (void) SASpriteNodeRemovingFromParent:(SASpriteNode *)node
{
    
}

@end
