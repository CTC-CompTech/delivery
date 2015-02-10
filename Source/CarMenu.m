//
//  CarMenu.m
//  Delivery
//
//  Created by Michael Blades on 1/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CarMenu.h"
#import "Stats.h"

static const CGFloat scrollSpeed = 150.f;

@implementation CarMenu {
    CCButton *_backCar;
    
    CCNode *_ground1;
    CCNode *_ground2;
    
    CCNode *_hero;
    
    CCLabelTTF *_carTitle;
    
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
    
    _hero.position = ccp(_hero.position.x + (scrollSpeed * delta), _hero.position.y);
    
    for (CCNode *ground in _grounds){
        ground.position = ccp((ground.position.x + (-scrollSpeed * delta)), ground.position.y);
        if (ground.position.x <= (-ground.boundingBox.size.width)){
            ground.position = ccp(ground.scene.boundingBox.size.width, ground.position.y);
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
