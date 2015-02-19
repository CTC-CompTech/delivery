//
//  lifeMeter.m
//  Delivery
//
//  Created by Grant Jennings on 2/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "lifeMeter.h"

@implementation lifeMeter

int _lifeCount;

-(void)onEnter{
    [super onEnter];
    _lifeCount = 0;
}

-(int)getLifeCount{
    return _lifeCount;
}

-(void)subtractLife{
    [self setLifes:[self getLifeCount]-1];
}

-(void)addLife{
    [self setLifes:[self getLifeCount]+1];
}

-(void)setLifes:(int)tempLife{
    _lifeCount = tempLife;
    CCLabelTTF* tempCounter = (CCLabelTTF*)[self getChildByName:@"lifeCounter" recursively:NO];
    tempCounter.string = [NSString stringWithFormat:@"%i",tempLife];
}

@end
