//
//  ScrollViewTable.m
//  Delivery
//
//  Created by Michael Blades on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "ScrollViewTable.h"
#import "Stats.h"
#import "CarMenu.h"

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

- (id)init {
    if(self=[super init]) {
        // Set title
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger carInteger = [defaults integerForKey:@"vehicleIndex"];
        
        NSString *carTitle;
        if (carInteger == 0 || 1) {
            carTitle = @"Delivery Truck";
        }
        if (carInteger == 2) {
            carTitle = @"Sports Car";
        }
        if (carInteger == 3) {
            carTitle = @"Police Car";
        }
        if (carInteger == 4) {
            carTitle = @"Pickup Truck";
        }
        if (carInteger == 5) {
            carTitle = @"Light Runner";
        }
        if (carInteger == 6) {
            carTitle = @"Jeep";
        }
        
        [CarMenu instance].titleCar = carTitle;
    }
    return self;
}

- (void)onEnter {
    [super onEnter];
    
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        
        if ([grabbedCar isEqual: @"Pickup Truck"]) {
            _PTLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"Jeep"]) {
            _JLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"Police Car"]) {
            _PLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"Light Runner"]) {
            _LRLock.visible = FALSE;
        }
        if ([grabbedCar isEqual: @"Sports Car"]) {
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
    
    [self performSelector:@selector(didSet) withObject:nil];
    
    [CarMenu instance].titleCar = @"Delivery Truck";
}

- (void)pickupTruck {
    
    BOOL doesOwn = [self doesUserOwnCar:@"Pickup Truck"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Pickup Truck.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:pickupTruckEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
        
        [self performSelector:@selector(didSet) withObject:nil];
        
        [CarMenu instance].titleCar = @"Pickup Truck";
        
    } else {
        self.amountToTakeOut = 5000;
        self.carTouched = @"Pickup Truck";
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
        
        [self performSelector:@selector(didSet) withObject:nil];
        
        [CarMenu instance].titleCar = @"Jeep";
        
    } else {
        self.amountToTakeOut = 10000;
        self.carTouched = @"Jeep";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)policeCar {
    
    BOOL doesOwn = [self doesUserOwnCar:@"Police Car"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Police Car.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:policeCarEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
        
        [self performSelector:@selector(didSet) withObject:nil];
        
        [CarMenu instance].titleCar = @"Police Car";
        
    } else {
        self.amountToTakeOut = 20000;
        self.carTouched = @"Police Car";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)lightRunner {
    
    BOOL doesOwn = [self doesUserOwnCar:@"Light Runner"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Light Runner.png";
         
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:lightRunnerEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
        
        [self performSelector:@selector(didSet) withObject:nil];
        
        [CarMenu instance].titleCar = @"Light Runner";
        
    } else {
        self.amountToTakeOut = 50000;
        self.carTouched = @"Light Runner";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (void)sportsCar {
    
    BOOL doesOwn = [self doesUserOwnCar:@"Sports Car"];
    
    if (doesOwn == TRUE) {
        NSString *selectedCar = @"Delivery/Heros/Sports Car.png";
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:sportsCarEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
        
        [self performSelector:@selector(didSet) withObject:nil];
        
        [CarMenu instance].titleCar = @"Sports Car";
        
    } else {
        self.amountToTakeOut = 100000;
        self.carTouched = @"Sports Car";
        [self displayAlertWithAmount:self.amountToTakeOut];
    }
}

- (BOOL)doesUserOwnCar:(NSString *)car {
    
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        if ([car isEqualToString: grabbedCar]) {
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
            
            NSInteger carEnum;
            if ([self.carTouched isEqual: @"Pickup Truck"]) {
                _PTLock.visible = FALSE;
                carEnum = pickupTruckEnum;
            }
            if ([self.carTouched isEqual: @"Jeep"]) {
                _JLock.visible = FALSE;
                carEnum = jeepEnum;
            }
            if ([self.carTouched isEqual: @"Police Car"]) {
                _PLock.visible = FALSE;
                carEnum = policeCarEnum;
            }
            if ([self.carTouched isEqual: @"Light Runner"]) {
                _LRLock.visible = FALSE;
                carEnum = lightRunnerEnum;
            }
            if ([self.carTouched isEqual: @"Sports Car"]) {
                _SLock.visible = FALSE;
                carEnum = sportsCarEnum;
            }
            
            [[Stats instance].ownedCars addObject:self.carTouched];
            [CarMenu instance].titleCar = self.carTouched;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:self.carTouched forKey:@"selectedCar"];
            [defaults setInteger:carEnum forKey:@"vehicleIndex"];
            [defaults synchronize];
            
            [self performSelector:@selector(didSet) withObject:nil];
            
        }
        
    } else {
        return;
    }
}

- (void)didSet {
    
    if ([CarMenu instance].didPressWhileMoving == NO) {
        if ([CarMenu instance].isMoving == NO) {
            [CarMenu instance].shouldMove = YES;
            [self performSelector:@selector(endSet) withObject:nil afterDelay:1.5f];
        } else {
            [CarMenu instance].didPressWhileMoving = YES;
        }
    }
    
}

- (void)endSet {
    [CarMenu instance].shouldMove = NO;
}

- (NSString *)formatter:(NSInteger)toFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:toFormat];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    return formatted;
    
}

@end
