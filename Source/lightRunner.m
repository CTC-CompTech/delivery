//
//  lightRunner.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "lightRunner.h"

@implementation lightRunner

-(id)init{
    if (self = [super init]){
        self.carType = @"lightRunner";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Light Runner.png"])){
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
