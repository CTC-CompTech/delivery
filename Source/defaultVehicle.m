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
        if ( !(_carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Sports Car.png"])){
            NSLog(@"Broken Image!!!");
            return nil;
        }
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

    CGPoint byPoint;
    double angleToRotate = 0;
    
    if (!leftOrRight){
        if (realVehicle.position.x <= 50) {byPoint = ccp(0, 0);}
        else {byPoint = ccp(-64, 0);}
        angleToRotate = -45;
    }
    
    else if (leftOrRight){
        if (realVehicle.position.x >= 250) {byPoint = ccp(0, 0);}
        else {byPoint = ccp(64, 0);}
        angleToRotate = 45;
    }
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.075 position:byPoint];
    CCActionRotateBy *rotateBy = [CCActionRotateBy actionWithDuration:0.0375 angle:angleToRotate];
    CCActionRotateTo *rotateByReverse = [CCActionRotateTo actionWithDuration:0.0375 angle:-90];
    CCActionSequence *swipe = [CCActionSequence actionWithArray:@[rotateBy, moveBy, rotateByReverse]];
        
    [realVehicle runAction:swipe];
    return leftOrRight;

}

-(void)useAbility {
    if (self.canUseAbility == true){
        
    }
    self.canUseAbility = false;
}

-(void)abilityUpdate:(CCTime)delta parentPointer:(CCNode *)realVehicle{
    if (!self.canUseAbility){
        
    }
    return;
}

-(void)passthroughUpdate:(CCTime)delta parentPointer:(CCNode *)realVehicle{
    [self abilityUpdate:delta parentPointer:realVehicle];
}


@end
