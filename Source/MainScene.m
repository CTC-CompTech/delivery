#import "MainScene.h"
#import "CCAnimation.h"
#import "Obstacle.h"

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderGround,
    DrawingOrderObstacle,
    DrawingOrderHero
};

//static const CGFloat scrollSpeed = 100.f;
static const CGFloat firstObstaclePosition = 450.f;
//static const CGFloat distanceBetweenObstacles = 250.f;

static MainScene *inst = nil;

@interface MainScene ()

@property (strong, nonatomic) CCSpriteFrame *heroFrame;

@property (strong, nonatomic) CCSpriteFrame *policeCarFrame;

@end

@implementation MainScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCSprite *_hero;
    
    CCSprite *_difficulty;
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
    
    BOOL _gameOver;
    BOOL _paused;
    CGFloat _scrollSpeed;
    CGFloat distanceBetweenObstacles;
    
    CGPoint firstTouch;
    CGPoint lastTouch;
    
    NSMutableArray *_obstacles;
    
    NSArray *_grounds;
    
}

- (id)init {
    if(self=[super init]) {
        self.obstacleCount = 0;
    }
    return self;
}
+ (MainScene*)instance {
    if (!inst) {
        inst = [[MainScene alloc] init];
    }
    return inst;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
    
    // Launch constants
    [MainScene instance].obstacleCount = 0;
    distanceBetweenObstacles = 250.f;
    
    [MainScene instance].lasts = [[NSMutableArray alloc] initWithCapacity:2];
    
    CCSpriteFrame *jeep = [CCSpriteFrame frameWithImageNamed:@"Delivery/Jeep.png"];
    
    CCSpriteFrame *policeCar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Police Car.png"];
    self.policeCarFrame = policeCar;
    
    CCSpriteFrame *pickupTruck = [CCSpriteFrame frameWithImageNamed:@"Delivery/Pickup Truck.png"];
    
    CCSpriteFrame *sportsCar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Sports Car.png"];
    
    CCSpriteFrame *lightRunner = [CCSpriteFrame frameWithImageNamed:@"Delivery/Light Runner.png"];
    
    [_hero setSpriteFrame:policeCar];
    self.heroFrame = _hero.spriteFrame;
    
    if (_hero.spriteFrame == jeep || policeCar || pickupTruck || lightRunner) {
        _abilityButton.visible = FALSE;
    }
    
    if (_hero.spriteFrame == sportsCar) {
        _abilityButton.visible = TRUE;
    }
    
    if (_hero.spriteFrame == jeep || sportsCar || pickupTruck || lightRunner) {
        _heartHolder.visible = FALSE;
        _heartLeft.visible = FALSE;
        _heartRight.visible = FALSE;
    }
    
    if (_hero.spriteFrame == policeCar) {
        _heartHolder.visible = TRUE;
        _heartLeft.visible = TRUE;
        _heartRight.visible = TRUE;
    }
    
//    _scrollSpeed = 100.f;
    
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
    distanceBetweenObstacles = [[MainScene instance].obstacleDistance floatValue];
    
    if (_gameOver != YES) {
        if (_paused != YES) {
            if ([MainScene instance].abilityUse == NO) {
                if ([MainScene instance].level == [NSNumber numberWithInt:1]) {
                    _scrollSpeed = 175.f;
                    CCSpriteFrame *bar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Bar_Easy.png"];
                    [_difficulty setSpriteFrame:bar];
                } else if ([MainScene instance].level == [NSNumber numberWithInt:2]) {
                    _scrollSpeed = 175.f;
                    CCSpriteFrame *bar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Bar_Okay.png"];
                    [_difficulty setSpriteFrame:bar];
                } else if ([MainScene instance].level == [NSNumber numberWithInt:3]) {
                    _scrollSpeed = 210.f;
                    CCSpriteFrame *bar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Bar_Decent.png"];
                    [_difficulty setSpriteFrame:bar];
                } else if ([MainScene instance].level == [NSNumber numberWithInt:4]) {
                    _scrollSpeed = 210.f;
                    CCSpriteFrame *bar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Bar_Close.png"];
                    [_difficulty setSpriteFrame:bar];
                } else if ([MainScene instance].level == [NSNumber numberWithInt:5]) {
                    _scrollSpeed = 210.f;
                    CCSpriteFrame *bar = [CCSpriteFrame frameWithImageNamed:@"Delivery/Bar_Max.png"];
                    [_difficulty setSpriteFrame:bar];
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
    
    if ([[MainScene instance].lasts count] == 2) {
        if ([[MainScene instance].lasts objectAtIndex:0] == [NSNumber numberWithInteger:5] &&
            [[MainScene instance].lasts objectAtIndex:1] == [NSNumber numberWithInteger:1]) {
            
            obstacle.position = ccp(0, previousObstacleYPosition + 250.f);
            
        } else if ([[MainScene instance].lasts objectAtIndex:0] == [NSNumber numberWithInteger:1] &&
                   [[MainScene instance].lasts objectAtIndex:1] == [NSNumber numberWithInteger:5]) {
            
            obstacle.position = ccp(0, previousObstacleYPosition + 250.f);
            
        }
    }
    
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
    
    obstacle.zOrder = DrawingOrderObstacle;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    
    // Check for two hearts car
    if (self.heroFrame == self.policeCarFrame && _heartLeft.opacity == 1) {
        _particleHeartL.visible = TRUE;
        [_particleHeartL resetSystem];
        CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.5f opacity:0];
        [_heartLeft runAction:fade];
        return FALSE;
    } else {
        if (self.heroFrame == self.policeCarFrame) {
            _particleHeartR.visible = TRUE;
            [_particleHeartR resetSystem];
            CCActionInterval *fade = [CCActionFadeTo actionWithDuration:1.5f opacity:0];
            [_heartRight runAction:fade];
        }
        
        [self gameOver];
        return TRUE;
    }
}

- (void)gameOver {
    if (!_gameOver) {
        [MainScene instance].obstacleCount = 0;
        _gameOver = TRUE;
        _abilityButton.visible = FALSE;
        _pause.visible = FALSE;
        _restartButton.visible = TRUE;
        _backButton.visible = TRUE;
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
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)pause {
    CGFloat speedBefore = _scrollSpeed;
    BOOL abilityHide = _abilityButton.visible;
    if (_paused == NO) {
        _paused = YES;
        _scrollSpeed = 0.f;
        _abilityButton.visible = FALSE;
        _difficulty.visible = FALSE;
    } else {
        _paused = NO;
        _scrollSpeed = speedBefore;
        
        if (abilityHide == YES) {
            _abilityButton.visible = TRUE;
        }
        
        _difficulty.visible = TRUE;
    }
}

- (void)ability {
    _hero.physicsBody.collisionType = @"";
    _abilityButton.visible = FALSE;
    _fireBall.visible = TRUE;
   [_fireBall resetSystem];
    CGFloat speedBefore = _scrollSpeed;
    [MainScene instance].abilityUse = YES;
    _scrollSpeed = 500.f;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [NSThread sleepForTimeInterval:5.0f];
        dispatch_async(dispatch_get_main_queue(), ^{
            //Here you returns to main thread.
//            _scrollSpeed = speedBefore;
            _scrollSpeed = speedBefore;
            [MainScene instance].abilityUse = NO;
            [_fireBall stopSystem];
            // Speed may land on obstacle -- Give longer invinciblility
            [self performSelector:@selector(delayPerfect) withObject:nil afterDelay:1.0];
        });
    });
}

- (void)delayPerfect {
    CCLOG(@"Invincibility ended.");
    _hero.physicsBody.collisionType = @"hero";
    _abilityButton.visible = TRUE;
//    _fireBall.visible = FALSE;
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
    _hero.rotation = 45.f;
}

@end
