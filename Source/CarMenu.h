//
//  CarMenu.h
//  Delivery
//
//  Created by Michael Blades on 1/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface CarMenu : CCNode

-(id)init;
+(CarMenu*)instance;

@property (retain) NSString *titleCar;

@property BOOL isMoving;
@property BOOL shouldMove;
@property BOOL didPressWhileMoving;

-(void)changeTutorial;

@end
