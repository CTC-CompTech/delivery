//
//  whiteTruck.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "whiteTruck.h"

@implementation whiteTruck

-(id)init{
    if (self = [super init]){
        self.carType = @"whiteTruck";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Truck.png"])){
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
