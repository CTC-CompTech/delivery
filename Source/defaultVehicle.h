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
@property (nonatomic, copy) NSString* carType;

// Holds the default frame for this type of car.
@property (nonatomic, retain) CCSpriteFrame* carFrame;

// abilityCooldown. Time in seconds before an ability can be used.
@property (nonatomic) double abilityCooldown;

// Default location for storing the remaining time on an ability.
@property (nonatomic) double abilityTimeout;

// Default variable used for indicating if an ability is finished.
@property (nonatomic) BOOL canUseAbility;

// Double for holding and setting the movement speed of the vehicle.
@property (nonatomic) double vehicleSpeed;

// Weak reference to the parent vehicleProxy
@property (weak, nonatomic) CCSprite* parentVehicle;

// Reference to the ability overlay
@property (weak, nonatomic) CCNode* abilityOverlay;

// Is the game paused?
@property (nonatomic) bool isPaused;



// The argument realVehicle indicates that the method needs to be able to modify the image that the user sees.
// Objects that shouln't be owned by the vehicle should be passed this way.

// Set up the vehicle when the proxy has a parent
-(void)setupVehicle;

// Move the car left and right one lane, respectively.
-(void)moveLeft;
-(void)moveRight;

// Checks what lane the car is currently in and moves it.
-(BOOL)evaluateLeftOrRight:(BOOL)leftOrRight;

// Uses the ability for this car.
-(void)useAbility;

// Allows per-frame updates and Cocos2D pausing. This base one should always be called.
-(void)passthroughUpdate:(CCTime)delta;

// Performs the ability. May be one-time or time-based.
-(void)abilityUpdate:(CCTime)delta; //Performs the actual ability.

// Run when the game is paused or resumed (By external functions, not automatically)
-(void)onPause;
-(void)onResume;

@end
