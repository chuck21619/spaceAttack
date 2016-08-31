//
//  Electricity.m
//  SpriteWalkthough
//
//  Created by chuck on 6/7/14.
//  Copyright (c) 2014 chuck. All rights reserved.
//

#import "Electricity.h"
#import "SpaceshipScene.h"
#import "CategoryBitMasks.h"

@implementation Electricity


- (id) initWithDamageFrequency:(float)damageFrequency
{
    if (self = [super init])
    {
        self.size = CGSizeMake(150, 1000);
        self.name = @"electricity";
        self.timeSinceLastDamageDealt = -1;
        self.damageFrequency = damageFrequency;
        self.anchorPoint = CGPointMake(0.5, 0);
    }
    return self;
}

- (void) update :(NSTimeInterval)currentTime
{
    if ( self.target == nil )
        self.target = [(SpaceshipScene *)[self scene] nextPriorityTargetForElectricity:self];
    
    if ( self.target )
    {
        if ( ![self.parent.name isEqualToString:@"chainElectricityCropNode"] )
            [(ElectricalGenerator *)self.parent.parent firstElectricityTargetUpdate:self.target];
        
        if ( [self.target class] == [Asteroid class] )
            [(Asteroid *)self.target setIsBeingElectrocuted:YES];
        else if ( [self.target isKindOfClass:[Enemy class]] )
            [(Enemy *)self.target setIsBeingElectrocuted:YES];
        
        //goofy ass length equation cuz i never figured out why a standard length equation didnt work
        float length = ( [(SpaceshipScene *)[self scene] distanceBetweenNodeA:self.parent.parent.parent andNodeB:self.target] * 2.5 ) - .5*( self.target.position.y - self.parent.parent.parent.position.y ) + skRand(-200, 100);
        //have to check if the length is < 0 cuz of the goofy ass length equation
        if ( length < 0 )
            length = 0;
//        else if ( length > self.texture.size.height )
//            length = self.texture.size.height;
        
        [self.myCropNode setMaskNode:[SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size: CGSizeMake(self.size.width, length)]];
        
        float deltaY = ( self.target.position.y - [[self scene] convertPoint:self.parent.position fromNode:self.parent.parent].y );
        float deltaX = ( self.target.position.x - [[self scene] convertPoint:self.parent.position fromNode:self.parent.parent].x );
        self.myCropNode.zRotation = atan2(deltaY, deltaX) - M_PI / 2;
    }
    else if ( ![self.parent.name isEqualToString:@"chainElectricityCropNode"] )
        [(ElectricalGenerator *)self.parent.parent firstElectricityTargetUpdate:nil];
}

static inline CGFloat skRandf()
{
    return rand() / (CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high)
{
    return skRandf() * (high - low) + low;
}

+ (int) baseDamage
{
    return 1;
}

//- (void) removeFromParent // this is overriding the SASpriteNode implementation
//{
//    [super removeFromParent];
//}

@end
