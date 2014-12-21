#import "MainScene.h"
#import "CCAnimation.h"

static const CGFloat scrollSpeed = 100.f;

@implementation MainScene {
    CCPhysicsNode *_physicsNode;
    CCNode *_ground1;
    CCNode *_ground2;
    CCNode *_hero;
    
    CGPoint firstTouch;
    CGPoint lastTouch;
    
    NSArray *_grounds;
}

- (void)didLoadFromCCB {
    _grounds = @[_ground1, _ground2];
    self.userInteractionEnabled = YES;
    
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
    _physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y - (scrollSpeed *delta));
    _hero.position = ccp(_hero.position.x, _hero.position.y + delta * scrollSpeed);
//    CCLOG(@"%@", NSStringFromCGPoint(_hero.position));
    // loop the ground
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
}

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    
}

- (void)swipeLeft {
    CCLOG(@"swipeLeft");
    CGPoint byPoint;
    if (_hero.position.x <= 50) {
        byPoint = ccp(0, 0);
    } else {
        byPoint = ccp(-64, 0);
    }
    [_hero runAction:[CCActionMoveBy actionWithDuration:0.1 position:byPoint]];
}
- (void)swipeRight {
    CCLOG(@"swipeRight");
    CGPoint byPoint;
    if (_hero.position.x >= 250) {
        byPoint = ccp(0, 0);
    } else {
        byPoint = ccp(64, 0);
    }
    [_hero runAction:[CCActionMoveBy actionWithDuration:0.1 position:byPoint]];
    
}

@end
