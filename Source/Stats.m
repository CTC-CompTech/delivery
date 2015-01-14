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
    }
    return self;
}

+ (Stats*)instance {
    if (!inst) {
        inst = [[Stats alloc] init];
    }
    return inst;
}


@end
