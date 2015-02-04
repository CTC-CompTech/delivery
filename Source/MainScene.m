#import "MainScene.h"
#import "CCAnimation.h"
#import "Obstacle.h"
#import "GameOver.h"
#import "Stats.h"

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderGround,
    DrawingOrderObstacle,
    DrawingOrderHero,
    DrawingOrderRocket
};

//static const CGFloat scrollSpeed = 100.f;
static const CGFloat firstObstaclePosition = 450.f;
//static const CGFloat distanceBetweenObstacles = 250.f;

@interface MainScene ()

@property (strong, nonatomic) CCSpriteFrame *heroFrame;

@property (strong, nonatomic) CCSpriteFrame *policeCarFrame;

@property BOOL shouldAbility;

@property BOOL rocketFire;

@property NSInteger currentScore;

@property CGPoint startPosition;

@end

@implementation MainScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    vehicleProxy *_hero;
    
    CCSprite *_pause;
    
    CCParticleSystemBase *_fireBall;
    CCParticleSystemBase *_particleHeartR;
    CCParticleSystemBase *_particleHeartL;
    
    CCNode *_gameOverText;
    CCNode *_gameOverBackground;
    
    CCButton *_abilityButton;
    
    CCButton *_pauseOptions;
    CCButton *_pauseResume;
    CCButton *_pauseMenu;
    
    CCNode *_heartHolder;
    CCNode *_heartRight;
    CCNode *_heartLeft;
    
    CCNode *_rocket;
    
    CCNode *_gamePlayCoin;
    CCNode *_backgroundFade;
    
    CCLightNode *_redLight;
    CCLightNode *_blueLight;
    
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_cooldownTimer;
    CCLabelTTF *_lightRunnerAbility;
    
    BOOL _gameOver;
    BOOL _paused;
    CGFloat distanceBetweenObstacles;
    
    CGFloat _rocketSpeed;
    
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
        
//        NSLog(@"RECT OF HERO: %@", NSStringFromCGRect([_hero boundingBox]));

    }
    
    if ([_hero.getVehicleType isEqual:@"sportsCar"] || [_hero.getVehicleType isEqual:@"lightRunner"] || [_hero.getVehicleType isEqual:@"pickupTruck"]) {
        _abilityButton.visible = TRUE;
        self.shouldAbility = TRUE;
    } else {
        _abilityButton.visible = FALSE;
    }
    
    if ([_hero.getVehicleType isEqual:@"policeCar"]) {
        _heartHolder.visible = TRUE;
        _heartLeft.visible = TRUE;
        _heartRight.visible = TRUE;
        
        // Lights
        _redLight.visible = TRUE;
        _blueLight.visible = TRUE;

    } else {
        _heartHolder.visible = FALSE;
        _heartLeft.visible = FALSE;
        _heartRight.visible = FALSE;
    }
    
    if ([_hero.getVehicleType isEqual:@"lightRunner"]) {
        _lightRunnerAbility.visible = TRUE;
    }

    // <-- End selected car ---> \\
    
    
    // Track games run
    NSInteger games = [[Stats instance].gameRuns integerValue];
    games++;
    
    [Stats instance].gameRuns = [NSNumber numberWithInteger:games];
    
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
    _rocket.zOrder = DrawingOrderRocket;
    
    // listen for swipes to the left
#if __CC_PLATFORM_IOS
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    // listen for swipes to the right
    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
#endif
    
//    UITapGestureRecognizer *tapLimitRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLimitRecognizer:)];
//    [tapLimitRecognizer setNumberOfTapsRequired:2];
//    [[[CCDirector sharedDirector] view] addGestureRecognizer:tapLimitRecognizer];
    
    self.userInteractionEnabled = TRUE;
}

#if __CC_PLATFORM_ANDROID
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint touchLocation = [touch locationInNode:self];
    self.startPosition = touchLocation;
}

- (void)touchEnded:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
    CGPoint endPosition = [touch locationInNode:self];
    
    if (self.startPosition.x < endPosition.x) {
        // Right swipe
        [self swipeRight];
    } else if (self.startPosition.x > endPosition.x) {
        // Left swipe
        [self swipeLeft];
    }
}
#endif

- (void)update:(CCTime)delta {
    [_hero setupVehicle];
    
    // Rocket is fired -- LightRunner vehicle
    if (self.rocketFire) {
        _rocket.position = ccp(_rocket.position.x, _rocket.position.y + delta * _rocketSpeed);
    } else {
        _rocket.position = ccp(_rocket.position.x, _rocket.position.y + delta * _hero.getVehicleSpeed);
    }
    
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
                    [_hero setVehicleSpeed:210.f];
                } else if ([Stats instance].level == [NSNumber numberWithInt:2]) {
                    [_hero setVehicleSpeed:210.f];
                } else if ([Stats instance].level == [NSNumber numberWithInt:3]) {
                    [_hero setVehicleSpeed:245.f];
                } else if ([Stats instance].level == [NSNumber numberWithInt:4]) {
                    [_hero setVehicleSpeed:245.f];
                } else if ([Stats instance].level == [NSNumber numberWithInt:5]) {
                    [_hero setVehicleSpeed:245.f];
                }
            }
        }
    } else {
        [_hero setVehicleSpeed:0];
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
            
            obstacle.position = ccp(0, previousObstacleYPosition + 275.f);
            
        } else if ([[Stats instance].lasts objectAtIndex:0] == [NSNumber numberWithInteger:1] &&
                   [[Stats instance].lasts objectAtIndex:1] == [NSNumber numberWithInteger:5]) {
            
            obstacle.position = ccp(0, previousObstacleYPosition + 275.f);
            
        }
    }
    
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
    
    obstacle.zOrder = DrawingOrderObstacle;
}

- (NSString *)formatter:(NSInteger)toFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:toFormat];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    return formatted;
    
}

/*///////////////////////////////////////////
 *
 * Collisions
 *
 ///////////////////////////////////////////*/

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    
    // Check for two hearts car
    if ([_hero.getVehicleType isEqual:@"policeCar"] && _heartLeft.opacity == 1) {
        _particleHeartL.visible = TRUE;
        [_particleHeartL resetSystem];
        CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.5f opacity:0];
        [_heartLeft runAction:fade];
        
        // Credit invincibility to not "disable" the rest of the obstacle.
        _hero.physicsBody.collisionType = @"ability";
        [self performSelector:@selector(invokeInvicible) withObject:nil afterDelay:.5];
        
        // Track collisions
        NSInteger collision = [[Stats instance].collision integerValue];
        collision++;
        
        [Stats instance].collision = [NSNumber numberWithInteger:collision];
        
        return FALSE;
    } else {
        if ([_hero.getVehicleType isEqual:@"policeCar"]) {
            _particleHeartR.visible = TRUE;
            [_particleHeartR resetSystem];
            CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.5f opacity:0];
            [_heartRight runAction:fade];
        }
        
        [self gameOver];
        
        // Track collisions
        NSInteger collision = [[Stats instance].collision integerValue];
        collision++;
        
        [Stats instance].collision = [NSNumber numberWithInteger:collision];
        
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
    
    _scoreLabel.string = [self formatter:totalRunCoin];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ability:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    NSInteger coinReturn = [self getCoins];
    NSInteger totalRunCoin = _currentScore + coinReturn;
    
    _currentScore = totalRunCoin;
    
    _scoreLabel.string = [self formatter:totalRunCoin];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair rocket:(CCNode *)rocket level:(CCNode *)level {
    
    NSMutableArray *obstaclesToDelete = [[NSMutableArray alloc] init];
    
    CGPoint hitLocation = [self convertToWorldSpace:rocket.position];
    
    for (CCSprite *obstacle in _obstacles) {
        if (CGRectContainsPoint(obstacle.boundingBox, hitLocation)) {
            [obstaclesToDelete addObject:obstacle];
        }
    }
    
    for (CCSprite *obstacle in obstaclesToDelete) {
        [obstacle stopAllActions];
        [_obstacles removeObject:obstacle];
        [_physicsNode removeChild:obstacle cleanup:YES];
    }
    [rocket removeFromParentAndCleanup:YES];
    
    return TRUE;
}

- (NSInteger)getCoins {
    
    NSInteger coinAmount = 0;
        
    if ([Stats instance].level == [NSNumber numberWithInt:1]) {
        
        coinAmount = 10;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:2]) {
        
        coinAmount = 25;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:3]) {
        
        coinAmount = 50;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:4]) {
        
        coinAmount = 100;
        
    } else if ([Stats instance].level == [NSNumber numberWithInt:5]) {
        
        coinAmount = 150;
        
    }
    
    return coinAmount;
}

- (void)gameOver {
    if (!_gameOver) {
        [_hero onPause];
        [Stats instance].obstacleCount = 0;
        _gameOver = TRUE;
        _abilityButton.visible = FALSE;
        _pause.visible = FALSE;
        
        // Run to sperate gameover screen
        GameOver *gameOver = (GameOver *)[CCBReader load:@"GameOver"];
        gameOver.currentScore = _currentScore;
        [gameOver runGameOver];
        [self addChild:gameOver];
        
        // Hide coins
        _gamePlayCoin.visible = FALSE;
        _scoreLabel.visible = FALSE;
        
        // Handle animations
        CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.0f opacity:1];
        [_backgroundFade runAction:fade];
        
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
        
        
        // ANDROID
#if __CC_PLATFORM_ANDROID
        [self saveCustomObject:[Stats instance] key:@"stats"];
#endif
    }
}

/*///////////////////////////////////////////
*
* Buttons
*
///////////////////////////////////////////*/

- (void)menu {
    CCScene *scene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] pushScene:scene withTransition:[CCTransition transitionFadeWithDuration:.5]];
}

- (void)pause {
    CGFloat speedBefore = _hero.getVehicleSpeed;
    if (_paused == NO) {
        _paused = YES;
        [_hero onPause];
        [_hero setVehicleSpeed:0.f];
        _abilityButton.visible = FALSE;
        _pauseMenu.visible = TRUE;
        _pauseOptions.visible = TRUE;
        _pauseResume.visible = TRUE;
        
        _backgroundFade.opacity = 1;
        
        // Fix ability pause
        [_fireBall stopSystem];
//        _fireBall.visible = FALSE;
        
    } else {
        _paused = NO;
        [_hero onResume];
        [_hero setVehicleSpeed:speedBefore];
        _pauseMenu.visible = FALSE;
        _pauseOptions.visible = FALSE;
        _pauseResume.visible = FALSE;
        
        CCActionInterval *fade = [CCActionFadeTo actionWithDuration:.5f opacity:0];
        [_backgroundFade runAction:fade];
        
        if (self.shouldAbility == YES) {
            _abilityButton.visible = TRUE;
        }
    }
}

- (void)resume {
    [self pause];
}

- (void)options {
    // TODO: Add options
}

/*///////////////////////////////////////////
 *
 * Abilities
 *
 ///////////////////////////////////////////*/

- (void)ability {
    
    if ([_hero.getVehicleType isEqual:@"pickupTruck"]) {
        
        _abilityButton.visible = FALSE;
        [Stats instance].abilityUse = YES;
        [_hero setVehicleSpeed:120.f];
        NSNumber *speedBefore = [NSNumber numberWithFloat:_hero.getVehicleSpeed];
        self.shouldAbility = FALSE;
        
        [self performSelector:@selector(unfreeze:) withObject:speedBefore afterDelay:7.0];
        
    }
    
    if ([_hero.getVehicleType isEqual:@"lightRunner"]) {
        
        self.rocketFire = YES;
        _rocket.physicsBody.collisionType = @"rocket";
        _rocket.visible = TRUE;
        _rocketSpeed = 550.f;
//        _abilityButton.visible = FALSE;
        self.shouldAbility = FALSE;
        
    }
    
    if ([_hero.getVehicleType isEqual:@"sportsCar"]) {
    
        _hero.physicsBody.collisionType = @"ability";
        _abilityButton.visible = FALSE;
        _fireBall.visible = TRUE;
        [_fireBall resetSystem];
        NSNumber *speedBefore = [NSNumber numberWithFloat:_hero.getVehicleSpeed];
        [Stats instance].abilityUse = YES;
        [_hero setVehicleSpeed:500.f];
        self.shouldAbility = FALSE;
        
        [self performSelector:@selector(abilityStop:) withObject:speedBefore afterDelay:5.0];
        
    }
    
}

- (void)unfreeze:(NSNumber*)speedBefore {
    
    CGFloat speed = [speedBefore floatValue];
    
    if (_paused == NO) {
        [_hero setVehicleSpeed:speed];
        [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
    }
    
    [Stats instance].abilityUse = NO;
    
}

- (void)abilityStop:(NSNumber*)speedBefore {
    
    CGFloat speed = [speedBefore floatValue];
    
    if (_paused == NO) {
        [_hero setVehicleSpeed:speed];
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
    if (_paused == NO || _gameOver == YES) {
        _cooldownTimer.visible = TRUE;
    }
    NSInteger timer = [_cooldownTimer.string intValue];
    
    if (_paused == YES || _gameOver == YES) {
        
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

/*///////////////////////////////////////////
 *
 * User Interaction
 *
 ///////////////////////////////////////////*/

- (void)swipeLeft {
//    CCLOG(@"swipeLeft");
    if (!_gameOver) {
        if (!_paused) {
            [_hero moveLeft];
            /*
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
             */
        }
    }
}

- (void)swipeRight {
//    CCLOG(@"swipeRight");
    if (!_gameOver) {
        if (!_paused) {
            [_hero moveRight];
            /*
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
             */
        }
    }
    
}
/*
- (void)setZeroRight {
    _hero.rotation = -45.f;
}

- (void)setZeroLeft {
    _hero.rotation = -135.f;
}
*/
//- (void)tapLimitRecognizer:(UITapGestureRecognizer *)tapLimitRecognizer {
//    if (_abilityButton.visible)
//        [self ability];
//}

/*///////////////////////////////////////////
 *
 * Custom Actions
 *
 ///////////////////////////////////////////*/

- (void)saveCustomObject:(Stats *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

@end
