//
//  StatsNode.m
//  Delivery
//
//  Created by Andrew Robinson on 2/28/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "StatsNode.h"

@implementation StatsNode

- (void)back {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
}

@end
