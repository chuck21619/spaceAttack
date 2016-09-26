//
//  Asteroid.m
//  SpriteWalkthough
//
//  Created by chuck on 4/24/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Asteroid.h"
#import "CategoryBitMasks.h"
#import "AudioManager.h"

@implementation Asteroid

@synthesize delegate = delegate; // interited from SASpriteNode

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}


- (instancetype)initWithAtlas : (NSArray *)textureAtlas
{
    if ( self = [super initWithTexture:textureAtlas[0]] )
    {
        self.crumbleFrames = textureAtlas;
        self.name = @"asteroid";
        self.maxHealth = 30;
        self.health = self.maxHealth;
        self.pointValue = 1;
        self.photonsTargetingMe = [NSPointerArray weakObjectsPointerArray];
        self.isBeingElectrocuted = NO;
        
        float resizeFactor = ([[UIScreen mainScreen] bounds].size.width/320.0)*.7;
        int asteroidSize = skRand(20*resizeFactor, 40*resizeFactor);
        self.size = CGSizeMake(asteroidSize, asteroidSize);
        
        float physicsBodyRadius = (self.size.width*.8)/2;
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:physicsBodyRadius];
        //[self attachDebugCircleWithSize:physicsBodyRadius*2];
        
        self.physicsBody.dynamic = YES;
        self.physicsBody.categoryBitMask = [CategoryBitMasks asteroidCategory];
        self.physicsBody.collisionBitMask = 0;//[CategoryBitMasks asteroidCategory];
        self.physicsBody.contactTestBitMask = [CategoryBitMasks asteroidCategory] | [CategoryBitMasks shipCategory] | [CategoryBitMasks missileCategory];
        [self setSize:CGSizeMake(asteroidSize, asteroidSize)];
        self.physicsBody.restitution = .6;
        self.physicsBody.linearDamping = 0;
        
        self.blendMode = SKBlendModeScreen;
    }
    return self;
}

- (void) crumble
{
    NSString * crumblePath = [[NSBundle mainBundle] pathForResource:@"CrumbleParticle" ofType:@"sks"];
    SKEmitterNode * crumble = [NSKeyedUnarchiver unarchiveObjectWithFile:crumblePath];
    crumble.numParticlesToEmit = self.size.width / 5;
    crumble.name = @"crumble";
    crumble.particleSpeed = (self.physicsBody.velocity.dx + self.physicsBody.velocity.dy) * .4;
    crumble.position = self.position;
    
    [[self scene] addChild:crumble];
    [crumble performSelector:@selector(removeFromParent) withObject:crumble afterDelay:3];
    [self removeFromParent];
    
    [self.delegate asteroidCrumbled:self];
}

- (void) takeDamage:(int)damage
{
    [[AudioManager sharedInstance] playSoundEffect:kSoundEffectAsteroidCrumble];
    self.health -= damage;
    
    if ( self.health <= 0 )
        [self crumble];
    else
    {
        float percentageOfHealth = (float)self.health/self.maxHealth;
        float percentageOfFrames = (1-percentageOfHealth)*self.crumbleFrames.count;
        int nearestFrame = ceil(percentageOfFrames);
        SKTexture * tmpTexture = [self.crumbleFrames objectAtIndex:nearestFrame-1];
        [self setTexture:tmpTexture];
    }
}

- (void)attachDebugCircleWithSize:(int)s
{
    CGPathRef bodyPath = CGPathCreateWithEllipseInRect(CGRectMake(-s/2, -s/2, s, s), nil);
    [self attachDebugFrameFromPath:bodyPath];
}

- (void)attachDebugFrameFromPath:(CGPathRef)bodyPath {
    //if (kDebugDraw==NO) return;
    SKShapeNode *shape = [SKShapeNode node];
    shape.zPosition = 100;
    shape.path = bodyPath;
    shape.strokeColor = [SKColor colorWithRed:1.0 green:1 blue:1 alpha:1];
    shape.lineWidth = 1.0;
    [self addChild:shape];
}

@end
