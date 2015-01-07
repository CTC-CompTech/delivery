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

@implementation MainScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_hero;
    
    CCButton *_restartButton;
    CCButton *_abilityButton;
    
    BOOL _gameOver;
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
        if ([MainScene instance].abilityUse == NO) {
            if ([MainScene instance].level == [NSNumber numberWithInt:1]) {
                _scrollSpeed = 175.f;
            } else if ([MainScene instance].level == [NSNumber numberWithInt:2]) {
                _scrollSpeed = 175.f;
            } else if ([MainScene instance].level == [NSNumber numberWithInt:3]) {
                _scrollSpeed = 210.f;
            } else if ([MainScene instance].level == [NSNumber numberWithInt:4]) {
                _scrollSpeed = 210.f;
            } else if ([MainScene instance].level == [NSNumber numberWithInt:5]) {
                _scrollSpeed = 210.f;
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
    [self gameOver];
    return TRUE;
}

- (void)gameOver {
    if (!_gameOver) {
        [MainScene instance].obstacleCount = 0;
        _gameOver = TRUE;
        _abilityButton.visible = FALSE;
        _restartButton.visible = TRUE;
//        _hero.rotation = 90.f;
//        _hero.physicsBody.allowsRotation = FALSE;
        [_hero stopAllActions];
        CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.2f position:ccp(-6, 6)];
        CCActionInterval *reverseMovement = [moveBy reverse];
        CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
        CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
        [self runAction:bounce];
    }
}

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)ability {
    _hero.physicsBody.collisionType = @"";
    _abilityButton.visible = FALSE;
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
            _abilityButton.visible = TRUE;
            _hero.physicsBody.collisionType = @"hero";
        });
    });
}

- (void)swipeLeft {
//    CCLOG(@"swipeLeft");
    if (!_gameOver) {
        CGPoint byPoint;
        if (_hero.position.x <= 50) {
            byPoint = ccp(0, 0);
        } else {
            byPoint = ccp(-64, 0);
        }
    [_hero runAction:[CCActionMoveBy actionWithDuration:0.075 position:byPoint]];
    }
}

- (void)swipeRight {
//    CCLOG(@"swipeRight");
    if (!_gameOver) {
        CGPoint byPoint;
        if (_hero.position.x >= 250) {
            byPoint = ccp(0, 0);
        } else {
            byPoint = ccp(64, 0);
        }
    [_hero runAction:[CCActionMoveBy actionWithDuration:0.075 position:byPoint]];
    }
    
}

@end
