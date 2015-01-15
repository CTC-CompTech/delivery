//
//  gamecentercontrol.h
//  Delivery
//
//  Created by Michael Blades on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GameKit/GameKit.h>

@interface gamecentercontrol : NSObject {
    
    BOOL gameCentreAvailable;
    BOOL userAuthenticated;
    
}

@property (assign, readonly) BOOL gameCentreAvailable;

+ (gamecentercontrol *)sharedInstance;

-(void)authenticateLocalUser;


@end
