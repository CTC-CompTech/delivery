#import "MainScene.h"

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
    CGPoint point;
    if (_hero.position.x == 96) {
        point = ccp(34, _hero.position.y);
    }
    if (_hero.position.x == 159) {
        point = ccp(96, _hero.position.y);
    }
    if (_hero.position.x == 224) {
        point = ccp(159, _hero.position.y);
    }
    if (_hero.position.x == 287) {
        point = ccp(224, _hero.position.y);
    }
    
    _hero.position = point;
    
//    CCAnimation *walkAnim = [CCAnimation animationWithFrames:_hero delay:0.1 ];
//    [_hero runAction:[CCAnimate actionWithAnimation: walkAnim restoreOriginalFrame:YES]];
    
//    [_hero runAction:[CCMoveTo actionWithDuration:0.3 position:point]];
}
- (void)swipeRight {
    CCLOG(@"swipeRight");
    CGPoint point;
    if (_hero.position.x == 34) {
        point = ccp(96, _hero.position.y);
    }
    if (_hero.position.x == 96) {
        point = ccp(159, _hero.position.y);
    }
    if (_hero.position.x == 159) {
        point = ccp(224, _hero.position.y);
    }
    if (_hero.position.x == 224) {
        point = ccp(287, _hero.position.y);
    }
    
    _hero.position = point;
}

@end
