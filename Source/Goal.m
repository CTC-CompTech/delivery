//
//  Goal.m
//  Delivery
//
//  Created by Andrew Robinson on 1/10/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Goal.h"

@implementation Goal

- (void)didLoadFromCCB {
    self.physicsBody.collisionType = @"goal";
    self.physicsBody.sensor = TRUE;
}

@end
