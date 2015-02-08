//
//  ScrollViewTable.m
//  Delivery
//
//  Created by Michael Blades on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ScrollViewTable.h"
#import "Stats.h"

@interface ScrollViewTable ()

@property NSInteger amountToTakeOut;
@property (strong, nonatomic) NSString *carTouched;

@end

@implementation ScrollViewTable {
    
    CCButton *_deliveryTruck;
    CCButton *_pickupTruck;
    CCButton *_jeep;
    CCButton *_policeCar;
    CCButton *_lightRunner;
    CCButton *_sportsCar;
    
    CCNode *_PTLock;
    CCNode *_JLock;
    CCNode *_PLock;
    CCNode *_LRLock;
    CCNode *_SLock;
    
}

- (void)onEnter {
    [super onEnter];
    
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        
        if ([grabbedCar isEqual: @"PickupTruck"]) {
            _PTLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"Jeep"]) {
            _JLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"PoliceCar"]) {
            _PLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"LightRunner"]) {
            _LRLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"SportsCar"]) {
            _SLock.visible = FALSE;
        }
        
    }
    
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
    
    BOOL doesOwn = [self doesUserOwnCar:@"PickupTruck"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Pickup Truck.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:pickupTruckEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
        
        // TODO: Setup some sort of "alert" of when car is being replaced.
        
    } else {
        self.amountToTakeOut = 5000;
        self.carTouched = @"PickupTruck";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)jeep {
    
    BOOL doesOwn = [self doesUserOwnCar:@"Jeep"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Jeep.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:jeepEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
    } else {
        self.amountToTakeOut = 10000;
        self.carTouched = @"Jeep";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)policeCar {
    
    BOOL doesOwn = [self doesUserOwnCar:@"PoliceCar"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Police Car.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:policeCarEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
    } else {
        self.amountToTakeOut = 20000;
        self.carTouched = @"PoliceCar";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)lightRunner {
    
    BOOL doesOwn = [self doesUserOwnCar:@"LightRunner"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Light Runner.png";
         
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:lightRunnerEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
    } else {
        self.amountToTakeOut = 50000;
        self.carTouched = @"LightRunner";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)sportsCar {
    
    BOOL doesOwn = [self doesUserOwnCar:@"SportsCar"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Sports Car.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:sportsCarEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
    } else {
        self.amountToTakeOut = 100000;
        self.carTouched = @"SportsCar";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (BOOL)doesUserOwnCar:(NSString *)car {
    
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        if (car == grabbedCar) {
            return TRUE;
        }
    }
    
    return FALSE;
}

- (void)displayAlertWithAmount:(NSInteger)amount {
    
    NSString *formattedAmount = [self formatter:amount];
    
#if __CC_PLATFORM_IOS
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buy Car?"
                                                    message:[NSString stringWithFormat:@"Would you like to buy this car for %@ coins?", formattedAmount]
                                                   delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes, please", nil];
    [alert show];
#endif
    
//#if __CC_PLATFORM_ANDROID
//    dispatch_async(dispatch_get_main_queue(), ^{
//        AndroidAlertDialogBuilder *alert = [[AndroidAlertDialogBuilder alloc] initWithContext:[CCActivity currentActivity]
//                                                                                        theme:AndroidAlertDialogThemeHoloDark];
//        [alert setTitleByCharSequence:@:@"Buy Car?"];
//        [alert show];
//    });
//#endif
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        
        if (self.amountToTakeOut > [[Stats instance].currentCoin integerValue]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
                                                            message:@"You do not have enough coins to buy this car."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Okay, sorry."
                                                  otherButtonTitles:nil];
            [alert show];
            
        } else {
            
            NSInteger currentCoin = [[Stats instance].currentCoin integerValue];
            [Stats instance].currentCoin = [NSNumber numberWithInteger:currentCoin - self.amountToTakeOut];
            
            if ([self.carTouched isEqual: @"PickupTruck"]) {
                _PTLock.visible = FALSE;
                [[Stats instance].ownedCars addObject:@"PickupTruck"];
            }
            if ([self.carTouched isEqual: @"Jeep"]) {
                _JLock.visible = FALSE;
                [[Stats instance].ownedCars addObject:@"Jeep"];
            }
            if ([self.carTouched isEqual: @"PoliceCar"]) {
                _PLock.visible = FALSE;
                [[Stats instance].ownedCars addObject:@"PoliceCar"];
            }
            if ([self.carTouched isEqual: @"LightRunner"]) {
                _LRLock.visible = FALSE;
                [[Stats instance].ownedCars addObject:@"LightRunner"];
            }
            if ([self.carTouched isEqual: @"SportsCar"]) {
                _SLock.visible = FALSE;
                [[Stats instance].ownedCars addObject:@"SportsCar"];
            }
            
        }
        
    } else {
        return;
    }
}

- (NSString *)formatter:(NSInteger)toFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:toFormat];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    return formatted;
    
}

@end
