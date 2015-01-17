//
//  jeep.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "jeep.h"

@implementation jeep

-(id)init{
    if (self = [super init]){
        self.carType = @"jeep";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Jeep.png"])){
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
