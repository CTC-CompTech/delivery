//
//  defaultVehicle.h
//  Delivery
//
//  Created by Grant Jennings on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

// This is the default implementation for a car. It is used polymorphically as a base class.

#import "CCSprite.h"

#define CAR_MOVE_LEFT 0
#define CAR_MOVE_RIGHT 1
#define DOING_ABILITY 0
#define FINISHED_DOING_ABILITY 1


@interface defaultVehicle : NSObject


// Define the default properties for a car. Should be set to different values by redefining the initializer.

// String-based name of the car. Should usually be set to the name of the current class.
@property (readonly) NSString* carType;

// Holds the default frame for this type of car.
@property (readonly, retain) CCSpriteFrame* carFrame;

// abilityCooldown. Time in seconds before an ability can be used.
@property (readonly) double abilityCooldown;

// Default location for storing the remaining time on an ability.
@property double abilityTimeout;

// Default variable used for indicating if an ability is finished.
@property () BOOL canUseAbility;



// The argument realVehicle indicates that the method needs to be able to modify the image that the user sees.
// Objects that shouln't be owned by the vehicle should be passed this way.

// Do the reset of internal variables for when car type is changed. The super version should always be called in addition to the custom one.
-(void)onTypeChange:(CCNode*)realVehicle;

// Move the car left and right one lane, respectively.
-(void)moveLeft:(CCNode*)realVehicle;
-(void)moveRight:(CCNode*)realVehicle;

// Checks what lane the car is currently in and moves it.
-(BOOL)evaluateLeftOrRight:(BOOL)leftOrRight parentPointer:(CCNode*)realVehicle;

// Uses the ability for this car.
-(void)useAbility;

// Allows per-frame updates and Cocos2D pausing. Should call abilityUpdate ASAP.
-(void)passthroughUpdate:(CCTimer*)delta parentPointer:(CCNode*)realVehicle;

// Performs the ability. May be one-time or time-based.
-(void)abilityUpdate:(CCTimer*)delta parentPointer:(CCNode*)realVehicle; //Performs the actual ability.


@end
