//
//  BlastGun.m
//  SpriteWalkthough
//
//  Created by chuck on 7/15/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "BlastGun.h"

@implementation BlastGun

- (id)init
{
    if (self = [super initWithImageNamed:@"blastGun.png"])
    {
		self = [[BlastGun alloc] initWithImageNamed:@"blastGun.png"];
        self.name = @"blastGun";
        self.position = CGPointMake(0, 60);
        
        self.projectileTexture = [SKTexture textureWithImageNamed:@"pellet.png"];
        
        [self startFiring];
	}
    return self;
}


- (void) startFiring
{
    SKAction * wait = [SKAction waitForDuration:-1];
    
    if ( self.level == 1 )
        wait = [SKAction waitForDuration:3];
    else if ( self.level == 2 )
        wait = [SKAction waitForDuration:.3]; // ill add another machine gun to the ship
    else if ( self.level == 3 )
        wait = [SKAction waitForDuration:.2];
    else if ( self.level == 4 )
        wait = [SKAction waitForDuration:.1];
    
    SKAction * performSelector = [SKAction performSelector:@selector(fire) onTarget:self];
    SKAction * fireSequence = [SKAction sequence:@[performSelector, wait]];
    SKAction * fireForever = [SKAction repeatActionForever:fireSequence];
    [self runAction:fireForever];
}

- (void) fire
{
    int numberOfPellets = 10;
    for ( int i = 0; i < numberOfPellets; i++ )
    {
        Pellet * tmpPellet = [[Pellet alloc] initWithTexture:self.projectileTexture];
        tmpPellet.position = [[self scene] convertPoint:self.position fromNode:self.parent];
        [[self scene] addChild:tmpPellet];
        [tmpPellet.physicsBody applyImpulse:CGVectorMake(sin((((float)i/(numberOfPellets-1)) * 180 * M_PI/180) + M_PI/2)*2,
                                                         cos((((float)i/(numberOfPellets-1)) * 180 * M_PI/180) + M_PI/2)*2)];
    }
}

@end
