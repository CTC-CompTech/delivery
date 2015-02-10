//
//  randomObstacle.m
//  Delivery
//
//  Created by Grant Jennings on 2/6/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "randomObstacle.h"

@interface randomObstacle ()

@end

@implementation randomObstacle
static NSArray* _obstacleTextures;

-(id)init{
    if (self = [super init]){
        
        if (_obstacleTextures == nil){
            _obstacleTextures = [NSArray arrayWithObjects:[CCSpriteFrame frameWithImageNamed:@"Delivery/Obstacles/Bomb Obstacle.png"],[CCSpriteFrame frameWithImageNamed:@"Delivery/Obstacles/Road Block.png"],[CCSpriteFrame frameWithImageNamed:@"Delivery/Obstacles/Cones Obstacle.png"],[CCSpriteFrame frameWithImageNamed:@"Delivery/Obstacles/Brick Wall Obstacle.png"],nil];
        }
        
        
        self.spriteFrame = [_obstacleTextures objectAtIndex:arc4random_uniform(3)];
        self.rotation = 90;
        if (self.spriteFrame == [_obstacleTextures objectAtIndex:0]){
            self.rotation = -45;
        }
        
        self.scale = 0.703;
        self.physicsBody = [CCPhysicsBody bodyWithRect:CGRectMake(0, 0, self.boundingBox.size.width, self.boundingBox.size.height) cornerRadius:0];
        self.physicsBody.type = CCPhysicsBodyTypeStatic;
        self.physicsBody.collisionType = @"level";
        return self;
    }
    
    else return nil;
}

@end
