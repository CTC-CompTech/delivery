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
    
    CCSprite *_difficulty;
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
    
    int value = [[MainScene instance].obstacleCount intValue];
    [MainScene instance].obstacleCount = [NSNumber numberWithInt:value + 1];
//    NSLog(@"%@", [MainScene instance].obstacleCount);
    
    if ([[MainScene instance].obstacleCount intValue] >= 0 && [[MainScene instance].obstacleCount intValue] <= 5) {
        [self removeBlockWithLevel:1];
//        CCLOG(@"Level 1");
    } else if ([[MainScene instance].obstacleCount intValue] > 5 && [[MainScene instance].obstacleCount intValue] <= 15) {
//        CCLOG(@"Level 2");
        [self removeBlockWithLevel:2];
    } else if ([[MainScene instance].obstacleCount intValue] > 15 && [[MainScene instance].obstacleCount intValue] <= 25) {
//        CCLOG(@"Level 3");
        [self removeBlockWithLevel:3];
    } else if ([[MainScene instance].obstacleCount intValue] > 25 && [[MainScene instance].obstacleCount intValue] <= 40) {
//        CCLOG(@"Level 4");
        [self removeBlockWithLevel:4];
    } else {
//        CCLOG(@"Level 5");
        [self removeBlockWithLevel:5];
    }
//    [self removeBlockWithLevel:4];
}

- (void)removeBlockWithLevel:(int)level {
    
    NSInteger lane1, lane2;
    
    if (level == 1) {
        lane1 = [self getLane];
        
        do {
            lane2 = [self getLane];
        } while ( lane1 == lane2 );
        
        [MainScene instance].level = [NSNumber numberWithInt:1];
        [MainScene instance].obstacleDistance = [NSNumber numberWithFloat:250.f];
        
        [self removeBlock:lane1];
        [self removeBlock:lane2];

    } else if (level == 2) {
        lane1 = [self getLane];
        
        [MainScene instance].level = [NSNumber numberWithInt:2];
        [MainScene instance].obstacleDistance = [NSNumber numberWithFloat:250.f];
        
        [self removeBlock:lane1];
        
    } else if (level == 3) {
        lane1 = [self getLane];
        
        [MainScene instance].level = [NSNumber numberWithInt:3];
        [MainScene instance].obstacleDistance = [NSNumber numberWithFloat:250.f];
        
        [self removeBlock:lane1];
        
    } else if (level == 4) {
        lane1 = [self getLane];
        
        [MainScene instance].level = [NSNumber numberWithInt:4];
        [MainScene instance].obstacleDistance = [NSNumber numberWithFloat:200.f];
        
        [self removeBlock:lane1];
        
    } else if (level == 5) {
        lane1 = [self getLane];
        
        [MainScene instance].level = [NSNumber numberWithInt:5];
        [MainScene instance].obstacleDistance = [NSNumber numberWithFloat:200.f];
        
        [self removeBlock:lane1];
        
    }
}

- (void)removeBlock:(NSInteger)block {
    if (block == 1) {
        [_block1 removeFromParent];
        
//        if ([[MainScene instance].lasts count] == 0) {
//            NSNumber *thisBlock = [NSNumber numberWithInteger:block];
//            [[MainScene instance].lasts addObject:thisBlock];
//        } else {
//            NSNumber *first = [NSNumber numberWithInteger:5];
//            if ([[MainScene instance].lasts objectAtIndex:0] == first) {
//                NSNumber *thisBlock = [NSNumber numberWithInteger:block];
//                [[MainScene instance].lasts setObject:thisBlock atIndexedSubscript:0];
//                
//                [[MainScene instance].lasts setObject:first atIndexedSubscript:1];
//            }
//        }
        
    } else if (block == 2) {
        [_block2 removeFromParent];
    } else if (block == 3) {
        [_block3 removeFromParent];
    } else if (block == 4) {
        [_block4 removeFromParent];
    } else if (block == 5) {
        [_block5 removeFromParent];
        
//        if ([[MainScene instance].lasts count] == 0) {
//            NSNumber *thisBlock = [NSNumber numberWithInteger:block];
//            [[MainScene instance].lasts addObject:thisBlock];
//        } else {
//            NSNumber *first = [NSNumber numberWithInteger:1];
//            if ([[MainScene instance].lasts objectAtIndex:0] == first) {
//                NSNumber *thisBlock = [NSNumber numberWithInteger:block];
//                [[MainScene instance].lasts setObject:thisBlock atIndexedSubscript:0];
//        
//                [[MainScene instance].lasts setObject:first atIndexedSubscript:1];
//            }
//        }
    }
    
    if ([[MainScene instance].lasts count] == 0) {
        NSNumber *thisBlock = [NSNumber numberWithInteger:block];
        [[MainScene instance].lasts addObject:thisBlock];
    } else {
        NSNumber *first = [[MainScene instance].lasts objectAtIndex:0];
        [[MainScene instance].lasts setObject:first atIndexedSubscript:1];
        
        NSNumber *thisBlock = [NSNumber numberWithInteger:block];
        [[MainScene instance].lasts setObject:thisBlock atIndexedSubscript:0];
    }
}

- (NSInteger)getLane {
    CGFloat random = (double)arc4random_uniform(101);
    NSInteger ret = 1;
    
    if (random <= 20) {
        ret = 1;
    } else if (random <= 40 && random > 20) {
        ret = 2;
    } else if (random <= 60 && random > 40) {
        ret = 3;
    } else if (random <= 80 && random > 60) {
        ret = 4;
    } else if (random <= 100 && random > 80) {
        ret = 5;
    }
    
    return ret;
}

@end
