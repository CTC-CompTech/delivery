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
#import "Alert.h"

@interface ScrollViewTable ()

@end

static ScrollViewTable *inst = nil;

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
    
    CCNode *_fadeBackground;
    
}

+ (ScrollViewTable*)instance {
    if (!inst) {
        inst = [[ScrollViewTable alloc] init];
    }
    return inst;
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
        
        self.locks = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)onEnter {
    [super onEnter];
    
    if ([[ScrollViewTable instance].locks count] == 0) {
        [[ScrollViewTable instance].locks addObject:_PTLock];
        [[ScrollViewTable instance].locks addObject:_JLock];
        [[ScrollViewTable instance].locks addObject:_PLock];
        [[ScrollViewTable instance].locks addObject:_LRLock];
        [[ScrollViewTable instance].locks addObject:_SLock];
    } else {
        [[ScrollViewTable instance].locks replaceObjectAtIndex:0 withObject:_PTLock];
        [[ScrollViewTable instance].locks replaceObjectAtIndex:1 withObject:_JLock];
        [[ScrollViewTable instance].locks replaceObjectAtIndex:2 withObject:_PLock];
        [[ScrollViewTable instance].locks replaceObjectAtIndex:3 withObject:_LRLock];
        [[ScrollViewTable instance].locks replaceObjectAtIndex:4 withObject:_SLock];
    }
    
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
    
    if ([[Stats instance].whereTutorial isEqual:@"CarMenu"]) {
        
        // Disabling buttons so they can only tap pick truck
        _deliveryTruck.enabled = NO;
        _jeep.enabled = NO;
        _policeCar.enabled = NO;
        _lightRunner.enabled = NO;
        _sportsCar.enabled = NO;
        
    }
    
}

#pragma mark - Scroll buttons

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
        [ScrollViewTable instance].amountToTakeOut = 5000;
        [ScrollViewTable instance].carTouched = @"Pickup Truck";
        [self displayAlertWithAmount:[ScrollViewTable instance].amountToTakeOut];
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
        [ScrollViewTable instance].amountToTakeOut = 10000;
        [ScrollViewTable instance].carTouched = @"Jeep";
        [self displayAlertWithAmount:[ScrollViewTable instance].amountToTakeOut];
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
        [ScrollViewTable instance].amountToTakeOut = 20000;
        [ScrollViewTable instance].carTouched = @"Police Car";
        [self displayAlertWithAmount:[ScrollViewTable instance].amountToTakeOut];
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
        [ScrollViewTable instance].amountToTakeOut = 50000;
        [ScrollViewTable instance].carTouched = @"Light Runner";
        [self displayAlertWithAmount:[ScrollViewTable instance].amountToTakeOut];
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
        [ScrollViewTable instance].amountToTakeOut = 100000;
        [ScrollViewTable instance].carTouched = @"Sports Car";
        [self displayAlertWithAmount:[ScrollViewTable instance].amountToTakeOut];
    }
}

#pragma mark - Car check

- (BOOL)doesUserOwnCar:(NSString *)car {
    
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        if ([car isEqualToString: grabbedCar]) {
            return TRUE;
        }
    }
    
    return FALSE;
}

#pragma mark - Alert

- (void)displayAlertWithAmount:(NSInteger)amount {
    
    CCActionFadeIn *fadeBack = [CCActionFadeIn actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
    
    // Run to seperate Alert screen
    Alert *alert = (Alert *)[CCBReader load:@"Alert"];
    [alert runAlertWithAmount:amount];
    [self.parent.parent addChild:alert];
    
    
//#if __CC_PLATFORM_IOS
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Buy Car?"
//                                                    message:[NSString stringWithFormat:@"Would you like to buy this car for %@ coins?", formattedAmount]
//                                                   delegate:self
//                                          cancelButtonTitle:@"No"
//                                          otherButtonTitles:@"Yes, please", nil];
//    [alert show];
//#endif
    
//#if __CC_PLATFORM_ANDROID
//    dispatch_async(dispatch_get_main_queue(), ^{
//        AndroidAlertDialogBuilder *alert = [[AndroidAlertDialogBuilder alloc] initWithContext:[CCActivity currentActivity]
//                                                                                        theme:AndroidAlertDialogThemeHoloDark];
//        [alert setTitleByCharSequence:@:@"Buy Car?"];
//        [alert show];
//    });
//#endif
    
}

- (void)didWantToBuy {
    
    if ([ScrollViewTable instance].amountToTakeOut > [[Stats instance].currentCoin integerValue]) {
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
//                                                        message:@"You do not have enough coins to buy this car."
//                                                       delegate:nil
//                                              cancelButtonTitle:@"Okay, sorry."
//                                              otherButtonTitles:nil];
//        [alert show];
        
        // Run to seperate Alert screen
        Alert *alert = (Alert *)[CCBReader load:@"Alert"];
        [alert runOkayAlertScrollView];
        
        // Get scenes
        CCScene* runningScene = [CCDirector sharedDirector].runningScene;
        
        // Children of Menu - Index of 0 will always be Menu
        CCNode *carMenu = [runningScene.children objectAtIndex:0];
        
        [carMenu addChild:alert];
        
        // Doesn't work - Parent is nil
//        [self.parent.parent addChild:alert];
        
    } else {
        
        NSInteger currentCoin = [[Stats instance].currentCoin integerValue];
        [Stats instance].currentCoin = [NSNumber numberWithInteger:currentCoin - [ScrollViewTable instance].amountToTakeOut];
        
        CCNode *lock;
        
        NSInteger carEnum = 0;
        if ([[ScrollViewTable instance].carTouched isEqual: @"Pickup Truck"]) {
            lock = [[ScrollViewTable instance].locks objectAtIndex:0];
            lock.visible = FALSE;
            carEnum = pickupTruckEnum;
        }
        if ([[ScrollViewTable instance].carTouched isEqual: @"Jeep"]) {
            lock = [[ScrollViewTable instance].locks objectAtIndex:1];
            lock.visible = FALSE;
            carEnum = jeepEnum;
        }
        if ([[ScrollViewTable instance].carTouched isEqual: @"Police Car"]) {
            lock = [[ScrollViewTable instance].locks objectAtIndex:2];
            lock.visible = FALSE;
            carEnum = policeCarEnum;
        }
        if ([[ScrollViewTable instance].carTouched isEqual: @"Light Runner"]) {
            lock = [[ScrollViewTable instance].locks objectAtIndex:3];
            lock.visible = FALSE;
            carEnum = lightRunnerEnum;
        }
        if ([[ScrollViewTable instance].carTouched isEqual: @"Sports Car"]) {
            lock = [[ScrollViewTable instance].locks objectAtIndex:4];
            lock.visible = FALSE;
            carEnum = sportsCarEnum;
        }
        
        [[Stats instance].ownedCars addObject:[ScrollViewTable instance].carTouched];
        
        [CarMenu instance].titleCar = [ScrollViewTable instance].carTouched;
        
        NSString *selectedCar = [NSString stringWithFormat:@"Delivery/Heros/%@.png", [ScrollViewTable instance].carTouched];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:selectedCar forKey:@"selectedCar"];
        [defaults setInteger:carEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
        
        [self performSelector:@selector(didSet) withObject:nil];
    }
    
}

//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//
//    if (buttonIndex == 1) {
//
//        if (self.amountToTakeOut > [[Stats instance].currentCoin integerValue]) {
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oh no!"
//                                                            message:@"You do not have enough coins to buy this car."
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Okay, sorry."
//                                                  otherButtonTitles:nil];
//            [alert show];
//            
//        } else {
//            
//            NSInteger currentCoin = [[Stats instance].currentCoin integerValue];
//            [Stats instance].currentCoin = [NSNumber numberWithInteger:currentCoin - self.amountToTakeOut];
//            
//            NSInteger carEnum;
//            if ([self.carTouched isEqual: @"Pickup Truck"]) {
//                _PTLock.visible = FALSE;
//                carEnum = pickupTruckEnum;
//            }
//            if ([self.carTouched isEqual: @"Jeep"]) {
//                _JLock.visible = FALSE;
//                carEnum = jeepEnum;
//            }
//            if ([self.carTouched isEqual: @"Police Car"]) {
//                _PLock.visible = FALSE;
//                carEnum = policeCarEnum;
//            }
//            if ([self.carTouched isEqual: @"Light Runner"]) {
//                _LRLock.visible = FALSE;
//                carEnum = lightRunnerEnum;
//            }
//            if ([self.carTouched isEqual: @"Sports Car"]) {
//                _SLock.visible = FALSE;
//                carEnum = sportsCarEnum;
//            }
//            
//            [[Stats instance].ownedCars addObject:self.carTouched];
//            [CarMenu instance].titleCar = self.carTouched;
//            
//            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            [defaults setObject:self.carTouched forKey:@"selectedCar"];
//            [defaults setInteger:carEnum forKey:@"vehicleIndex"];
//            [defaults synchronize];
//            
//            [self performSelector:@selector(didSet) withObject:nil];
//            
//        }
//        
//    } else {
//        return;
//    }
//}

#pragma mark - End methods

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


@end
