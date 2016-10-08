//
//  SpaceshipKit.m
//  SpaceAttack
//
//  Created by chuck johnston on 2/22/15.
//  Copyright (c) 2015 chuck. All rights reserved.
//

#import "SpaceshipKit.h"

@implementation SpaceshipKit

static SpaceshipKit * sharedSpaceshipKit = nil;
+ (SpaceshipKit *)sharedInstance
{
    if ( sharedSpaceshipKit == nil )
    {
        sharedSpaceshipKit = [[SpaceshipKit alloc] init];
        
        sharedSpaceshipKit.explosionFrames = @[[SKTexture textureWithImageNamed:@"Ship_explosion1.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion2.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion3.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion4.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion5.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion6.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion7.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion8.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion9.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion10.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion11.png"],
                                               [SKTexture textureWithImageNamed:@"Ship_explosion12.png"]];
        
        NSString * abdulKair = NSStringFromClass([Abdul_Kadir class]);
        NSString * babenberg = NSStringFromClass([Babenberg class]);
        NSString * caiman = NSStringFromClass([Caiman class]);
        NSString * dandolo = NSStringFromClass([Dandolo class]);
        NSString * edinburgh = NSStringFromClass([Edinburgh class]);
        NSString * flandre = NSStringFromClass([Flandre class]);
        NSString * gascogne = NSStringFromClass([Gascogne class]);
        NSString * habsburg = NSStringFromClass([Habsburg class]);
        
        NSString * Reg = @"Reg";
        NSString * Bul = @"Bul";
        NSString * Pho = @"Pho";
        NSString * Ele = @"Ele";
        NSString * Laz = @"Laz";
        NSString * BulPho = @"BulPho";
        NSString * BulEle = @"BulEle";
        NSString * BulLaz = @"BulLaz";
        NSString * PhoEle = @"PhoEle";
        NSString * PhoLaz = @"PhoLaz";
        NSString * EleLaz = @"LazEle";
        
        sharedSpaceshipKit.shipTextures = @{abdulKair :
                                                @{Reg : [SKTexture textureWithImageNamed:abdulKair],
                                                  Bul : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[abdulKair stringByAppendingString:EleLaz]]},
                                            babenberg :
                                                @{Reg : [SKTexture textureWithImageNamed:babenberg],
                                                  Bul : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[babenberg stringByAppendingString:EleLaz]]},
                                            caiman :
                                                @{Reg : [SKTexture textureWithImageNamed:caiman],
                                                  Bul : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[caiman stringByAppendingString:EleLaz]]},
                                            dandolo :
                                                @{Reg : [SKTexture textureWithImageNamed:dandolo],
                                                  Bul : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[dandolo stringByAppendingString:EleLaz]]},
                                            edinburgh :
                                                @{Reg : [SKTexture textureWithImageNamed:edinburgh],
                                                  Bul : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[edinburgh stringByAppendingString:EleLaz]]},
                                            flandre :
                                                @{Reg : [SKTexture textureWithImageNamed:flandre],
                                                  Bul : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[flandre stringByAppendingString:EleLaz]]},
                                            gascogne :
                                                @{Reg : [SKTexture textureWithImageNamed:gascogne],
                                                  Bul : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[gascogne stringByAppendingString:EleLaz]]},
                                            habsburg :
                                                @{Reg : [SKTexture textureWithImageNamed:habsburg],
                                                  Bul : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:Bul]],
                                                  Pho : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:Pho]],
                                                  Ele : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:Ele]],
                                                  Laz : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:Laz]],
                                                  BulPho : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:BulPho]],
                                                  BulEle : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:BulEle]],
                                                  BulLaz : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:BulLaz]],
                                                  PhoEle : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:PhoEle]],
                                                  PhoLaz : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:PhoLaz]],
                                                  EleLaz : [SKTexture textureWithImageNamed:[habsburg stringByAppendingString:EleLaz]]}
                                            };
    }
    
    return sharedSpaceshipKit;
}

- (NSArray *) texturesForPreloading:(Spaceship*)spaceship
{
    NSMutableArray * texturesForPreloading = [NSMutableArray new];
    
    [texturesForPreloading addObjectsFromArray:[[self.shipTextures objectForKey:NSStringFromClass([spaceship class])] allValues]];
    [texturesForPreloading addObjectsFromArray:self.explosionFrames];
    
    return texturesForPreloading;
}

@end
