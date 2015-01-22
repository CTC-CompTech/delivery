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

@property (nonatomic, retain) CCParticleSystem* particleEffect;

@end


@implementation jeep

-(id)init{
    if (self = [super init]){
        self.carType = @"jeep";
        self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Jeep.png"];
    
    
    
        return self;
    }
        else return nil;
}

-(void)setupVehicle{
    [self.parentVehicle.scene addChild:[CCBReader load:@"Jeep Overlay" owner:self]];
    self.particleEffect.visible = false;
    [self.particleEffect removeFromParentAndCleanup:NO];
    [self.parentVehicle addChild:self.particleEffect];
    self.particleEffect.position = ccp(self.parentVehicle.boundingBox.size.width / 2.0, self.parentVehicle.boundingBox.size.height / 2.0);
}

-(void)useAbility{
    if (self.canUseAbility){
        self.abilityCooldown = JEEP_ABILITY_COOLDOWN;
        self.abilityTimeout = JEEP_ABILITY_DURATION;
        self.vehicleSpeed = 300.0f;
        [self.particleEffect resetSystem];
        self.particleEffect.visible = true;
        self.parentVehicle.physicsBody.collisionType = @"ability";
        
        self.canUseAbility = false;
    }
}

-(void)abilityUpdate:(CCTime)delta parentPointer:(CCNode *)realVehicle{
    if (!self.canUseAbility){
        
        if (self.abilityTimeout >= 0){ // Do while the ability is running
            self.abilityTimeout -= delta;
        }
        
        else if (self.abilityCooldown >= 0){ // Do while the ability is cooling down
            self.abilityCooldown -= delta;
        }
        
        else { // Do on ability reset
            
            self.particleEffect.visible = false;
            self.parentVehicle.physicsBody.collisionType = @"hero";
            self.canUseAbility = true;
        }
        
        
}}


@end
