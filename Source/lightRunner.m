//
//  lightRunner.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "lightRunner.h"

@interface lightRunner ()

@property (nonatomic) unsigned int useCount;

@property (nonatomic, weak) CCSprite* rocket;

@property (nonatomic, weak) CCNode* abilityButton;

@end


@implementation lightRunner

-(id)init{
    if (self = [super init]){
        self.carType = @"lightRunner";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Light Runner.png"])){
            NSLog(@"Broken Image!!!");
            return nil;
        }
        else
            return self;
        
        
    }
    else
        return nil;
}



-(void)setupVehicle{
    [self.parentVehicle.scene addChild:[CCBReader load:@"Light Runner Overlay" owner:self]];
    self.rocket.visible = false;
    self.useCount = 3;
}


-(void)useAbility{
    
}


@end
