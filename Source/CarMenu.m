//
//  CarMenu.m
//  Delivery
//
//  Created by Michael Blades on 1/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CarMenu.h"
#import "Stats.h"

@implementation CarMenu {
    CCButton *_backCar;
    
    // TEMP
    CCButton *_addBtn;
    CCButton *_clear;
    // TEMP
}

- (void)clear {
    [Stats instance].ownedCars = [[NSMutableArray alloc] init];
    [[Stats instance].ownedCars addObject:@"DeliveryTruck"];
    NSLog(@"%@", [Stats instance].ownedCars);
}

- (void)addBtn {
    NSLog(@"%@", [Stats instance].ownedCars);
    [Stats instance].currentCoin = [NSNumber numberWithInteger:[[Stats instance].currentCoin integerValue] + 5000];
}

- (void)BackMenu {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.5]];
}

@end
