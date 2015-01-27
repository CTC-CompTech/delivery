//
//  runnerRocket.m
//  Delivery
//
//  Created by Grant Jennings on 1/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "runnerRocket.h"

@implementation runnerRocket


-(void)update:(CCTime)delta{
    self.position = ccp(self.position.x, self.position.y + (delta * self.movementSpeed));
}

@end
