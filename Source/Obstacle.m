//
//  Obstacle.m
//  Delivery
//
//  Created by Andrew Robinson on 12/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Obstacle.h"

@implementation Obstacle {
    CCSprite *_block1;
    CCSprite *_block2;
    CCSprite *_block3;
    CCSprite *_block4;
    CCSprite *_block5;
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
    
    int value = [[Stats instance].obstacleCount intValue];
    [Stats instance].obstacleCount = [NSNumber numberWithInt:value + 1];
//    NSLog(@"%@", [Stats instance].obstacleCount);
    
    // Can disable or enable
    BOOL randomObstacles = YES;
    
    // Random obstacles
    if (randomObstacles == YES) {
        [self setFrames];
    }
    
    if ([[Stats instance].obstacleCount intValue] >= 0 && [[Stats instance].obstacleCount intValue] <= 5) {
        [self removeBlockWithLevel:1];
//        CCLOG(@"Level 1");
    } else if ([[Stats instance].obstacleCount intValue] > 5 && [[Stats instance].obstacleCount intValue] <= 15) {
//        CCLOG(@"Level 2");
        [self removeBlockWithLevel:2];
    } else if ([[Stats instance].obstacleCount intValue] > 15 && [[Stats instance].obstacleCount intValue] <= 25) {
//        CCLOG(@"Level 3");
        [self removeBlockWithLevel:3];
    } else if ([[Stats instance].obstacleCount intValue] > 25 && [[Stats instance].obstacleCount intValue] <= 40) {
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
        
        [Stats instance].level = [NSNumber numberWithInt:1];
        [Stats instance].obstacleDistance = [NSNumber numberWithFloat:250.f];
        
        [self removeBlock:lane1];
        [self removeBlock:lane2];

    } else if (level == 2) {
        lane1 = [self getLane];
        
        [Stats instance].level = [NSNumber numberWithInt:2];
        [Stats instance].obstacleDistance = [NSNumber numberWithFloat:250.f];
        
        [self removeBlock:lane1];
        
    } else if (level == 3) {
        lane1 = [self getLane];
        
        [Stats instance].level = [NSNumber numberWithInt:3];
        [Stats instance].obstacleDistance = [NSNumber numberWithFloat:250.f];
        
        [self removeBlock:lane1];
        
    } else if (level == 4) {
        lane1 = [self getLane];
        
        [Stats instance].level = [NSNumber numberWithInt:4];
        [Stats instance].obstacleDistance = [NSNumber numberWithFloat:200.f];
        
        [self removeBlock:lane1];
        
    } else if (level == 5) {
        lane1 = [self getLane];
        
        [Stats instance].level = [NSNumber numberWithInt:5];
        [Stats instance].obstacleDistance = [NSNumber numberWithFloat:200.f];
        
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
    
    if ([[Stats instance].lasts count] == 0) {
        NSNumber *thisBlock = [NSNumber numberWithInteger:block];
        [[Stats instance].lasts addObject:thisBlock];
    } else {
        NSNumber *first = [[Stats instance].lasts objectAtIndex:0];
        [[Stats instance].lasts setObject:first atIndexedSubscript:1];
        
        NSNumber *thisBlock = [NSNumber numberWithInteger:block];
        [[Stats instance].lasts setObject:thisBlock atIndexedSubscript:0];
    }
}

- (void)setFrames {
    
    for (int i = 0; i < 5; i++) {
        
        NSInteger obstacleNum = [self getObstacle];
        NSString *frame;
        
        switch (obstacleNum) {
            case 1:
                frame = @"Delivery/Road Block.png";
                break;
            case 2:
                frame = @"Delivery/Bomb Obstacle.png";
                break;
            case 3:
                frame = @"Delivery/Cones Obstacle.png";
                break;
            case 4:
                frame = @"Delivery/Brick Wall Obstacle.png";
                break;
            default:
                frame = @"Delivery/Road Block.png";
                break;
        }
        
        CCSpriteFrame *obstacleFrame = [CCSpriteFrame frameWithImageNamed:frame];
        
        switch (i) {
            case 1:
                [_block1 setSpriteFrame:obstacleFrame];
                if ([frame isEqual: @"Delivery/Bomb Obstacle.png"]) {
                    _block1.rotation = -45;
                }
                break;
            case 2:
                [_block2 setSpriteFrame:obstacleFrame];
                if ([frame isEqual: @"Delivery/Bomb Obstacle.png"]) {
                    _block2.rotation = -45;
                }
                break;
            case 3:
                [_block3 setSpriteFrame:obstacleFrame];
                if ([frame isEqual: @"Delivery/Bomb Obstacle.png"]) {
                    _block3.rotation = -45;
                }
                break;
            case 4:
                [_block4 setSpriteFrame:obstacleFrame];
                if ([frame isEqual: @"Delivery/Bomb Obstacle.png"]) {
                    _block4.rotation = -45;
                }
                break;
            case 5:
                [_block5 setSpriteFrame:obstacleFrame];
                if ([frame isEqual: @"Delivery/Bomb Obstacle.png"]) {
                    _block5.rotation = -45;
                }
                break;
        }
        
    }
    
}

- (NSInteger)getObstacle {
    CGFloat random = (double)arc4random_uniform(101);
    NSInteger ret = 1;
    
    if (random <= 25) {
        ret = 1;
    } else if (random <= 50 && random > 25) {
        ret = 2;
    } else if (random <= 75 && random > 50) {
        ret = 3;
    } else if (random <= 100 && random > 75) {
        ret = 4;
    }
    
    return ret;
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
