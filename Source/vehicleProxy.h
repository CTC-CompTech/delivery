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

// Setup the vehicle. Used to reset the sprite and add objects to the scene.
-(void)setupVehicle;

// Reference to a car that does all the real behavior
@property (retain) defaultVehicle *containedCar;

// Is the internal car initialized with this parent?
@property (nonatomic) bool isSetup;

// Passthrough functions that call methods on the polymorhic car.
-(void)moveLeft;
-(void)moveRight;
-(void)useAbility;
-(NSString *)getVehicleType;

// Set and get the car speed.
-(void)setVehicleSpeed:(double)newSpeed;
-(double)getVehicleSpeed; // Exists for compatibility reasons.


@end
