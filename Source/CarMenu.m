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

static CarMenu *inst = nil;

@interface CarMenu ()

@property CGPoint initialHero;
@property CGPoint initialFake;

@property CGPoint realInitialHero;

@property BOOL doReplace;
@property BOOL loadAnimationIsMoving;

@end

@implementation CarMenu {
    CCButton *_backCar;
    
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    
    CCSprite *_hero;
    CCSprite *_fakeHero;
    
    CCLabelTTF *_carTitle;
    CCLabelTTF *_coinCurrent;
    
    NSArray *_grounds;
    
    // TEMP
    CCButton *_addBtn;
    CCButton *_clear;
    // TEMP
}

- (id)init {
    if(self=[super init]) {
        self.titleCar = @"Delivery Truck";
        self.doReplace = YES;
    }
    return self;
}

+ (CarMenu*)instance {
    if (!inst) {
        inst = [[CarMenu alloc] init];
    }
    return inst;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
    
    // Set coin total
    NSInteger currentCoin = [[Stats instance].currentCoin integerValue];
    
    // Format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:currentCoin];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    _coinCurrent.string = [NSString stringWithFormat:@"%@", formatted];
    
    // Set title of menu
    _carTitle.string = [CarMenu instance].titleCar;
    
    // Construct Sprite Frame
    NSString *constructedFrame = [NSString stringWithFormat:@"Delivery/Heros/%@.png", [CarMenu instance].titleCar];
    
    // Fix Delivery
    if ([constructedFrame isEqualToString:@"Delivery/Heros/Delivery Truck.png"]) {
        constructedFrame = @"Delivery/Heros/Truck.png";
    }
    
    _hero.spriteFrame = [CCSpriteFrame frameWithImageNamed:constructedFrame];
    
    // Redefine
    self.realInitialHero = _hero.position;
    self.initialHero = _hero.position;
    self.initialFake = _fakeHero.position;
    
    // Animations
    self.loadAnimationIsMoving = YES;
    CGPoint initial = _hero.position;
    _hero.position = ccp(-100, _hero.position.y);
    CCActionMoveTo *animate = [CCActionMoveTo actionWithDuration:1.5f position:initial];
    [_hero runAction:animate];
    [self performSelector:@selector(loadAnimationEnd) withObject:nil afterDelay:1.6f];
    
}

- (void)update:(CCTime)delta {
    
    _carTitle.string = [CarMenu instance].titleCar;
    
    // User presses button before everything is done moving
    if ([CarMenu instance].didPressWhileMoving == YES) {
        [_hero stopAllActions];
        [_fakeHero stopAllActions];
        
        _hero.spriteFrame = _fakeHero.spriteFrame;
        
        _hero.position = self.initialHero;
        _fakeHero.position = self.initialFake;
        
        // Replace method fires, prevent that
        self.doReplace = NO;
        
        [CarMenu instance].isMoving = YES;
        [self performSelector:@selector(moveCars) withObject:nil];
        
        [CarMenu instance].didPressWhileMoving = NO;
    }
    
    if (![CarMenu instance].shouldMove) {
        _hero.position = ccp(_hero.position.x, _hero.position.y);
    } else {
        if ([CarMenu instance].isMoving == NO) {
//            [_hero stopAllActions];
            [CarMenu instance].isMoving = YES;
            [self performSelector:@selector(moveCars) withObject:nil];
        }
    }
    
    for (CCNode *ground in _grounds){
        ground.position = ccp((ground.position.x + (-scrollSpeed * delta)), ground.position.y);
        if (ground.position.x <= (-ground.boundingBox.size.width)){
            ground.position = ccp(ground.scene.boundingBox.size.width, ground.position.y);
        }
    }
}

/*///////////////////////////////////////////
 *
 * Animations
 *
 ///////////////////////////////////////////*/

- (void)moveCars {
    
    self.initialHero = self.realInitialHero;
    self.initialFake = _fakeHero.position;
    
    // Construct Sprite Frame
    NSString *constructedFrame = [NSString stringWithFormat:@"Delivery/Heros/%@.png", [CarMenu instance].titleCar];
    
    // Fix Delivery
    if ([constructedFrame isEqualToString:@"Delivery/Heros/Delivery Truck.png"]) {
        constructedFrame = @"Delivery/Heros/Truck.png";
    }
    
    _fakeHero.spriteFrame = [CCSpriteFrame frameWithImageNamed:constructedFrame];

    CCActionMoveTo *moveHero = [CCActionMoveTo actionWithDuration:1.5f position:ccp(_hero.position.x + 400, _hero.position.y)];
    
    CCActionMoveTo *moveFake = [CCActionMoveTo actionWithDuration:1.5f position:self.initialHero];
    
    [self performSelector:@selector(replaceCars) withObject:nil afterDelay:1.6f];
    
    [_hero runAction:moveHero];
    [_fakeHero runAction:moveFake];
    
}

- (void)replaceCars {
    
    if (self.doReplace == YES) {
        // Construct Sprite Frame
        NSString *constructedFrame = [NSString stringWithFormat:@"Delivery/Heros/%@.png", [CarMenu instance].titleCar];
    
        // Fix Delivery
        if ([constructedFrame isEqualToString:@"Delivery/Heros/Delivery Truck.png"]) {
            constructedFrame = @"Delivery/Heros/Truck.png";
        }
    
        _hero.spriteFrame = [CCSpriteFrame frameWithImageNamed:constructedFrame];
    
        // Move back
        _hero.position = self.initialHero;
        _fakeHero.position = self.initialFake;
    
        [CarMenu instance].isMoving = NO;

    } else {
        self.doReplace = YES;
    }
    
}

- (void)loadAnimationEnd {
    self.loadAnimationIsMoving = NO;
}

/*///////////////////////////////////////////
 *
 * Buttons
 *
 ///////////////////////////////////////////*/

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
