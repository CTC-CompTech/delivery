//
//  Alert.h
//  Delivery
//
//  Created by Michael Blades on 2/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Alert : CCNode

- (void)runAlertWithAmount:(NSInteger)passedAmount;
- (void)runOkayAlertScrollView;
- (void)runAlertReset;

@end
