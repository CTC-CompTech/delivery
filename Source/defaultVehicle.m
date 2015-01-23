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
        self.carType = @"defaultCar";
        self.canUseAbility = true;
        self.abilityTimeout = 0;
        self.abilityCooldown = 5;
        self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Truck.png"];
        self.vehicleSpeed = 210.0f;
        self.isPaused = false;
        return self;
    }
    else
        return nil;
}


-(void)moveLeft{
    [self evaluateLeftOrRight:CAR_MOVE_LEFT];
}



-(void)moveRight{
    [self evaluateLeftOrRight:CAR_MOVE_RIGHT];
}



-(BOOL)evaluateLeftOrRight:(BOOL)leftOrRight{

    CGPoint byPoint;
    double angleToRotate = 0;
    
    if (!leftOrRight){
        if (self.parentVehicle.position.x <= 50) {byPoint = ccp(0, 0);}
        else {byPoint = ccp(-64, 0);}
        angleToRotate = -45;
    }
    
    else if (leftOrRight){
        if (self.parentVehicle.position.x >= 250) {byPoint = ccp(0, 0);}
        else {byPoint = ccp(64, 0);}
        angleToRotate = 45;
    }
    
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.075 position:byPoint];
    CCActionRotateBy *rotateBy = [CCActionRotateBy actionWithDuration:0.0375 angle:angleToRotate];
    CCActionRotateTo *rotateByReverse = [CCActionRotateTo actionWithDuration:0.0375 angle:-90];
    CCActionSequence *swipe = [CCActionSequence actionWithArray:@[rotateBy, moveBy, rotateByReverse]];
        
    [self.parentVehicle runAction:swipe];
    return leftOrRight;

}


-(void)useAbility {

}

-(void)abilityUpdate:(CCTime)delta{

}

-(void)passthroughUpdate:(CCTime)delta{
    [self abilityUpdate:delta];
    self.parentVehicle.parent.position = ccp(self.parentVehicle.parent.position.x, self.parentVehicle.parent.position.y - (self.vehicleSpeed * delta));
    self.parentVehicle.position = ccp(self.parentVehicle.position.x, self.parentVehicle.position.y + (delta * self.vehicleSpeed));
}

-(void)setupVehicle{
    
}

-(void)onPause{
    self.isPaused = true;
}

-(void)onResume{
    self.isPaused = false;
}


@end
