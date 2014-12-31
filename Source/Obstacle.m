//
//  Obstacle.m
//  Delivery
//
//  Created by Andrew Robinson on 12/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle {
    CCNode *_block1;
    CCNode *_block2;
    CCNode *_block3;
    CCNode *_block4;
    CCNode *_block5;
}

- (void)didLoadFromCCB {
    _block1.physicsBody.collisionType = @"level";
    _block1.physicsBody.sensor = TRUE;
    _block2.physicsBody.collisionType = @"level";
    _block2.physicsBody.sensor = TRUE;
    _block3.physicsBody.collisionType = @"level";
    _block3.physicsBody.sensor = TRUE;
    _block4.physicsBody.collisionType = @"level";
    _block4.physicsBody.sensor = TRUE;
    _block5.physicsBody.collisionType = @"level";
    _block5.physicsBody.sensor = TRUE;
}

- (void)setupRandomPosition {
    CGFloat random = (double)arc4random_uniform(101);
//    CCLOG(@"%f", random);
    if (random <= 20) {
        [_block1 removeFromParent];
    }
    if (random <= 40 && random > 20) {
        [_block2 removeFromParent];
    }
    if (random <= 60 && random > 40) {
        [_block3 removeFromParent];
    }
    if (random <= 80 && random > 60) {
        [_block4 removeFromParent];
    }
    if (random <= 100 && random > 80) {
        [_block5 removeFromParent];
    }
}

@end
