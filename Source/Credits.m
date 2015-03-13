//
//  Credits.m
//  Delivery
//
//  Created by Michael Blades on 2/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Credits.h"
#import "Menu.h"

@implementation Credits {
    
    CCNode *_creditsMenu;
    
    CCButton *_backButton;
}

- (void)didLoadFromCCB {
    [_backButton setHitAreaExpansion:40.f];
}

- (void)runCredits {
    _creditsMenu.position = ccp(480, _creditsMenu.position.y);
    [self performSelector:@selector(sweepContent) withObject:nil afterDelay:.1];
}

- (void)sweepContent {
    CCActionMoveTo *moveContent = [CCActionMoveTo actionWithDuration:.5 position:ccp(0, _creditsMenu.position.y)];
    [_creditsMenu runAction:moveContent];
}

/*///////////////////////////////////////////
 *
 * If added or removed nodes in Credits, check the Menu class for changes!
 *
 ///////////////////////////////////////////*/

- (void)BackMenu {
    
    Menu *mainMenu = (Menu *)[CCBReader load:@"Menu"];
    [mainMenu creditsRemove];
    
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Menu"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:.5]];
}

-(void)SecretGame {
    NSLog(@"HI");
}

@end
