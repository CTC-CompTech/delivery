//
//  GameOver.m
//  Delivery
//
//  Created by Andrew Robinson on 2/4/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOver.h"
#import "Stats.h"

@implementation GameOver {
    
    CCNode *_gameOverText;
    CCNode *_gameOverBackground;
    
    CCButton *_restartButton;
    CCButton *_abilityButton;
    CCButton *_mainMenu;
    CCButton *_carsButton;
    
    CCLabelTTF *_bestCoin;
    CCLabelTTF *_pocketCoin;
    CCLabelTTF *_gameOverCount;
    
}

- (void)runGameOver {
    
    // Best Score
    NSInteger bestCoin = [[Stats instance].bestCoin integerValue];
    NSInteger currentCoin = self.currentScore;
    
    if (bestCoin < currentCoin) {
        [Stats instance].bestCoin = [NSNumber numberWithInteger:currentCoin];
        
        _bestCoin.string = [self formatter:currentCoin];
        
    } else {
        
        _bestCoin.string = [self formatter:bestCoin];
    }
    
    // Run coin count
    NSInteger totalRunCoin = self.currentScore;
    
    self.currentScore = totalRunCoin;
    
    _gameOverCount.string = [self formatter:totalRunCoin];
    
    // Pocket coin
    NSInteger pocket = [[Stats instance].currentCoin integerValue];
    
    _pocketCoin.string = [self formatter:pocket];
    
    // Animations
    _gameOverText.position = ccp(-160, _gameOverText.position.y);
    [self performSelector:@selector(sweepTitle) withObject:nil afterDelay:.1];
    
    _gameOverBackground.position = ccp(480, _gameOverBackground.position.y);
    _restartButton.position = ccp(480, _restartButton.position.y);
    _mainMenu.position = ccp(440, _mainMenu.position.y);
    _carsButton.position = ccp(521, _carsButton.position.y);
    _gameOverCount.position = ccp(480, _gameOverCount.position.y);
    _bestCoin.position = ccp(480 + 65, _bestCoin.position.y);
    _pocketCoin.position = ccp(480 + 65, _pocketCoin.position.y);
    [self performSelector:@selector(sweepContent) withObject:nil afterDelay:.2];
    
}

- (void)sweepTitle {
    CCActionMoveTo *moveTitle = [CCActionMoveTo actionWithDuration:.25 position:ccp(160, _gameOverText.position.y)];
    
    [_gameOverText runAction:moveTitle];
}

- (void)sweepContent {
    CCActionMoveTo *moveBackground = [CCActionMoveTo actionWithDuration:.25 position:ccp(160, _gameOverBackground.position.y)];
    CCActionMoveTo *moveRestart = [CCActionMoveTo actionWithDuration:.25 position:ccp(160, _restartButton.position.y)];
    CCActionMoveTo *moveMenu = [CCActionMoveTo actionWithDuration:.25 position:ccp(120, _mainMenu.position.y)];
    CCActionMoveTo *moveCars = [CCActionMoveTo actionWithDuration:.25 position:ccp(201, _carsButton.position.y)];
    CCActionMoveTo *moveScore = [CCActionMoveTo actionWithDuration:.25 position:ccp(160, _gameOverCount.position.y)];
    CCActionMoveTo *moveBest = [CCActionMoveTo actionWithDuration:.25 position:ccp(262, _bestCoin.position.y)];
    CCActionMoveTo *movePocket = [CCActionMoveTo actionWithDuration:.25 position:ccp(262, _pocketCoin.position.y)];
    
    [_gameOverBackground runAction:moveBackground];
    [_restartButton runAction:moveRestart];
    [_mainMenu runAction:moveMenu];
    [_carsButton runAction:moveCars];
    [_gameOverCount runAction:moveScore];
    [_bestCoin runAction:moveBest];
    [_pocketCoin runAction:movePocket];
    
}

/*///////////////////////////////////////////
 *
 * Buttons
 *
 ///////////////////////////////////////////*/

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)menu {
    CCScene *scene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:scene withTransition:[CCTransition transitionFadeWithDuration:.5]];
}

- (void)cars {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"CarMenu"];
    [[CCDirector sharedDirector] pushScene:gameplayScene
                            withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:.5]];
}

- (NSString *)formatter:(NSInteger)toFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:toFormat];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    return formatted;
    
}

@end
