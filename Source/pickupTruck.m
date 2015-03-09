//
//  pickupTruck.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "pickupTruck.h"

@interface pickupTruck ()

@property (nonatomic) double preAbilitySpeed;

@property (nonatomic, weak) CCNode* abilityButton;

@property (nonatomic, weak) CCLabelTTF* countdownTimer;

@end

@implementation pickupTruck

#pragma mark - init

-(id)init{
    if (self = [super init]){
        self.carType = @"pickupTruck";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Pickup Truck.png"])){
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
