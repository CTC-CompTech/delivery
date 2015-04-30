//
//  Stats.m
//  Delivery
//
//  Created by Andrew Robinson on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Stats.h"

static Stats *inst = nil;

@implementation Stats

- (id)init {
    if(self=[super init]) {
        self.obstacleCount = 0;
        self.ownedCars = [[NSMutableArray alloc] init];
        self.shouldTutorial = YES;
        self.isTutorial = NO;
    }
    return self;
}

+ (Stats*)instance {
    if (!inst) {
        inst = [[Stats alloc] init];
    }
    return inst;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_currentCoin forKey:@"currentCoin"];
    [coder encodeObject:_totalCoin forKey:@"totalCoin"];
    [coder encodeObject:_collision forKey:@"collisions"];
    [coder encodeObject:_gameRuns forKey:@"gameRuns"];
    [coder encodeObject:_loginDate forKey:@"loginDate"];
    [coder encodeObject:_bestCoin forKey:@"bestCoin"];
    
    [coder encodeObject:_ownedCars forKey:@"ownedCars"];
    
    [coder encodeBool:_shouldTutorial forKey:@"shouldTutorial"];
    [coder encodeBool:_isTutorial forKey:@"isTutorial"];

}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _currentCoin = [coder decodeObjectForKey:@"currentCoin"];
        _totalCoin = [coder decodeObjectForKey:@"totalCoin"];
        _collision = [coder decodeObjectForKey:@"collisions"];
        _gameRuns = [coder decodeObjectForKey:@"gameRuns"];
        _loginDate = [coder decodeObjectForKey:@"loginDate"];
        _bestCoin = [coder decodeObjectForKey:@"bestCoin"];
        
        _ownedCars = [coder decodeObjectForKey:@"ownedCars"];
        
        _shouldTutorial = [coder decodeBoolForKey:@"shouldTutorial"];
        _isTutorial = [coder decodeBoolForKey:@"isTutorial"];
        
    }
    return self;
}



@end
