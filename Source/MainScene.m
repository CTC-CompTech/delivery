#import "MainScene.h"
#import "CCAnimation.h"
#import "fastObstacle.h"
#import "GameOver.h"
#import "Stats.h"
#import "musicRandomizer.h"

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

//@property (strong, nonatomic) CCSpriteFrame *heroFrame;

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
    CCParticleSystemBase *_rocketBoom;
    
    CCNode *_gameOverText;
    CCNode *_gameOverBackground;
    
    CCButton *_abilityButton;
    
    CCButton *_pauseOptions;
    CCButton *_pauseResume;
    CCButton *_pauseMenu;
    
    CCNode *_gamePlayCoin;
    CCNode *_backgroundFade;
    
    CCLightNode *_redLight;
    CCLightNode *_blueLight;
    
    CCLabelTTF *_scoreLabel;
    CCLabelTTF *_cooldownTimer;
    
    CCNode *_tutorial;
    CCNode *_tutorialSwipe;
    
    BOOL _gameOver;
    BOOL _paused;
    CGFloat distanceBetweenObstacles;
    
    CGFloat _rocketSpeed;
    
    CGPoint firstTouch;
    CGPoint lastTouch;
    
    NSMutableArray *_obstacles;
    
    NSArray *_grounds;
    
    lifeMeter* _lifeMeter;
    
    musicRandomizer* _musicHolder;
    
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

#pragma mark - Load

- (void)onEnter {
    [super onEnter];
//    if (_musicHolder == nil){
//        
//        _musicHolder = [[musicRandomizer alloc]init];
//        [self addChild:_musicHolder];
//    }
    
    if ([[Stats instance].whereTutorial isEqual:@"SuperPower"]) {
        
        [self performSelector:@selector(beginAbilityTutorial) withObject:nil afterDelay:2.0f];
        
    }
}

- (void)beginAbilityTutorial {
    
    [_hero onPause];
    _tutorial.visible = YES;
    
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
    
    // Launch constants
    [Stats instance].obstacleCount = 0;
    distanceBetweenObstacles = 250.f;
    
    [Stats instance].lasts = [[NSMutableArray alloc] initWithCapacity:2];
        
//    // Selcted car functions
//    CCSpriteFrame *policeCar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Police Car.png"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"selectedCar"] == nil) {
        CCSpriteFrame *defaultCar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Heros/Truck.png"];
        [_hero setSpriteFrame:defaultCar];
    } else {
        NSString *selectedCar = [defaults objectForKey:@"selectedCar"];
        
        CCSpriteFrame *car = [CCSpriteFrame frameWithImageNamed:selectedCar];
        [_hero setSpriteFrame:car];
    }
    
        _abilityButton.visible = FALSE;

    // <-- End selected car ---> \\
    
    // Expand the pause button's pressable area.
    [_pause setHitAreaExpansion:40.f];
    
    // Set life meter variable so the car instance can control it
    _hero.lifeMeter = _lifeMeter;
    
    // set this class as delegate
    _physicsNode.collisionDelegate = self;
    
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
#if __CC_PLATFORM_IOS
    UISwipeGestureRecognizer * swipeLeft= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeLeft)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeLeft];
    // listen for swipes to the right
    UISwipeGestureRecognizer * swipeRight= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRight)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer *swipeUp= [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp)];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    [[[CCDirector sharedDirector] view] addGestureRecognizer:swipeUp];
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

#pragma mark - Update

- (void)update:(CCTime)delta {
    [_hero setupVehicle];
    
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
        if (obstacleWorldPosition.y < -100) {
            if (offScreenObstacles == nil) {
                offScreenObstacles = [NSMutableArray array];
            }
            [offScreenObstacles addObject:obstacle];
        }
    }
    for (CCNode *obstacleToRemove in offScreenObstacles) {
        [obstacleToRemove removeFromParentAndCleanup:YES];
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
    fastObstacle *obstacle = [[fastObstacle alloc] init];
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

#pragma mark - Formatter

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

#pragma mark - Collisions

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(randomObstacle*)level {

        [self gameOver];
        
        // Track collisions
        NSInteger collision = [[Stats instance].collision integerValue];
        collision++;
        
        [Stats instance].collision = [NSNumber numberWithInteger:collision];
        
        return TRUE;
    
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair policeCar:(CCNode *)policeCar level:(CCNode *)level{
    if ([_hero.lifeMeter getLifeCount] > 0){
        _hero.physicsBody.collisionType = @"ability";
        [self performSelector:@selector(invokeInvinciblePoliceCar) withObject:nil afterDelay:.5];
        
        // Track collisions
        NSInteger collision = [[Stats instance].collision integerValue];
        collision++;
        
        [Stats instance].collision = [NSNumber numberWithInteger:collision];
        [_hero.lifeMeter subtractLife];
        
        return FALSE;
    }
    
    else {
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

-(void)invokeInvinciblePoliceCar{
    _hero.physicsBody.collisionType = @"policeCar";
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    _currentScore += [self getCoins];
    
    _scoreLabel.string = [self formatter:_currentScore];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair policeCar:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    _currentScore += [self getCoins];

    
    _scoreLabel.string = [self formatter:_currentScore];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ability:(CCNode *)hero goal:(CCNode *)goal {
    [goal removeFromParent];
    _currentScore += [self getCoins];
    _scoreLabel.string = [self formatter:_currentScore];
    return TRUE;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ability:(CCNode *)hero level:(CCNode *)level {
    CCActionFadeOut *fadeOut = [CCActionFadeOut actionWithDuration:.5f];
    [level runAction:fadeOut];
    
    [self performSelector:@selector(removeLevelAfterAbility:) withObject:level afterDelay:.5f];
    
    return TRUE;
}

- (void)removeLevelAfterAbility:(CCNode*)level {
    [level removeFromParent];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair rocket:(CCNode *)rocket level:(CCNode *)level {
    /*
    NSMutableArray *obstaclesToDelete = [[NSMutableArray alloc] init];
    
    CGPoint hitLocation = [_physicsNode convertToNodeSpace:[rocket convertToWorldSpace:rocket.position]];
    
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
     */
    
    CGPoint hitLocation = [_physicsNode convertToWorldSpace:rocket.position];

    _rocketBoom.position = hitLocation;
    _rocketBoom.visible = YES;
    [level removeFromParent];
    [_rocketBoom resetSystem];
    [rocket removeFromParent];
    
    return TRUE;
}

- (NSInteger)getCoins {
    
    NSInteger coinAmount = 0;
    
    switch ([Stats instance].level.integerValue) {
        case 1:
            coinAmount = 10;
            break;
        case 2:
            coinAmount = 25;
            break;
        case 3:
            coinAmount = 50;
            break;
        case 4:
            coinAmount = 100;
            break;
        case 5:
            coinAmount = 150;
            break;
            
        default:
            coinAmount = 50;
            break;
    }
    
    return coinAmount;
}

#pragma mark - Game Over

- (void)gameOver {
    if (!_gameOver) {
        [_hero onPause];
        [Stats instance].obstacleCount = 0;
        _gameOver = TRUE;
        _abilityButton.visible = FALSE;
        _pause.visible = FALSE;
        
        // Hide coins
        _gamePlayCoin.visible = FALSE;
        _scoreLabel.visible = FALSE;
        
        // ...And Heart counter...
        _lifeMeter.visible = FALSE;
        
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
        
        // Track games run
        NSInteger games = [[Stats instance].gameRuns integerValue];
        games++;
        
        [Stats instance].gameRuns = [NSNumber numberWithInteger:games];
        
        // Run to seperate gameover screen
        GameOver *gameOver = (GameOver *)[CCBReader load:@"GameOver"];
        gameOver.currentScore = _currentScore;
        [gameOver runGameOver];
        [self addChild:gameOver];
        
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

#pragma mark - Buttons

- (void)menu {
    CCScene *scene = [CCBReader loadAsScene:@"Menu"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionFadeWithDuration:.5]];
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

/*///////////////////////////////////////////
 *
 * Abilities
 *
 ///////////////////////////////////////////*/

#pragma mark - Abilities or what is left

- (void)ability {
    /*
    if ([_hero.getVehicleType isEqual:@"pickupTruck"]) {
        
        _abilityButton.visible = FALSE;
        [Stats instance].abilityUse = YES;
        [_hero setVehicleSpeed:120.f];
        NSNumber *speedBefore = [NSNumber numberWithFloat:_hero.getVehicleSpeed];
        self.shouldAbility = FALSE;
        
        [self performSelector:@selector(unfreeze:) withObject:speedBefore afterDelay:7.0];
        
    }
     */
    /*
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
    */
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

#pragma mark - User Interaction

- (void)swipeLeft {
//    CCLOG(@"swipeLeft");
    if (!_gameOver) {
        if (!_paused) {
            if ([[Stats instance].whereTutorial isEqual:@"Swipe"]) {
                
                // Unpause
                [_hero onResume];
                
                [_hero moveLeft];
                _tutorialSwipe.visible = NO;
                [Stats instance].whereTutorial = @"";
                
            } else {
                [_hero moveLeft];
            }
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
            if ([[Stats instance].whereTutorial isEqual:@"Swipe"]) {
                
                // Unpause
                [_hero onResume];
                
                [_hero moveRight];
                _tutorialSwipe.visible = NO;
                [Stats instance].whereTutorial = @"";
                
            } else {
                [_hero moveRight];
            }
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

- (void)swipeUp {
    [_hero useAbility];
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

#pragma mark - Custom Actions

- (void)saveCustomObject:(Stats *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

@end
