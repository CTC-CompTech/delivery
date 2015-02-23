//
//  policeCar.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "policeCar.h"
#import "vehicleProxy.h"

@implementation policeCar

#pragma mark - init

-(id)init{
    if (self = [super init]){
        self.carType = @"policeCar";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Police Car.png"])){
            NSLog(@"Broken Image!!!");
            return nil;
        }
        else
            return self;
        
        
    }
    else
        return nil;
}

-(void)setupVehicle{
    [self.parentVehicle.scene addChild:[CCBReader load:@"Police Car Overlay" owner:self]];
    [self.redLight removeFromParentAndCleanup:NO];
    [self.blueLight removeFromParentAndCleanup:NO];
    [self.parentVehicle addChild:self.redLight];
    [self.parentVehicle addChild:self.blueLight];
    vehicleProxy* tempParent = (vehicleProxy*)self.parentVehicle;
    [tempParent.lifeMeter setLifes:1];
    tempParent.physicsBody.collisionType = @"policeCar";
}

@end
