//
//  Credits.m
//  Delivery
//
//  Created by Michael Blades on 2/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credits.h"

@implementation Credits

- (void)BackMenu {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:.5]];
}

-(void)SecretGame {
    NSLog(@"HI");
}

@end
