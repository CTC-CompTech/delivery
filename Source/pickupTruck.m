//
//  pickupTruck.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "pickupTruck.h"

#define PICKUP_TRUCK_ABILITY_DURATION 5.0f
#define PICKUP_TRUCK_ABILITY_COOLDOWN 5.0f

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

-(void)setupVehicle{
    [self.parentVehicle.scene addChild:[CCBReader load:@"Pickup Truck Overlay" owner:self]];
}

-(void)useAbility{
    if (self.canUseAbility){
        self.preAbilitySpeed = self.vehicleSpeed;
        self.abilityCooldown = PICKUP_TRUCK_ABILITY_COOLDOWN;
        self.abilityTimeout = PICKUP_TRUCK_ABILITY_DURATION;
        self.vehicleSpeed = self.preAbilitySpeed/1.5;
        self.canUseAbility = false;
        
        if ([[Stats instance].whereTutorial isEqual:@"SuperPower"]) {
            
            // Resume
            [self onResume];
            
            [Stats instance].whereTutorial = @"Swipe";
            
            // Get scenes
            CCScene* runningScene = [CCDirector sharedDirector].runningScene;
            
            // Children of Menu - Index of 0 will always be Menu
            NSArray *array = [[runningScene.children objectAtIndex:0] children];
            
            for (CCNode *node in array) {
                if ([node.name isEqual:@"tutorial"]) {
                    node.visible = NO;
                }
                
            }
            
            [self performSelector:@selector(swipeTutorial) withObject:nil afterDelay:1.0];
            
        }
    }
}

- (void)swipeTutorial {
    
    [self onPause];
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    for (CCNode *node in array) {
        if ([node.name isEqual:@"tutorialSwipe"]) {
            node.visible = YES;
        }
        
    }
    
}

-(void)abilityUpdate:(CCTime)delta{
    if (!self.canUseAbility){
        
        if (self.abilityTimeout == PICKUP_TRUCK_ABILITY_DURATION){ // Do when the ability first starts
            self.abilityButton.visible = false;
        }
        
        if (self.abilityTimeout >= 0){ // Do while the ability is running
            self.abilityTimeout -= delta;
        }
        
        
        else if (self.abilityCooldown >= 0){ // Do while the ability is cooling down
            
            if ((self.abilityTimeout <= 0) && (self.abilityCooldown == PICKUP_TRUCK_ABILITY_COOLDOWN)){ // Do when the ability first cools down
                self.countdownTimer.visible = true;
                self.countdownTimer.string = [NSString stringWithFormat:@"%i", (int)self.abilityCooldown];
                self.vehicleSpeed = self.preAbilitySpeed;
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
    
    if (![[Stats instance].whereTutorial isEqual:@"SuperPower"]) {
        self.abilityButton.visible = false;
    }
    
    self.countdownTimer.visible = false;
}

-(void)onResume{
    [super onResume];
    [self.abilityOverlay setVisible:true];
//    self.abilityButton.visible = true;
    if ([[Stats instance].whereTutorial isEqual:@"SuperPower"] || [[Stats instance].whereTutorial isEqual:@"Swipe"])
        self.countdownTimer.visible = false;
    else
        self.countdownTimer.visible = true;
    
    if ([[Stats instance].whereTutorial isEqual:@"Swipe"])
        self.abilityButton.visible = false;
    else
        self.abilityButton.visible = true;
}



@end
