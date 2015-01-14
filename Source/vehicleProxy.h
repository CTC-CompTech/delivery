//
//  vehicleProxy.h
//  Delivery
//
//  Created by Grant Jennings on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "defaultVehicle.h"

@interface vehicleProxy : CCNode

// Reference to a car that does all the real behavior
@property () defaultVehicle *containedCar;

@end
