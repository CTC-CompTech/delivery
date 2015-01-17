//
//  policeCar.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "policeCar.h"

@implementation policeCar

-(id)init{
    if (self = [super init]){
        self.carType = @"policeCar";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Police Car.png"])){
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
