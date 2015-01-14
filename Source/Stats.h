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

@property (retain, nonatomic) NSNumber *currentCoin;
@property (retain, nonatomic) NSNumber *totalCoin;

@property BOOL abilityUse;

-(id)init;
+(Stats*)instance;

@end
