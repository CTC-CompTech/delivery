//
//  fastObstacle.m
//  Delivery
//
//  Created by Grant Jennings on 2/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "fastObstacle.h"
#import "Stats.h"

@interface fastObstacle ()

@property (nonatomic) CCSprite* block1;
@property (nonatomic) CCSprite* block2;
@property (nonatomic) CCSprite* block3;
@property (nonatomic) CCSprite* block4;
@property (nonatomic) CCSprite* block5;
@property (nonatomic) CCNode* goal;

-(void)removeBlockWithLevel:(int)level;
-(void)removeBlock:(int)block;
-(int)getObstacle;
-(int)getLane;

@end



@implementation fastObstacle

-(id)init{
    if (self = [super init]){
        self.block1 = [[randomObstacle alloc] init];
        self.block1.position = ccp(34, 20);
        self.block2 = [[randomObstacle alloc] init];
        self.block2.position = ccp(96, 20);
        self.block3 = [[randomObstacle alloc] init];
        self.block3.position = ccp(159, 20);
        self.block4 = [[randomObstacle alloc] init];
        self.block4.position = ccp(223, 20);
        self.block5 = [[randomObstacle alloc] init];
        self.block5.position = ccp(287, 20);
        self.goal = [CCNode node];
        self.goal.anchorPoint = ccp(0,0);
        self.goal.contentSize = CGSizeMake(320, 10);
        self.goal.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, 320, 18) cornerRadius:0];
        self.goal.physicsBody.type = CCPhysicsBodyTypeStatic;
        self.goal.physicsBody.collisionType = @"goal";
        self.goal.physicsBody.sensor = TRUE;
        [self addChild:self.block1];
        [self addChild:self.block2];
        [self addChild:self.block3];
        [self addChild:self.block4];
        [self addChild:self.block5];
        [self addChild:self.goal];
        return self;
    }
    else return nil;
}

- (void)setupRandomPosition {
    
    int value = [[Stats instance].obstacleCount intValue];
    [Stats instance].obstacleCount = [NSNumber numberWithInt:value + 1];
    //    NSLog(@"%@", [Stats instance].obstacleCount);

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
    
    int lane1, lane2;
    
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

- (void)removeBlock:(int)block {
    switch (block) {
        case 1:
            [_block1 removeFromParent];
        break;
            
        case 2:
            [_block2 removeFromParent];
        break;
            
        case 3:
            [_block3 removeFromParent];
        break;
            
        case 4:
            [_block4 removeFromParent];
        break;
            
        case 5:
            [_block5 removeFromParent];
        break;

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

- (int)getObstacle {
    return arc4random_uniform(3) + 1;
}

- (int)getLane {
    return arc4random_uniform(5) + 1;
}

@end
