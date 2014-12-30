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

- (void)setupRandomPosition {
    
    CGFloat random = (double)arc4random_uniform(101);
    CCLOG(@"%f", random);
    if (random <= 20) {
        _block1.visible = NO;
    }
    if (random <= 40 && random > 20) {
        _block2.visible = NO;
    }
    if (random <= 60 && random > 40) {
        _block3.visible = NO;
    }
    if (random <= 80 && random > 60) {
        _block4.visible = NO;
    }
    if (random <= 100 && random > 80) {
        _block5.visible = NO;
    }
    
    _block1.position = ccp(_block1.position.x, _block1.position.y);
//    _bottomPipe.position = ccp(_bottomPipe.position.x, _topPipe.position.y + pipeDistance);
}

@end
