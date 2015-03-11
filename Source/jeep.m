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
#define JEEP_MAX_SCALE 3.0f
#define JEEP_ABILITY_JUMP_TIME 3.5f

@interface jeep ()

@property (nonatomic) double preAbilitySpeed;

@property (nonatomic, weak) CCNode* abilityButton;

@property (nonatomic, weak) CCLabelTTF* countdownTimer;

@property (nonatomic) double preAbilityScale;

@property (nonatomic) double abilityStatus;

@end


@implementation jeep

#pragma mark - init

-(id)init{
    if (self = [super init]){
        self.carType = @"jeep";
        self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Jeep.png"];
    
    
    
        return self;
    }
        else return nil;
}

-(void)setupVehicle{
    [self.parentVehicle.scene addChild:[CCBReader load:@"Jeep Overlay" owner:self]];
    self.preAbilityScale = self.parentVehicle.scale;
}

#pragma mark - Ability

-(void)useAbility{
    if (self.canUseAbility){
        self.preAbilitySpeed = self.vehicleSpeed;
        self.abilityCooldown = JEEP_ABILITY_COOLDOWN;
        self.abilityTimeout = JEEP_ABILITY_DURATION;
        self.vehicleSpeed = 500.0f;
        self.parentVehicle.physicsBody.collisionType = @"ability";
        self.abilityStatus = 0;
        self.abilityButton.visible = false;
        self.canUseAbility = false;
    }
}

-(void)abilityUpdate:(CCTime)delta{
    if (!self.canUseAbility){
        
        if ((self.abilityTimeout >= 1.5) && ((self.abilityTimeout - delta) < 1.5)){// Do when 1.5 seconds are remaining on the ability
            CCPhysicsBody* tempBody = self.parentVehicle.physicsBody;
            self.parentVehicle.physicsBody = nil;
            self.vehicleSpeed = self.preAbilitySpeed;
            self.parentVehicle.scale = self.preAbilityScale;
            self.parentVehicle.physicsBody = tempBody;
        }
        
        if (self.abilityTimeout >= 0){ // Do while the ability is running;
            self.abilityStatus += delta * JEEP_ABILITY_JUMP_TIME * (M_2_PI / JEEP_ABILITY_JUMP_TIME);
            CCPhysicsBody* tempBody = self.parentVehicle.physicsBody;
            self.parentVehicle.physicsBody = nil;
            self.parentVehicle.scale = self.preAbilityScale + (self.preAbilityScale * (JEEP_MAX_SCALE - 1) * sin(self.abilityStatus));
            self.parentVehicle.physicsBody = tempBody;
            self.abilityTimeout -= delta;
        }
        
        
        else if (self.abilityCooldown >= 0){ // Do while the ability is cooling down
            
            if ((self.abilityTimeout <= 0) && (self.abilityCooldown == JEEP_ABILITY_COOLDOWN)){ // Do when the ability first cools down
                self.countdownTimer.visible = true;
                self.countdownTimer.string = [NSString stringWithFormat:@"%i", (int)self.abilityCooldown];
                self.parentVehicle.physicsBody.collisionType = @"hero";
                CCPhysicsBody* tempBody = self.parentVehicle.physicsBody;
                self.parentVehicle.physicsBody = nil;
                self.vehicleSpeed = self.preAbilitySpeed;
                self.parentVehicle.scale = self.preAbilityScale;
                self.parentVehicle.physicsBody = tempBody;
            }
            self.countdownTimer.string = [NSString stringWithFormat:@"%i", (int)self.abilityCooldown];
            self.abilityCooldown -= delta;
        }
        
        else { // Do on ability reset
            self.canUseAbility = true;
            self.countdownTimer.visible = false;
            self.abilityButton.visible = true;
        }
        
        
}}

#pragma mark - Runtime

-(void)onPause{
    [super onPause];
    [self.abilityOverlay setVisible:false];
}

-(void)onResume{
    [super onResume];
    [self.abilityOverlay setVisible:true];
}

@end
