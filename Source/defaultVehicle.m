//
//  defaultVehicle.m
//  Delivery
//
//  Created by Grant Jennings on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "defaultVehicle.h"



@implementation defaultVehicle

-(id)init{
    if (self = [super init]){
        _carType = @"defaultCar";
        _canUseAbility = true;
        _abilityTimeout = 0;
        _abilityCooldown = 5;
        if ( (_carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/ Sports Car.png"]))
            return nil;
        else
            return self;
    
 
    }
    else
        return nil;
}



-(void)moveLeft:(CCNode*)realVehicle {
    [self evaluateLeftOrRight:CAR_MOVE_LEFT parentPointer:realVehicle];
}



-(void)moveRight:(CCNode*)realVehicle {
    [self evaluateLeftOrRight:CAR_MOVE_RIGHT parentPointer:realVehicle];
}



-(BOOL)evaluateLeftOrRight:(BOOL)leftOrRight parentPointer:(CCNode *)realVehicle{
    if (leftOrRight == CAR_MOVE_LEFT)
        return CAR_MOVE_LEFT;
    
    else
        return CAR_MOVE_RIGHT;
}

-(void)useAbility {
    if (self.canUseAbility == true){
        
    }
    self.canUseAbility = false;
}

-(void)abilityUpdate:(CCTimer *)delta parentPointer:(CCNode *)realVehicle{
    if (!self.canUseAbility){
        
    }
    return;
}

-(void)passthroughUpdate:(CCTimer *)delta parentPointer:(CCNode *)realVehicle{
    [self abilityUpdate:delta parentPointer:realVehicle];
}

-(void)onTypeChange:(CCNode *)realVehicle{
    self.abilityTimeout = 0;
    self.canUseAbility = true;
}


@end
