//
//  Menu.m
//  Delivery
//
//  Created by Andrew Robinson on 1/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Menu.h"
#import "Stats.h"
#import "vehicleIncludes.h"
#import "Credits.h"
#import "StatsNode.h"
#import "Alert.h"
#import "Options.h"

static const CGFloat scrollSpeed = 210.f;

@implementation Menu {
    
    CCPhysicsNode *_physicsNode;
    
    CCLabelTTF *_coinCurrent;
    
    CCLightNode *_redLight;
    CCLightNode *_blueLight;
    
    CCNode *_fadeBackground;
    
    CCButton *_creditsButton;
    CCButton *_optionsButton;
    CCButton *_statsButton;
    CCButton *_heroButton;
    
    CCNode *_ground1;
    CCNode *_ground2;
    
    CCNode *_tutorial;
    
    CCSprite *_hero;
    
    NSArray *_grounds;
    
}

#pragma mark - Load

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
    
    [_creditsButton setHitAreaExpansion:20.f];
    [_optionsButton setHitAreaExpansion:20.f];
    
}

- (void)update:(CCTime)delta {
    
    for (CCNode *ground in _grounds) {
        ground.position = ccp(ground.position.x, (ground.position.y + (-scrollSpeed * delta)));
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.y <= (-1 * ground.contentSize.width + 1100)) { // 552 // 537
            ground.position = ccp(ground.position.x, ground.position.y + 2 + ground.contentSize.height + 511);
        }
    }
//    
//    for (CCNode *ground in _grounds){
//        ground.position = ccp(ground.position.x, (ground.position.y + (-scrollSpeed * delta)));
//        if (ground.position.y <= (-ground.boundingBox.size.height)){
//            ground.position = ccp(ground.position.x, ground.scene.boundingBox.size.height);
//        }
//    }
    
}

- (void)onEnter {
    [super onEnter];
    
    _grounds = @[_ground1, _ground2];
        
    NSInteger currentCoin = [[Stats instance].currentCoin integerValue];
    
    // Format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:currentCoin];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    _coinCurrent.string = [NSString stringWithFormat:@"%@", formatted];
    
    // Set selected car
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *selectedCar = [defaults objectForKey:@"selectedCar"];
    
    // Check if nil, this was crashing the menu for newly installed applications
    if (selectedCar != nil) {
        _hero.spriteFrame = [CCSpriteFrame frameWithImageNamed:selectedCar];
    } else {
        
        // Set this car as default.
        NSString *defaultCar = @"Delivery/Heros/Truck.png";
        [defaults setObject:defaultCar forKey:@"selectedCar"];
        [defaults setInteger:whiteTruckEnum forKey:@"vehicleIndex"];
        [defaults synchronize];
    }
    
    if (_hero.spriteFrame == [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Police Car.png"]) {
        _redLight.visible = YES;
        _blueLight.visible = YES;
    }
    
//    [Stats instance].shouldTutorial = YES;
    
    // Should we try a tutorial?
    if ([Stats instance].shouldTutorial && [[Stats instance].whereTutorial isEqual:@""]) {
        
        // Run to seperate Alert screen
        Alert *alert = (Alert *)[CCBReader load:@"Alert"];
        [alert runAlertTutorial];
        [self addChild:alert];
        
    }
    
}


#pragma mark - Helping methods

- (void)didSayYes {
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    for (CCNode *node in array) {
        if ([node.name isEqual:@"tutorial"]) {
            node.visible = YES;
        }
    }
    
    for (CCButton *button in array) {
        if ([button isKindOfClass:[CCButton class]]) {
            if (![button.name isEqual:@"heroButton"])
                button.enabled = NO;
        }
    }
    
    // Add tutorial coins
    NSInteger currentCoinCount = [[Stats instance].currentCoin integerValue];
    NSInteger totalCoinCount = [[Stats instance].totalCoin integerValue];
    
    NSInteger currentTutorial = currentCoinCount + 2000;
    NSInteger totalTutorial = totalCoinCount + 2000;
    
    [Stats instance].currentCoin = [NSNumber numberWithInteger:currentTutorial];
    [Stats instance].totalCoin = [NSNumber numberWithInteger:totalTutorial];
    
    // Unown the pickuptruck
    for (NSInteger i = 0; i < [[Stats instance].ownedCars count]; i++) {
        if ([[[Stats instance].ownedCars objectAtIndex:i] isEqualToString:@"Pickup Truck"]) {
            [[Stats instance].ownedCars removeObjectAtIndex:i];
        }
    }
    
    // Cleanup
    [Stats instance].whereTutorial = @"Menu";
    
}

- (void)creditsRemove {
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    // Re-enable buttons
    [self enableButtonsOnNode:array];
    
    // Re-enable touches
    CCNode *menuNode = [runningScene.children objectAtIndex:0];
    menuNode.userInteractionEnabled = YES;
    
    // Find the node that is of Credits class.
    for (CCNode *node in array) {
        if ([node isKindOfClass:[Credits class]]) {
            
            // Fade all nodes on Credits
            for (CCNode *childNode in node.children) {
                CCActionFadeOut *fadeNode = [CCActionFadeOut actionWithDuration:.5];
                [childNode runAction:fadeNode];
            }
            [node removeChildByName:@"Back Button"];
            
            [self performSelector:@selector(removeNode:) withObject:node afterDelay:.6f];
            
        }
        
        if ([node.name isEqualToString:@"Fade"]) {
            
            // Fade background
            CCActionFadeOut *fadeBack = [CCActionFadeOut actionWithDuration:.5];
            [node runAction:fadeBack];
            
        }
    }
}

- (void)statsRemove {
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    // Re-enable buttons
    [self enableButtonsOnNode:array];
    
    // Re-enable touches
    CCNode *menuNode = [runningScene.children objectAtIndex:0];
    menuNode.userInteractionEnabled = YES;
    
    // Find the node that is of Credits class.
    for (CCNode *node in array) {
        if ([node isKindOfClass:[StatsNode class]]) {
            
            // Fade all nodes on StatsNode
            for (CCNode *childNode in node.children) {
                CCActionFadeOut *fadeNode = [CCActionFadeOut actionWithDuration:.5];
                [childNode runAction:fadeNode];
            }
            [node removeChildByName:@"Back Button"];
            
            [self performSelector:@selector(removeNode:) withObject:node afterDelay:.6f];
            
        }
        
        if ([node.name isEqualToString:@"Fade"]) {
            
            // Fade background
            CCActionFadeOut *fadeBack = [CCActionFadeOut actionWithDuration:.5];
            [node runAction:fadeBack];
            
        }
    }
}

- (void)optionsRemove {
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    // Re-enable buttons
    [self enableButtonsOnNode:array];
    
    // Re-enable touches
    CCNode *menuNode = [runningScene.children objectAtIndex:0];
    menuNode.userInteractionEnabled = YES;
    
    // Find the node that is of Credits class.
    for (CCNode *node in array) {
        if ([node isKindOfClass:[Options class]]) {
            
            for (CCNode *childNode in node.children) {
                CCActionFadeOut *fadeNode = [CCActionFadeOut actionWithDuration:.5];
                [childNode runAction:fadeNode];
                
                // Handle buttons
                if ([childNode isKindOfClass:[CCButton class]]) {
                    [childNode setCascadeOpacityEnabled:TRUE];
                }
            }
            
            [node removeChildByName:@"Back Button"];
            
            [self performSelector:@selector(removeNode:) withObject:node afterDelay:.6f];
            
        }
        
        if ([node.name isEqualToString:@"Fade"]) {
            
            // Fade background
            CCActionFadeOut *fadeBack = [CCActionFadeOut actionWithDuration:.5];
            [node runAction:fadeBack];
            
        }
    }
}

- (void)resetRemove {
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    // Re-enable buttons
    [self enableButtonsOnNode:array];
    
    // Re-enable touches
    CCNode *menuNode = [runningScene.children objectAtIndex:0];
    menuNode.userInteractionEnabled = YES;
    
    // Find the node that is of Credits class.
    for (CCNode *node in array) {
        if ([node isKindOfClass:[Options class]]) {
            
            for (CCNode *childNode in node.children) {
                CCActionFadeOut *fadeNode = [CCActionFadeOut actionWithDuration:.5];
                [childNode runAction:fadeNode];
                
                // Handle buttons
                if ([childNode isKindOfClass:[CCButton class]]) {
                    [childNode setCascadeOpacityEnabled:TRUE];
                }
            }
            
            [node removeChildByName:@"Back Button"];
            
            [self performSelector:@selector(removeNode:) withObject:node afterDelay:.6f];
            
        }
        
        if ([node.name isEqualToString:@"Fade"]) {
            
            // Fade background
            CCActionFadeOut *fadeBack = [CCActionFadeOut actionWithDuration:.5];
            [node runAction:fadeBack];
            
        }
    }
    
    // Replace scene to reset car on menu
    CCScene *scene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionFadeWithDuration:.5]];
    
}

- (void)removeNode:(CCNode*)node {
    [node removeFromParent];
}

- (void)enableButtonsOnNode:(NSArray*)array {
    
    for (CCButton *button in array) {
        
        if ([button isKindOfClass:[CCButton class]]) {
            button.enabled = YES;
        }
        
    }
}

- (void)disableButtons {
    _creditsButton.enabled = NO;
    _statsButton.enabled = NO;
    _optionsButton.enabled = NO;
    _heroButton.enabled = NO;
}

#pragma mark - Touches

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
    if (![Stats instance].shouldTutorial) {
        for (CCNode *ground in _grounds) {
            
            CGPoint touchLocation = [touch locationInNode:ground];
            
            if (!CGPointEqualToPoint(touchLocation, CGPointZero)) {
                CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
                [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:.5]];
                return;
            }
            
        }
    }
    
}

#pragma mark - Buttons

- (void)credits {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Credits"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:.5]];
    
    CCActionFadeIn *fadeBack = [CCActionFadeIn actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
    
    // Run to seperate credits screen
    Credits *credits = (Credits *)[CCBReader load:@"Credits"];
    [credits runCredits];
    
    // Disable touches for incoming menu
    self.userInteractionEnabled = NO;
    
    // Disable buttons
    [self disableButtons];
    
    [self addChild:credits];
}

- (void)hero {
    CCAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"CarsMenu"];
    [self performSelector:@selector(moveScene) withObject:nil afterDelay:1.1f];
}

- (void)moveScene {
    
    if ([[Stats instance].whereTutorial isEqual:@"Menu"]) {
        
        [Stats instance].whereTutorial = @"CarMenu";
        [Stats instance].shouldTutorial = NO;
        
    }
    
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CarMenu"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene
                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
}

- (void)options {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Options"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene
//                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
    
    CCActionFadeIn *fadeBack = [CCActionFadeIn actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
    
    // Run to seperate credits screen
    Options *options = (Options *)[CCBReader load:@"Options"];
    [options runOptions];
    
    // Disable touches for incoming menu
    self.userInteractionEnabled = NO;
    
    // Disable buttons
    [self disableButtons];
    
    [self addChild:options];
    
}

- (void)stats {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Stats"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene
//                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
    
    CCActionFadeIn *fadeBack = [CCActionFadeIn actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
    
    // Run to seperate credits screen
    StatsNode *stats = (StatsNode *)[CCBReader load:@"Stats"];
    [stats runStats];
    
    // Disable touches for incoming menu
    self.userInteractionEnabled = NO;
    
    // Disable buttons
    [self disableButtons];
    
    [self addChild:stats];
    
}

@end
