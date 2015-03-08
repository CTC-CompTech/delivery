//
//  Options.m
//  Delivery
//
//  Created by Andrew Robinson on 2/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Options.h"
#import "Stats.h"
#import "vehicleIncludes.h"

@implementation Options

#pragma mark - Buttons

- (void)back {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
}

- (void)reset {
    [Stats instance].ownedCars = nil;
    [Stats instance].currentCoin = nil;
    
    // Should this be reset?
    [Stats instance].totalCoin = nil;
    
    [Stats instance].gameRuns = nil;
    [Stats instance].collision = nil;
    [Stats instance].bestCoin = nil;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // Set this car as default.
    NSString *defaultCar = @"Delivery/Heros/Truck.png";
    [defaults setObject:defaultCar forKey:@"selectedCar"];
    [defaults setInteger:whiteTruckEnum forKey:@"vehicleIndex"];
    [defaults synchronize];
    
    [self saveCustomObject:[Stats instance] key:@"stats"];
    
}

#pragma mark - Custom Actions

- (void)saveCustomObject:(Stats *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

@end
