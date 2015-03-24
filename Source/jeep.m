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

@property (nonatomic) double abilityStatus;

@property (nonatomic) CCSprite* fakeJeep;

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
    [self.fakeJeep removeFromParentAndCleanup:NO];
    [self.parentVehicle addChild:self.fakeJeep];
    self.fakeJeep.position = ccp(53,33.5);
    self.fakeJeep.visible = false;
}

#pragma mark - Ability

-(void)useAbility{
    if (self.canUseAbility){
        self.preAbilitySpeed = self.vehicleSpeed;
        self.abilityCooldown = JEEP_ABILITY_COOLDOWN;
        self.abilityTimeout = JEEP_ABILITY_DURATION;
        self.vehicleSpeed = 500.0f;
        self.abilityStatus = 0;
        self.fakeJeep.visible = true;
        self.abilityButton.visible = false;
        self.canUseAbility = false;
        self.parentVehicle.physicsBody.collisionType = @"ability";
        self.parentVehicle.physicsBody.sensor = true;
    }
}

-(void)abilityUpdate:(CCTime)delta{
    if (!self.canUseAbility){
        
        if (self.abilityTimeout >= 0){ // Do while the ability is running;
            self.abilityStatus += delta * JEEP_ABILITY_JUMP_TIME * (M_2_PI / JEEP_ABILITY_JUMP_TIME);
            self.fakeJeep.scale = 1 + (self.parentVehicle.scale * (JEEP_MAX_SCALE - 1) * sin(self.abilityStatus));
            if (self.fakeJeep.scale < 1){
                self.fakeJeep.scale = 1;
            }
            self.abilityTimeout -= delta;
        }
        
        
        else if (self.abilityCooldown >= 0){ // Do while the ability is cooling down
            
            if ((self.abilityTimeout <= 0) && (self.abilityCooldown == JEEP_ABILITY_COOLDOWN)){ // Do when the ability first cools down
                self.countdownTimer.visible = true;
                self.fakeJeep.visible = false;
                self.parentVehicle.physicsBody.collisionType = @"hero";
                self.parentVehicle.physicsBody.sensor = false;
                self.countdownTimer.string = [NSString stringWithFormat:@"%i", (int)self.abilityCooldown];
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
    self.abilityButton.visible = false;
    self.countdownTimer.visible = false;
}

-(void)onResume{
    [super onResume];
    [self.abilityOverlay setVisible:true];
    self.abilityButton.visible = true;
    self.countdownTimer.visible = true;
}

@end
