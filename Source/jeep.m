//
//  jeep.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "jeep.h"
#define JEEP_ABILITY_DURATION 5.0f
#define JEEP_ABILITY_COOLDOWN 5.0f

@interface jeep ()

@property (nonatomic) double preAbilitySpeed;

@end


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

-(void)useAbility{
    if (self.canUseAbility){
        self.abilityCooldown = JEEP_ABILITY_COOLDOWN;
        self.abilityTimeout = JEEP_ABILITY_DURATION;
        self.vehicleSpeed = 300.0f;
        // Set visibility of particle systems here.
        
        self.canUseAbility = false;
    }
}

-(void)abilityUpdate:(CCTime)delta parentPointer:(CCNode *)realVehicle{
    if (!self.canUseAbility){
        self.abilityTimeout -= delta;
        
        if (self.abilityTimeout <= 0){
            self.vehicleSpeed = self.preAbilitySpeed;
            // Set visibility of particle systems here.
            if (self.abilityCooldown > 0){
                self.abilityCooldown -= delta;
            }
            else {self.canUseAbility = true;}
            
            
        }
}}


@end
