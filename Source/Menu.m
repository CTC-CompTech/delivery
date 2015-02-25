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

static const CGFloat scrollSpeed = 210.f;

@implementation Menu {
    
    CCPhysicsNode *_physicsNode;
    
    CCLabelTTF *_coinCurrent;
    
    CCLightNode *_redLight;
    CCLightNode *_blueLight;
    
    CCNode *_fadeBackground;
    
    CCNode *_ground1;
    CCNode *_ground2;
    
    CCSprite *_hero;
    
    NSArray *_grounds;
    
}

#pragma mark - Load

- (void)didLoadFromCCB {
    self.userInteractionEnabled = YES;
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
    
}


#pragma mark - Helping methods

- (void)creditsRemove {
    
    // Get scenes
    CCScene* runningScene = [CCDirector sharedDirector].runningScene;
    
    // Children of Menu - Index of 0 will always be Menu
    NSArray *array = [[runningScene.children objectAtIndex:0] children];
    
    // Find the node that is of Credits class.
    for (CCNode *node in array) {
        if ([node isKindOfClass:[Credits class]]) {
            
            CCActionFadeOut *fadeNode = [CCActionFadeOut actionWithDuration:.3];
            [[node.children objectAtIndex:0] runAction:fadeNode]; // node.children is required because the initial node isn't actually displayed.
            [[node.children objectAtIndex:1] removeFromParent]; // This is the button.
            [self performSelector:@selector(removeNode:) withObject:node afterDelay:.6f];
            
        }
        
        if ([node.name isEqualToString:@"Fade"]) {
            
            // Fade background
            CCActionFadeOut *fadeBack = [CCActionFadeOut actionWithDuration:.5];
            [node runAction:fadeBack];
            
        }
    }
}

- (void)removeNode:(CCNode*)node {
    [node removeFromParent];
}

#pragma mark - Touches

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    
    for (CCNode *ground in _grounds) {
        
        CGPoint touchLocation = [touch locationInNode:ground];
        
        if (!CGPointEqualToPoint(touchLocation, CGPointZero)) {
            CCScene *gameplayScene = [CCBReader loadAsScene:@"MainScene"];
            [[CCDirector sharedDirector] pushScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:.5]];
        }
        
    }
    
}

#pragma mark - Buttons

- (void)credits {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Credits"];
//    [[CCDirector sharedDirector] pushScene:gameplayScene withTransition:[CCTransition transitionFadeWithDuration:.5]];
    
    CCActionFadeIn *fadeBack = [CCActionFadeIn actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
    
    // Run to seperate credits screen
    Credits *credits = (Credits *)[CCBReader load:@"Credits"];
    [credits runCredits];
    [self addChild:credits];
}

- (void)hero {
    CCAnimationManager* animationManager = self.userObject;
    [animationManager runAnimationsForSequenceNamed:@"CarsMenu"];
    [self performSelector:@selector(moveScene) withObject:nil afterDelay:1.1f];
}

- (void)moveScene {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CarMenu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionCrossFadeWithDuration:.5]];
}

@end
