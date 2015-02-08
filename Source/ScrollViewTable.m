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
        
        if ([grabbedCar isEqual: @"Pickup Truck"]) {
            _PTLock.visible = FALSE;
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
    } else {
        self.amountToTakeOut = 5000;
        self.carTouched = @"Pickup Truck";
        [self displayAlertWithAmount:@"5000"];
    }
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

- (BOOL)doesUserOwnCar:(NSString *)car {
    
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        if (car == grabbedCar) {
            return TRUE;
        } else {
            return FALSE;
        }
    }
    
    return FALSE;
}

- (void)displayAlertWithAmount:(NSString*)amount {
    
#if __CC_PLATFORM_IOS
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buy Car?"
                                                    message:[NSString stringWithFormat:@"Would you like to buy this car for %@ coins?", amount]
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
    // the user clicked one of the OK/Cancel buttons
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
            
            if ([self.carTouched isEqual: @"Pickup Truck"]) {
                _PTLock.visible = FALSE;
                [[Stats instance].ownedCars addObject:@"Pickup Truck"];
                NSLog(@"%@", [Stats instance].ownedCars);
            }
            
        }
        
    } else {
        NSLog(@"cancel");
    }
}

@end
