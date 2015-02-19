//
//  lifeMeter.h
//  Delivery
//
//  Created by Grant Jennings on 2/18/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface lifeMeter : CCNode

-(int)getLifeCount;
-(void)subtractLife;
-(void)addLife;
-(void)setLifes:(int)tempLife;

@end
