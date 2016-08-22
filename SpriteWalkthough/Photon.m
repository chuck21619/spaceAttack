//
//  Photon.m
//  SpriteWalkthough
//
//  Created by chuck on 4/25/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Photon.h"
#import "Asteroid.h"
#import "SpaceshipScene.h"
#import "CategoryBitMasks.h"
#import "UpgradeScene.h"
#import "AudioManager.h"

@implementation Photon

- (id)initWithTexture:(SKTexture *)texture
{
    if (self = [super initWithTexture:texture])
    {
        self.name = @"photon";
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width/2];
        self.maxVelocity = 400;
        self.position = CGPointMake(0, 0);
        //self.physicsBody.velocity = CGVectorMake(0, self.maxVelocity);
        //self.physicsBody.linearDamping = .5;
        self.acceleration = 35;
        self.target = nil;
        self.targetingFrequency = .5;
        self.timeSinceLastAttemptedTargeting = -1;
        self.hasTargeted = NO;
        self.isSmart = NO;
        
        NSString * photonParticlePath = [[NSBundle mainBundle] pathForResource:@"photonParticle" ofType:@"sks"];
        SKEmitterNode * particleness = [NSKeyedUnarchiver unarchiveObjectWithFile:photonParticlePath];
        particleness.name = @"photonParticle";
        particleness.zPosition = 5;
        [self addChild:particleness];
        
        self.physicsBody.categoryBitMask = [CategoryBitMasks photonCategory];
        self.physicsBody.collisionBitMask = 0;
        self.physicsBody.contactTestBitMask = [CategoryBitMasks asteroidCategory] | [CategoryBitMasks enemyCategory];
    }
    return self;
}


- (void) update :(NSTimeInterval)currentTime
{
    if ( self.target == nil ) //&& (!self.hasTargeted) )
    {
        if ( self.hasTargeted && !self.isSmart )
            return;
        
        if ( ! (self.timeSinceLastAttemptedTargeting + self.targetingFrequency < currentTime) )
            return;
        
        self.timeSinceLastAttemptedTargeting = currentTime;
        
        if ( [[self scene] class] == [SpaceshipScene class] )
            self.target = [(SpaceshipScene *)[self scene] nextPriorityTargetForPhoton:self];
        else if ( [[self scene] class] == [UpgradeScene class] )
            self.target = [(UpgradeScene *)[self scene] nextPriorityTargetForPhoton:self];
        
        if ( [self.target class] == [Asteroid class] )
            [[(Asteroid *)self.target photonsTargetingMe] addPointer:(__bridge void * _Nullable)(self)];
        else if ( [self.target isKindOfClass:[Enemy class]] )
            [[(Enemy *)self.target photonsTargetingMe] addPointer:(__bridge void * _Nullable)(self)];
        
        self.hasTargeted = YES;
        
    }
    
    if ( self.target )
    {
        CGPoint direction = ccpNormalize(ccpSub(self.target.position, self.position));
        CGPoint addedAcceleration = ccpMult(direction, self.acceleration);
        CGPoint newVelocity = CGPointMake(self.physicsBody.velocity.dx + addedAcceleration.x, self.physicsBody.velocity.dy + addedAcceleration.y);
        self.physicsBody.velocity = CGVectorMake(newVelocity.x, newVelocity.y);
        self.zRotation = atan2(self.physicsBody.velocity.dy, self.physicsBody.velocity.dx) - M_PI / 2 ;
        
        if ( sqrtf( pow(self.physicsBody.velocity.dx, 2) + pow(self.physicsBody.velocity.dy, 2) ) > self.maxVelocity )
        {
            newVelocity = ccpMult(ccpNormalize(newVelocity), self.maxVelocity);
            self.physicsBody.velocity = CGVectorMake(newVelocity.x, newVelocity.y);
        }
    }
}

+ (int) baseDamage
{
    return 10;
}

- (void) explode
{
    NSString * explosionPath = [[NSBundle mainBundle] pathForResource:@"photonExplosion" ofType:@"sks"];
    SKEmitterNode * explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.name = @"explosion";
    explosion.position = self.position;
    
    [[self scene] addChild:explosion];
    [explosion performSelector:@selector(removeFromParent) withObject:explosion afterDelay:1];
    [self removeFromParent];
    
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectPhotonExplosion];
}


static inline CGPoint ccpNormalize(const CGPoint v)
{
    return ccpMult(v, 1.0f/ccpLength(v));
}

static inline CGPoint ccpMult(const CGPoint v, const CGFloat s)
{
    return CGPointMake(v.x*s, v.y*s);
}

static inline CGFloat ccpLength(const CGPoint v)
{
    return sqrtf(ccpLengthSQ(v));
}

static inline CGFloat ccpLengthSQ(const CGPoint v)
{
    return ccpDot(v, v);
}

static inline CGFloat ccpDot(const CGPoint v1, const CGPoint v2)
{
    return v1.x*v2.x + v1.y*v2.y;
}

static inline CGPoint ccpSub(const CGPoint v1, const CGPoint v2)
{
    return CGPointMake(v1.x - v2.x, v1.y - v2.y);
}

@end
