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
    
//    CCSpriteFrame *deliveryTruck = [CCSpriteFrame frameWithImageNamed:@"Delivery/Truck.png"];
    
//    NSArray *selectedCar = @[deliveryTruck];
    
    NSString *selectedCar = @"Delivery/Truck.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
     
    _deliveryTruck.togglesSelectedState = YES;
}

- (void)pickupTruck {
    NSString *selectedCar = @"Delivery/Pickup Truck.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
    
    _pickupTruck.togglesSelectedState = YES;
}

- (void)jeep {
    NSString *selectedCar = @"Delivery/Jeep.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
    
    _jeep.togglesSelectedState = YES;

}

- (void)policeCar {
    NSString *selectedCar = @"Delivery/Police Car.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
    
    _policeCar.togglesSelectedState = YES;
}

- (void)lightRunner {
    NSString *selectedCar = @"Delivery/Light Runner.png";
         
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
         
    _lightRunner.togglesSelectedState = YES;
}

- (void)sportsCar {
    NSString *selectedCar = @"Delivery/Sports Car.png";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:selectedCar forKey:@"selectedCar"];
    [defaults synchronize];
    
    _sportsCar.togglesSelectedState = YES;
}

@end
