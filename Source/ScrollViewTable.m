//
//  ScrollViewTable.m
//  Delivery
//
//  Created by Michael Blades on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ScrollViewTable.h"

@implementation ScrollViewTable {
    
    CCButton *_deliveryTruck;
    CCButton *_pickupTruck;
    CCButton *_jeep;
    CCButton *_policeCar;
    CCButton *_lightRunner;
    CCButton *_sportsCar;
    
}

- (void)deliveryTruck {
    
//    CCSpriteFrame *deliveryTruck = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Truck.png"];
    
//    NSArray *selectedCar = @[deliveryTruck];
    
    NSString *selectedCar = @"Delivery/Heros/Truck.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults setInteger:whiteTruckEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
}

- (void)pickupTruck {
    NSString *selectedCar = @"Delivery/Heros/Pickup Truck.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults setInteger:pickupTruckEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
}

- (void)jeep {
    NSString *selectedCar = @"Delivery/Heros/Jeep.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults setInteger:jeepEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
}

- (void)policeCar {
    NSString *selectedCar = @"Delivery/Heros/Police Car.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults setInteger:policeCarEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
}

- (void)lightRunner {
    NSString *selectedCar = @"Delivery/Heros/Light Runner.png";
         
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults setInteger:lightRunnerEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
}

- (void)sportsCar {
    NSString *selectedCar = @"Delivery/Heros/Sports Car.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults setInteger:sportsCarEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
}

@end
