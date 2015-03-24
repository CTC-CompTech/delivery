//
//  sportsCar.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "sportsCar.h"

#define JEEP_ABILITY_DURATION 5.0f
#define JEEP_ABILITY_COOLDOWN 5.0f

@interface sportsCar ()

@property (nonatomic) double preAbilitySpeed;

@property (nonatomic, weak) CCParticleSystem* particleEffect;

@property (nonatomic, weak) CCNode* abilityButton;

@property (nonatomic, weak) CCLabelTTF* countdownTimer;

@end


@implementation sportsCar

#pragma mark - init

-(id)init{
    if (self = [super init]){
        self.carType = @"sportsCar";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Sports Car.png"])){
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
    [self.parentVehicle.scene addChild:[CCBReader load:@"Sports Car Overlay" owner:self]];
    self.particleEffect.visible = false;
    [self.particleEffect removeFromParentAndCleanup:NO];
    [self.parentVehicle addChild:self.particleEffect];
}

-(void)useAbility{
    if (self.canUseAbility){
        self.preAbilitySpeed = self.vehicleSpeed;
        self.abilityCooldown = JEEP_ABILITY_COOLDOWN;
        self.abilityTimeout = JEEP_ABILITY_DURATION;
        self.vehicleSpeed = self.preAbilitySpeed*3;
        [self.particleEffect resetSystem];
        self.particleEffect.visible = true;
        self.parentVehicle.physicsBody.collisionType = @"ability";
        
        self.canUseAbility = false;
    }
}

-(void)abilityUpdate:(CCTime)delta{
    if (!self.canUseAbility){
        
        if (self.abilityTimeout == JEEP_ABILITY_DURATION){ // Do when the ability first starts
            self.abilityButton.visible = false;
        }
        
        if ((self.abilityTimeout >= 1.5) && ((self.abilityTimeout - delta) < 1.5)){// Do when 1 seconds are remaining on the ability
            self.vehicleSpeed = self.preAbilitySpeed;
            [self.particleEffect stopSystem];
        }
        
        if (self.abilityTimeout >= 0){ // Do while the ability is running
            self.abilityTimeout -= delta;
        }
        
        
        else if (self.abilityCooldown >= 0){ // Do while the ability is cooling down
            
            if ((self.abilityTimeout <= 0) && (self.abilityCooldown == JEEP_ABILITY_COOLDOWN)){ // Do when the ability first cools down
                self.countdownTimer.visible = true;
                self.countdownTimer.string = [NSString stringWithFormat:@"%i", (int)self.abilityCooldown];
                self.particleEffect.visible = false;
                self.parentVehicle.physicsBody.collisionType = @"hero";
            }
            self.countdownTimer.string = [NSString stringWithFormat:@"%i", (int)self.abilityCooldown];
            self.abilityCooldown -= delta;
        }
        
        else { // Do on ability reset
            self.countdownTimer.visible = false;
            self.abilityButton.visible = true;
            self.canUseAbility = true;
        }
        
        
    }}

-(void)onPause{
    [super onPause];
    [self.abilityOverlay setVisible:false];
    self.particleEffect.paused = true;
}

-(void)onResume{
    [super onResume];
    [self.abilityOverlay setVisible:true];
    self.particleEffect.paused = false;
}

@end
