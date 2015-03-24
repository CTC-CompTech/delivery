//
//  StatsNode.m
//  Delivery
//
//  Created by Andrew Robinson on 2/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StatsNode.h"
#import "Stats.h"
#import "Menu.h"

@implementation StatsNode {
    
    CCNode *_statsNode;
    
    CCLabelTTF *_coinCurrent;
    CCLabelTTF *_totalCoin;
    CCLabelTTF *_bestCoin;
    CCLabelTTF *_obstaclesHit;
    CCLabelTTF *_totalRuns;
    
    CCSprite *_pickupTruck;
    CCSprite *_jeep;
    CCSprite *_policeCar;
    CCSprite *_lightRunner;
    CCSprite *_sportsCar;
    
}

#pragma mark - init

- (void)didLoadFromCCB {
    
    // Current coin
    NSString *coin = [self formatter:[[Stats instance].currentCoin integerValue]];
    _coinCurrent.string = coin;
    
    // Total coin
    NSString *totalCoin = [self formatter:[[Stats instance].totalCoin integerValue]];
    _totalCoin.string = totalCoin;
    
    // Best coin
    NSString *bestCoin = [self formatter:[[Stats instance].bestCoin integerValue]];
    _bestCoin.string = bestCoin;
    
    // Obstacles hit
    NSString *obstacles = [self formatter:[[Stats instance].collision integerValue]];
    _obstaclesHit.string = obstacles;
    
    // Total Runs
    NSString *totalRuns = [self formatter:[[Stats instance].gameRuns integerValue]];
    _totalRuns.string = totalRuns;
    
    // Owned cars
    for (NSString *grabbedCar in [Stats instance].ownedCars) {
        
        if ([grabbedCar isEqual: @"Pickup Truck"]) {
            _pickupTruck.opacity = 1;
        }
        if ([grabbedCar isEqual: @"Jeep"]) {
            _jeep.opacity = 1;
        }
        if ([grabbedCar isEqual: @"Police Car"]) {
            _policeCar.opacity = 1;
        }
        if ([grabbedCar isEqual: @"Light Runner"]) {
            _lightRunner.opacity = 1;
        }
        if ([grabbedCar isEqual: @"Sports Car"]) {
            _sportsCar.opacity = 1;
        }
        
    }
    
}

#pragma mark - Helper methods

- (void)runStats {
    _statsNode.position = ccp(480, _statsNode.position.y);
    [self performSelector:@selector(sweepContent) withObject:nil afterDelay:.1];
}

- (void)sweepContent {
    CCActionMoveTo *moveContent = [CCActionMoveTo actionWithDuration:.5 position:ccp(0, _statsNode.position.y)];
    [_statsNode runAction:moveContent];
}

#pragma mark - Buttons

- (void)back {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene
//                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
    
    Menu *mainMenu = (Menu *)[CCBReader load:@"Menu"];
    [mainMenu statsRemove];
}

#pragma mark - Formatter

- (NSString *)formatter:(NSInteger)toFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:toFormat];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    return formatted;
    
}

@end
