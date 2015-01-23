//
//  vehicleProxy.m
//  Delivery
//
//  Created by Grant Jennings on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "vehicleProxy.h"

@implementation vehicleProxy

// Used to set the vehicle type.

-(void)setVehicleType:(vehicleType)inputOfType{

        // Switch-case for adding new cars. Add new types to the bottom of this.
        switch (inputOfType) {
            case defaultVehicleEnum:
                self.containedCar = [[defaultVehicle alloc]init];
                break;
                
            case whiteTruckEnum:
                self.containedCar = [[whiteTruck alloc]init];
                break;
            
            case sportsCarEnum:
                self.containedCar = [[sportsCar alloc]init];
                break;
                
            case policeCarEnum:
                self.containedCar = [[policeCar alloc]init];
                break;
                
            case pickupTruckEnum:
                self.containedCar = [[pickupTruck alloc]init];
                break;
                
            case lightRunnerEnum:
                self.containedCar = [[lightRunner alloc]init];
                break;
                
            case jeepEnum:
                self.containedCar = [[jeep alloc]init];
                break;
                
            default:
                self.containedCar = [[defaultVehicle alloc]init];
                break;
        }
        // End of switch-case.
        
        [(CCSprite *)self setSpriteFrame:self.containedCar.carFrame];
        self.containedCar.parentVehicle = self;
    self.isSetup = false;
    
}

// Runs moveLeft and moveRight in the contained car.
-(void)moveLeft {
    if (self.containedCar.isPaused == false)
    [self.containedCar moveLeft];
}

-(void)moveRight {
    if (self.containedCar.isPaused == false)
    [self.containedCar moveRight];
}

// Uses the ability of the current car.
-(void)useAbility {
    if (self.containedCar.isPaused == false)
    [self.containedCar useAbility];
}

// Updates the state of the selected car.
-(void)update:(CCTime)delta {
    if (self.containedCar.isPaused == false)
    [self.containedCar passthroughUpdate:delta];
}

// Returns the name of the current type of car.
-(NSString *)getVehicleType{
    return self.containedCar.carType;
}

// Re-set the correct sprite
-(void)setupVehicle{
    if (!self.isSetup){
    [(CCSprite *)self setSpriteFrame:self.containedCar.carFrame];
    [self.containedCar setupVehicle];
    self.isSetup = true;
    }
}

// Set the speed of the internal vehicle.
-(void)setVehicleSpeed:(double)newSpeed{
    if (self.containedCar.canUseAbility == true)
    self.containedCar.vehicleSpeed = newSpeed;
}

-(double)getVehicleSpeed{
    return self.containedCar.vehicleSpeed;
}

-(void)onPause{
    [self.containedCar onPause];
}

-(void)onResume{
    [self.containedCar onResume];
}

// Overriden initializer to create a default car for safety.
-(id)init{
    if (self = [super init]){
        NSUserDefaults *getCarIndex = [NSUserDefaults standardUserDefaults];
        [self setVehicleType:(vehicleType)[getCarIndex integerForKey:@"vehicleIndex"]];
        getCarIndex = nil;
        return self;
    }
    return nil;
}
@end
