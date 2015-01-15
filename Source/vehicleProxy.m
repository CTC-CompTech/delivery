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
            case 0:
                self.containedCar = [[defaultVehicle alloc]init];
                break;
                
            default:
                self.containedCar = [[defaultVehicle alloc]init];
                break;
        }
        // End of switch-case.
        
        [(CCSprite *)self setSpriteFrame:self.containedCar.carFrame];
    
}

// Runs moveLeft and moveRight in the contained car.
-(void)moveLeft {
    [self.containedCar moveLeft:self];
}

-(void)moveRight {
    [self.containedCar moveRight:self];
}

// Uses the ability of the current car.
-(void)useAbility {
    [self.containedCar useAbility];
}

// Updates the state of the selected car.
-(void)update:(CCTime)delta {
    [self.containedCar passthroughUpdate:delta parentPointer:self];
}

// Returns the name of the current type of car.
-(NSString *)getCarType{
    return self.containedCar.carType;
}

// Overriden initializer to create a default car for safety.
-(id)init{
    if (self = [super init]){
        [self setVehicleType:defaultVehicleEnum];
        return self;
    }
    return nil;
}
@end
