//
//  lightRunner.m
//  Delivery
//
//  Created by Grant Jennings on 1/17/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "lightRunner.h"
#import "runnerRocket.h"

@interface lightRunner ()

@property (nonatomic) unsigned int useCount;

@property (nonatomic, weak) runnerRocket* rocket;

@property (nonatomic, weak) CCNode* abilityButton;

@end


@implementation lightRunner

-(id)init{
    if (self = [super init]){
        self.carType = @"lightRunner";
        if ( !(self.carFrame = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Light Runner.png"])){
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
    [self.parentVehicle.scene addChild:[CCBReader load:@"Light Runner Overlay" owner:self]];
    self.rocket.visible = false;
    [self.rocket removeFromParentAndCleanup:NO];
    self.useCount = 3;
}


-(void)useAbility{
    if (self.useCount > 0){
        runnerRocket* tempSprite = [runnerRocket spriteWithTexture:self.rocket.texture rect:self.rocket.textureRect];
        tempSprite.position = self.parentVehicle.position;
        tempSprite.movementSpeed = self.vehicleSpeed + 300.0;
        tempSprite.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:10 andCenter:ccp(tempSprite.textureRect.size.width/2.0,tempSprite.textureRect.size.height/2.0)];
        tempSprite.physicsBody.type = CCPhysicsBodyTypeStatic;
        tempSprite.physicsBody.collisionGroup = @0x01;
        tempSprite.physicsBody.collisionType = @"rocket";
        [self.parentVehicle.physicsNode addChild:tempSprite];
        self.useCount--;
    }
    
    if (self.useCount == 0) {
        self.abilityButton.visible = FALSE;
    }
}

-(void)onPause{
    self.abilityButton.visible = false;
}

-(void)onResume{
    self.abilityButton.visible = true;
}


@end
