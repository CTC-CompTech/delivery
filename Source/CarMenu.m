//
//  CarMenu.m
//  Delivery
//
//  Created by Michael Blades on 1/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CarMenu.h"

@implementation CarMenu {
    CCButton *_backCar;
}

- (void)BackMenu {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:2]];
}

@end
