#import "MainScene.h"
#import "CCAnimation.h"
#import "Obstacle.h"

//static const CGFloat scrollSpeed = 100.f;
static const CGFloat firstObstaclePosition = 450.f;
static const CGFloat distanceBetweenObstacles = 250.f;

static MainScene *inst = nil;

@implementation MainScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_hero;
    
    CCButton *_restartButton;
    
    BOOL _gameOver;
    CGFloat _scrollSpeed;
    
    CGPoint firstTouch;
    CGPoint lastTouch;
    
    NSMutableArray *_obstacles;
    
    NSArray *_grounds;
    
}

@synthesize obstacleCount;

- (id)init {
    if(self=[super init]) {
        self.obstacleCount = 0;
    }
    return self;
}
+ (MainScene*)instance {
    if (!inst) inst = [[MainScene alloc] init];
    return inst;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
    
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
    
    
    if ([[MainScene instance].obstacleCount floatValue] >= 20 && _gameOver != TRUE) {
        _scrollSpeed = 210.f;
    } else if ([[MainScene instance].obstacleCount floatValue] <= 20 && _gameOver != TRUE){
        _scrollSpeed = 175.f;
    } else if (_gameOver == TRUE) {
        _scrollSpeed = 0.f;
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
    [_physicsNode addChild:obstacle];
    [_obstacles addObject:obstacle];
    
//    obstacle.zOrder = DrawingOrderPipes;
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)hero level:(CCNode *)level {
    [self gameOver];
    return TRUE;
}

- (void)gameOver {
    if (!_gameOver) {
        _gameOver = TRUE;
        _restartButton.visible = TRUE;
        _hero.rotation = 90.f;
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
