//
//  ScrollViewTable.m
//  Delivery
//
//  Created by Michael Blades on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ScrollViewTable.h"

@implementation ScrollViewTable

- (void)deliveryTruck {
    
//    CCSpriteFrame *deliveryTruck = [CCSpriteFrame frameWithImageNamed:@"Delivery/Truck.png"];
    
//    NSArray *selectedCar = @[deliveryTruck];
    
    NSString *selectedCar = @"Delivery/Truck.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
}

- (void)pickupTruck {
    NSString *selectedCar = @"Delivery/Pickup Truck.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
}

- (void)jeep {
    NSString *selectedCar = @"Delivery/Jeep.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
}

- (void)policeCar {
    NSString *selectedCar = @"Delivery/Police Car.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
}

- (void)sportsCar {
    NSString *selectedCar = @"Delivery/Sports Car.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
}

- (void)lightRunner {
    NSString *selectedCar = @"Delivery/Light Runner.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
}

@end
