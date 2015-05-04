//
//  Stats.h
//  Delivery
//
//  Created by Andrew Robinson on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stats : NSObject

@property (retain, nonatomic) NSNumber *obstacleCount;
@property (retain, nonatomic) NSNumber *level;
@property (retain, nonatomic) NSNumber *obstacleDistance;
@property (retain, nonatomic) NSMutableArray *lasts;

@property (retain, nonatomic) NSMutableArray *ownedCars;

@property (retain, nonatomic) NSNumber *currentCoin;
@property (retain, nonatomic) NSNumber *bestCoin;

@property (retain, nonatomic) NSNumber *totalCoin;
@property (retain, nonatomic) NSNumber *collision;
@property (retain, nonatomic) NSNumber *gameRuns;

@property (retain, nonatomic) NSDate *loginDate;

@property BOOL abilityUse;

@property BOOL shouldTutorial;
@property (retain, nonatomic) NSString *whereTutorial;

-(id)init;
+(Stats*)instance;

@end
