//
//  gamecentercontrol.m
//  Delivery
//
//  Created by Michael Blades on 1/14/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "gamecentercontrol.h"

@interface gamecentercontrol () <GKGameCenterControllerDelegate> {
    
    BOOL _gameCenterFeaturesEnabled;
    
}
@end


@implementation gamecentercontrol

@synthesize gameCentreAvailable;

static gamecentercontrol *sharedControl = nil;
+ (gamecentercontrol *) sharedInstance {
    if (!sharedControl) {
        sharedControl = [[gamecentercontrol alloc]init];
    }
    return sharedControl;
}

-(BOOL)isGameCentreAvailable {
    // check for presence of GKLocalPlayer API
    Class gcClass = (NSClassFromString(@"GKLocalPlayer"));
    
    //check if the device is running iOS 4.1 or later
    NSString *reqSysVer = @"4.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    BOOL osVersionSupported = ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending);
    
    return (gcClass && osVersionSupported);
}

- (id)init {
    if ((self = [super init])) {
        
        gameCentreAvailable = [self isGameCentreAvailable];
        if (gameCentreAvailable) {
            NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
            [nc addObserver:self selector:@selector(authenticationChanged) name:GKPlayerAuthenticationDidChangeNotificationName object:nil];
        }
        
    }
    return self;
}


- (void)authenticationChanged {
    
    if ([GKLocalPlayer localPlayer].isAuthenticated && !userAuthenticated) {
        NSLog(@"Authentication Changed. User Authenticated");
        userAuthenticated = TRUE;
    }
    else if (![GKLocalPlayer localPlayer].isAuthenticated && userAuthenticated) {
        
        NSLog(@"Authentication Changed. User Not Authenticated");
        userAuthenticated = FALSE;
    }
    
}


-(void) authenticateLocalUser {
    if ([GKLocalPlayer localPlayer].authenticated == NO) {
        GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
        
        localPlayer.authenticateHandler = ^(UIViewController *gcvc,NSError *error) {
            
            if(gcvc) {
                [self presentViewController:gcvc];
            }
            else {
                _gameCenterFeaturesEnabled = NO;
            }
        };
    }
    
    else if ([GKLocalPlayer localPlayer].authenticated == YES){
        _gameCenterFeaturesEnabled = YES;
    }
    
}

-(UIViewController*) getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)gcvc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:gcvc animated:YES completion:nil];
}


-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    
    
} 
@end
