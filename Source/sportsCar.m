//
//  sportsCar.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "sportsCar.h"

@implementation sportsCar

-(id)init{
    if (self = [super init]){
        self.carType = @"sportsCar";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Sports Car.png"])){
            NSLog(@"Broken Image!!!");
            return nil;
        }
        else
            return self;
        
        
    }
    else
        return nil;
}

@end
