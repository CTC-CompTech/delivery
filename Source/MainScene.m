#import "MainScene.h"
#import "CCAnimation.h"
#import "Obstacle.h"
#import "Stats.h"

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderGround,
    DrawingOrderObstacle,
    DrawingOrderHero
};

//static const CGFloat scrollSpeed = 100.f;
static const CGFloat firstObstaclePosition = 450.f;
//static const CGFloat distanceBetweenObstacles = 250.f;

@interface MainScene ()

@property (strong, nonatomic) CCSpriteFrame *heroFrame;

@property (strong, nonatomic) CCSpriteFrame *policeCarFrame;

@property BOOL shouldAbility;

@property NSInteger currentScore;

@end

@implementation MainScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCSprite *_hero;
    
    CCSprite *_pause;
    
    CCParticleSystemBase *_fireBall;
    CCParticleSystemBase *_particleHeartR;
    CCParticleSystemBase *_particleHeartL;
    
    CCButton *_restartButton;
    CCButton *_abilityButton;
    CCButton *_backButton;
    
    CCNode *_heartHolder;
    CCNode *_heartRight;
    CCNode *_heartLeft;
    
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_cooldownTimer;
    
    BOOL _gameOver;
    BOOL _paused;
    CGFloat _scrollSpeed;
    CGFloat distanceBetweenObstacles;
    
    CGPoint firstTouch;
    CGPoint lastTouch;
    
    NSMutableArray *_obstacles;
    
    NSArray *_grounds;
    
}

//- (id)init {
//    if(self=[super init]) {
//        self.obstacleCount = 0;
//    }
//    return self;
//}
//+ (MainScene*)instance {
//    if (!inst) {
//        inst = [[MainScene alloc] init];
//    }
//    return inst;
//}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
    
    // Launch constants
    [Stats instance].obstacleCount = 0;
    distanceBetweenObstacles = 250.f;
    
    [Stats instance].lasts = [[NSMutableArray alloc] initWithCapacity:2];
    
    
    // Selcted car functions
    CCSpriteFrame *policeCar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Police Car.png"];
    self.policeCarFrame = policeCar;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"selectedCar"] == nil) {
        CCSpriteFrame *defaultCar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Truck.png"];
        [_hero setSpriteFrame:defaultCar];
        self.heroFrame = _hero.spriteFrame;
    } else {
        NSString *selectedCar = [defaults objectForKey:@"selectedCar"];
        
        CCSpriteFrame *car = [CCSpriteFrame frameWithImageNamed:selectedCar];
        [_hero setSpriteFrame:car];
        self.heroFrame = _hero.spriteFrame;
    }
    
    if ([[defaults objectForKey:@"selectedCar"] isEqual: @"Delivery/Sports Car.png"]) {
        _abilityButton.visible = TRUE;
        self.shouldAbility = TRUE;
    } else {
        _abilityButton.visible = FALSE;
    }
    
    if ([[defaults objectForKey:@"selectedCar"] isEqual: @"Delivery/Police Car.png"]) {
        _heartHolder.visible = TRUE;
        _heartLeft.visible = TRUE;
        _heartRight.visible = TRUE;
    } else {
        _heartHolder.visible = FALSE;
        _heartLeft.visible = FALSE;
        _heartRight.visible = FALSE;
    }
    
    // <-- End selected car ---> \\
    
    
    // set this class as delegate
    _physicsNode.collisionDelegate = self;
    // set collision txpe
    _hero.physicsBody.collisionType = @"hero";
    
    _obstacles = [NSMutableArray array];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    [self spawnNewObstacle];
    
    for (CCNode *ground in _grounds) {
        ground.zOrder = DrawingOrderGround;
    }
    _hero.zOrder = DrawingOrderHero;
    
    // listen for swipes to the left
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    // listen for swipes to the right
    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    
}

- (void)update:(CCTime)delta {
    _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y - (_scrollSpeed *delta));
    _hero.position = ccp(_hero.position.x, _hero.position.y + delta * _scrollSpeed);
//    CCLOG(@"%@", NSStringFromCGPoint(_hero.position));
    // loop the ground
    
    
//    if ([[MainScene instance].obstacleCount floatValue] >= 20 && _gameOver != TRUE) {
//        _scrollSpeed = 210.f;
//    } else if ([[MainScene instance].obstacleCount floatValue] <= 20 && _gameOver != TRUE){
//        _scrollSpeed = 175.f;
//    } else if (_gameOver == TRUE) {
//        _scrollSpeed = 0.f;
//    }
    
    // Constants
    distanceBetweenObstacles = [[Stats instance].obstacleDistance floatValue];
    
    if (_hero.position.x < 0 || _hero.position.x > 320) {
        [_hero stopAllActions];
        _hero.position = ccp(160, _hero.position.y);
        _hero.rotation = -90;
    }
    
    if (_gameOver != YES) {
        if (_paused != YES) {
            if ([Stats instance].abilityUse == NO) {
                if ([Stats instance].level == [NSNumber numberWithInt:1]) {
                    _scrollSpeed = 175.f;
                } else if ([Stats instance].level == [NSNumber numberWithInt:2]) {
                    _scrollSpeed = 175.f;
                } else if ([Stats instance].level == [NSNumber numberWithInt:3]) {
                    _scrollSpeed = 210.f;
                } else if ([Stats instance].level == [NSNumber numberWithInt:4]) {
                    _scrollSpeed = 210.f;
                } else if ([Stats instance].level == [NSNumber numberWithInt:5]) {
                    _scrollSpeed = 210.f;
                }
            }
        }
    } else {
        _scrollSpeed = 0;
    }
    
    for (CCNode *ground in _grounds) {
        // get the world position of the ground
        CGPoint groundWorldPosition = [_physicsNode convertToWorldSpace:ground.position];
        // get the screen position of the ground
        CGPoint groundScreenPosition = [self convertToNodeSpace:groundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (groundScreenPosition.y <= (-1 * ground.contentSize.width + 1100)) { // 552 // 537
            ground.position = ccp(ground.position.x, ground.position.y + 2 + ground.contentSize.height + 511);
        }
    }
    
    NSMutableArray *offScreenObstacles = nil;
    for (CCNode *obstacle in _obstacles) {
        CGPoint obstacleWorldPosition = [_physicsNode convertToWorldSpace:obstacle.position];
        CGPoint obstacleScreenPosition = [self convertToNodeSpace:obstacleWorldPosition];
        if (obstacleScreenPosition.y < -obstacle.contentSize.height) {
            if (!offScreenObstacles) {
                offScreenObstacles = [NSMutableArray array];
            }
            [offScreenObstacles addObject:obstacle];
        }
    }
    for (CCNode *obstacleToRemove in offScreenObstacles) {
        [obstacleToRemove removeFromParent];
        [_obstacles removeObject:obstacleToRemove];
        // for each removed obstacle, add a new one
        [self spawnNewObstacle];
    }
}

- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_obstacles lastObject];
    CGFloat previousObstacleYPosition = previousObstacle.position.y;
    if (!previousObstacle) {
        // this is the first obstacle
        previousObstacleYPosition = firstObstaclePosition;
    }
    Obstacle *obstacle = (Obstacle *)[CCBReader load:@"Obstacle"];
    obstacle.position = ccp(0, previousObstacleYPosition + distanceBetweenObstacles);
    
    [obstacle setupRandomPosition];
    
    if ([[Stats instance].lasts count] == 2) {
        if ([[Stats instance].lasts objectAtIndex:0] == [NSNumber numberWithInteger:5] &&
            [[Stats instance].lasts objectAtIndex:1] == [NSNumber numberWithInteger:1]) {
            
            obstacle.position = ccp(0, previousObstacleYPosition + 250.f);
            
        } else if ([[Stats instance].lasts objectAtIndex:0] == [NSNumber numberWithInteger:1] &&
                   [[Stats instance].lasts objectAtIndex:1] == [NSNumber numberWithInteger:5]) {
            
            obstacle.position = ccp(0, previousObstacleYPosition + 250.f);
            
        }
    }
    
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
    
    obstacle.zOrder = DrawingOrderObstacle;
}

/*///////////////////////////////////////////
 *
 * Collisions
 *
 ///////////////////////////////////////////*/

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    
    // Check for two hearts car
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"selectedCar"] isEqual: @"Delivery/Police Car.png"] && _heartLeft.opacity == 1) {
        _particleHeartL.visible = TRUE;
        [_particleHeartL resetSystem];
        CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.5f opacity:0];
        [_heartLeft runAction:fade];
        
        // Credit invincibility to not "disable" the rest of the obstacle.
        _hero.physicsBody.collisionType = @"ability";
        [self performSelector:@selector(invokeInvicible) withObject:nil afterDelay:.5];
        
        return FALSE;
    } else {
        if ([[defaults objectForKey:@"selectedCar"] isEqual: @"Delivery/Police Car.png"]) {
            _particleHeartR.visible = TRUE;
            [_particleHeartR resetSystem];
            CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.5f opacity:0];
            [_heartRight runAction:fade];
        }
        
        [self gameOver];
        return TRUE;
    }
}

- (void)invokeInvicible {
    _hero.physicsBody.collisionType = @"hero";
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    NSInteger coinReturn = [self getCoins];
    NSInteger totalRunCoin = _currentScore + coinReturn;
    
    _currentScore = totalRunCoin;
    
    // Format
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:totalRunCoin];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    _scoreLabel.string = formatted;
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ability:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    NSInteger coinReturn = [self getCoins];
    NSInteger totalRunCoin = _currentScore + coinReturn;
    
    _currentScore = totalRunCoin;
    
    // Format
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:totalRunCoin];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    _scoreLabel.string = formatted;
    return TRUE;
}

- (NSInteger)getCoins {
    
    NSInteger coinAmount = 0;
        
    if ([Stats instance].level == [NSNumber numberWithInt:1]) {
        
        coinAmount = 25;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:2]) {
        
        coinAmount = 50;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:3]) {
        
        coinAmount = 100;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:4]) {
        
        coinAmount = 150;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:5]) {
        
        coinAmount = 300;
        
    }
    
    return coinAmount;
}

- (void)gameOver {
    if (!_gameOver) {
        [Stats instance].obstacleCount = 0;
        _gameOver = TRUE;
        _abilityButton.visible = FALSE;
        _pause.visible = FALSE;
        _restartButton.visible = TRUE;
        _backButton.visible = TRUE;
        
        // Keep score
        NSInteger intScore = self.currentScore;
        NSInteger intTotal = [[Stats instance].totalCoin integerValue];
        NSInteger intCurrent = [[Stats instance].currentCoin integerValue];
        
        NSNumber *scoreTotal = [NSNumber numberWithInteger:intScore + intTotal];
        NSNumber *scoreCurrent = [NSNumber numberWithInteger:intScore + intCurrent];
        
        [Stats instance].totalCoin = scoreTotal;
        [Stats instance].currentCoin = scoreCurrent;
        
//        _hero.rotation = 90.f;
//        _hero.physicsBody.allowsRotation = FALSE;
        [_hero stopAllActions];
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.05f position:ccp(-8, 8)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionMoveBy *moveBy2 = [CCActionMoveBy actionWithDuration:0.05f position:ccp(8, -8)];
        CCActionInterval *reverseMovement2 = [moveBy2 reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement, moveBy2, reverseMovement2]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
    }
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

- (void)backMenu {
    CCScene *scene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:scene withTransition:[CCTransition transitionFadeWithDuration:.5]];
}

- (void)pause {
    CGFloat speedBefore = _scrollSpeed;
    if (_paused == NO) {
        _paused = YES;
        _scrollSpeed = 0.f;
        _abilityButton.visible = FALSE;
        
        // Fix ability pause
        [_fireBall stopSystem];
//        _fireBall.visible = FALSE;
        
    } else {
        _paused = NO;
        _scrollSpeed = speedBefore;
        
        if (self.shouldAbility == YES) {
            _abilityButton.visible = TRUE;
        }
    }
}

- (void)ability {
    _hero.physicsBody.collisionType = @"ability";
    _abilityButton.visible = FALSE;
    _fireBall.visible = TRUE;
   [_fireBall resetSystem];
    NSNumber *speedBefore = [NSNumber numberWithFloat:_scrollSpeed];
    [Stats instance].abilityUse = YES;
    _scrollSpeed = 500.f;
    self.shouldAbility = FALSE;
    
    [self performSelector:@selector(abilityStop:) withObject:speedBefore afterDelay:5.0];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //Here your non-main thread.
//        [NSThread sleepForTimeInterval:5.0f];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //Here you returns to main thread.
////            _scrollSpeed = speedBefore;
////            _scrollSpeed = speedBefore;
//            [MainScene instance].abilityUse = NO;
//            [_fireBall stopSystem];
//            // Speed may land on obstacle -- Give longer invinciblility
//            [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
//        });
//    });
}

- (void)abilityStop:(NSNumber*)speedBefore {
    
    CGFloat speed = [speedBefore floatValue];
    
    if (_paused == NO) {
        _scrollSpeed = speed;
        [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
    } else {
        _hero.physicsBody.collisionType = @"hero";
    }
    
    [Stats instance].abilityUse = NO;
    [_fireBall stopSystem];
    // Speed may land on obstacle -- Give longer invinciblility
//    [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
    
}

- (void)delayPerfect {
//    CCLOG(@"Invincibility ended.");
    _hero.physicsBody.collisionType = @"hero";
    
    // Cooldown timer
    _cooldownTimer.visible = TRUE;
    NSInteger timer = [_cooldownTimer.string intValue];
    
    if (_paused == YES) {
        
        _cooldownTimer.string = [NSString stringWithFormat:@"%ld", (long)timer];
        _cooldownTimer.visible = FALSE;
        [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
        
    } else if (timer > 0) {
        
        timer--;
        
        _cooldownTimer.string = [NSString stringWithFormat:@"%ld", (long)timer];
        [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
        
    } else {
        
        _cooldownTimer.visible = FALSE;
        _cooldownTimer.string = @"10";
        if (_gameOver == NO) {
            if (_paused == NO) {
                _abilityButton.visible = TRUE;
                self.shouldAbility = TRUE;
            }
        }
        
    }
}

- (void)swipeLeft {
//    CCLOG(@"swipeLeft");
    if (!_gameOver) {
        if (!_paused) {
            CGPoint byPoint;
            if (_hero.position.x <= 50) {
                byPoint = ccp(0, 0);
            } else {
                byPoint = ccp(-64, 0);
            }
            CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.075 position:byPoint];
            CCActionRotateBy *rotateBy = [CCActionRotateBy actionWithDuration:0.0375 angle:-45];
            CCActionInterval *rotateByReverse = [rotateBy reverse];
            CCActionSequence *swipe = [CCActionSequence actionWithArray:@[rotateBy, moveBy, rotateByReverse]];
            
            [_hero runAction:swipe];
            
            // Make it so car cannot "drift"
            [self performSelector:@selector(setZeroLeft) withObject:nil afterDelay:0.085];
        }
    }
}

- (void)swipeRight {
//    CCLOG(@"swipeRight");
    if (!_gameOver) {
        if (!_paused) {
            CGPoint byPoint;
            if (_hero.position.x >= 250) {
                byPoint = ccp(0, 0);
            } else {
                byPoint = ccp(64, 0);
            }
            CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.075 position:byPoint];
            CCActionRotateBy *rotateBy = [CCActionRotateBy actionWithDuration:0.0375 angle:45];
            CCActionInterval *rotateByReverse = [rotateBy reverse];
            CCActionSequence *swipe = [CCActionSequence actionWithArray:@[rotateBy, moveBy, rotateByReverse]];
            
            [_hero runAction:swipe];
            
            // Make it so car cannot "drift"
            [self performSelector:@selector(setZeroRight) withObject:nil afterDelay:0.085];
        }
    }
    
}

- (void)setZeroRight {
    _hero.rotation = -45.f;
}

- (void)setZeroLeft {
    _hero.rotation = -135.f;
}

@end
