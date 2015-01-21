//
//  vehicleProxy.h
//  Delivery
//
//  Created by Grant Jennings on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "defaultVehicle.h"
#import "vehicleIncludes.h"

@interface vehicleProxy : CCSprite

// Sets the type of car currently in use.
-(void)setVehicleType:(vehicleType) inputOfType;

// Sets the sprite to the one that the current car is using. (Overrides the one inserted by spritebuilder)
-(void)setCorrectVehicleSprite;

// Reference to a car that does all the real behavior
@property (retain) defaultVehicle *containedCar;

// Passthrough functions that call methods on the polymorhic car.
-(void)moveLeft;
-(void)moveRight;
-(void)useAbility;
-(NSString *)getVehicleType;

// Set and get the car speed.
-(void)setVehicleSpeed:(double)newSpeed;
-(double)getVehicleSpeed; // Exists for compatibility reasons.


@end
