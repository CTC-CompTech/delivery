//
//  Options.m
//  Delivery
//
//  Created by Andrew Robinson on 2/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Options.h"

@implementation Options

#pragma mark - Buttons

- (void)back {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
}

@end
