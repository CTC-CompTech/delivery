//
//  randomObstacle.h
//  Delivery
//
//  Created by Grant Jennings on 2/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface randomObstacle : CCSprite

@property (nonatomic, readonly) int obstacleIndex;
-(int)getObstacleType;

@end

typedef enum {
    obstacleBomb,
    obstacleRoadBlock,
    obstacleCone,
    obstacleWall
} obstacleType;
