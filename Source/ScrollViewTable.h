//
//  ScrollViewTable.h
//  Delivery
//
//  Created by Michael Blades on 1/12/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "vehicleIncludes.h"

@interface ScrollViewTable : CCNode

@property NSInteger amountToTakeOut;
@property (strong, nonatomic) NSString *carTouched;
@property (strong, nonatomic) NSMutableArray *locks;

- (void)didWantToBuy;

- (id)init;
+ (ScrollViewTable*)instance;

@end
