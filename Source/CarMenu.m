//
//  CarMenu.m
//  Delivery
//
//  Created by Michael Blades on 1/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CarMenu.h"
#import "Stats.h"

static const CGFloat scrollSpeed = 210.f;

@implementation CarMenu {
    CCButton *_backCar;
    
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    
    NSArray *_grounds;
    
    // TEMP
    CCButton *_addBtn;
    CCButton *_clear;
    // TEMP
}

- (void)didLoadFromCCB {
     _grounds = @[_ground1, _ground2];
}

- (void)update:(CCTime)delta {
    
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    
    // loop the ground
    for (CCNode *ground in _grounds) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.x <= (-1 * ground.contentSize.width)) {
            ground.position = ccp(ground.position.x + 2 * ground.contentSize.width - 1, ground.position.y);
//            NSLog(@"%@", NSStringFromCGPoint(ground.position));
        }
    }
}

- (void)clear {
    [Stats instance].ownedCars = [[NSMutableArray alloc] init];
    [[Stats instance].ownedCars addObject:@"DeliveryTruck"];
    NSLog(@"%@", [Stats instance].ownedCars);
}

- (void)addBtn {
    NSLog(@"%@", [Stats instance].ownedCars);
    [Stats instance].currentCoin = [NSNumber numberWithInteger:[[Stats instance].currentCoin integerValue] + 5000];
}

- (void)BackMenu {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
}

@end
