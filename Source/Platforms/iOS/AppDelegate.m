/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2012 Zynga Inc.
 * Copyright (c) 2013 Apportable Inc.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "cocos2d.h"

#import "AppDelegate.h"
#import "CCBuilderReader.h"

#import "Stats.h"
#import "gamecentercontrol.h"

@implementation AppController

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Configure Cocos2d with the options set in SpriteBuilder
    NSString* configPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Published-iOS"]; // TODO: add support for Published-Android support
    configPath = [configPath stringByAppendingPathComponent:@"configCocos2d.plist"];
    
    NSMutableDictionary* cocos2dSetup = [NSMutableDictionary dictionaryWithContentsOfFile:configPath];
    
    // Note: this needs to happen before configureCCFileUtils is called, because we need apportable to correctly setup the screen scale factor.
#ifdef APPORTABLE
    if([cocos2dSetup[CCSetupScreenMode] isEqual:CCScreenModeFixed])
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenAspectFitEmulationMode];
    else
        [UIScreen mainScreen].currentMode = [UIScreenMode emulatedMode:UIScreenScaledAspectFitEmulationMode];
#endif
    
    // Configure CCFileUtils to work with SpriteBuilder
    [CCBReader configureCCFileUtils];
    
    // Do any extra configuration of Cocos2d here (the example line changes the pixel format for faster rendering, but with less colors)
    //[cocos2dSetup setObject:kEAGLColorFormatRGB565 forKey:CCConfigPixelFormat];
    
    [self setupCocos2dWithOptions:cocos2dSetup];
    
    // Load defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stats"] != nil) {
        Stats *stats = [self loadCustomObjectWithKey:@"stats"];
        
        // Make the stats
        [Stats instance].currentCoin = stats.currentCoin;
        [Stats instance].totalCoin = stats.totalCoin;
        [Stats instance].collision = stats.collision;
        [Stats instance].gameRuns = stats.gameRuns;
        [Stats instance].loginDate = stats.loginDate;
        [Stats instance].bestCoin = stats.bestCoin;
        
        [Stats instance].ownedCars = stats.ownedCars;
        
        [Stats instance].shouldTutorial = stats.shouldTutorial;
        [Stats instance].whereTutorial = stats.whereTutorial;
        
        if (![Stats instance].ownedCars) {
            
            [Stats instance].ownedCars = [[NSMutableArray alloc] initWithObjects:stats.ownedCars, nil];
            
//            [[Stats instance].ownedCars addObject:[NSString stringWithFormat:@"DeliveryTruck"]];
//            NSLog(@"%@", [Stats instance].ownedCars);
            
        }
    }
    
    // Game Center
    [[gamecentercontrol sharedInstance] authenticateLocalUser];
    
    // Coin-per-day
    NSDate *currentDate = [NSDate date];
    
    NSDate *lastDate = [Stats instance].loginDate;
    
    if ([self isSameDayWithDate1:currentDate date2:lastDate] == YES) {
        
        NSLog(@"CurrentDate is same");
        
    } else {
        
        NSLog(@"CurrentDate is different");
        
        NSInteger currentCoinCount = [[Stats instance].currentCoin integerValue];
        NSInteger totalCoinCount = [[Stats instance].totalCoin integerValue];
        
        NSInteger currentDayCoin = currentCoinCount + 3000;
        NSInteger totalDayCoin = totalCoinCount + 3000;
        
        [Stats instance].currentCoin = [NSNumber numberWithInteger:currentDayCoin];
        [Stats instance].totalCoin = [NSNumber numberWithInteger:totalDayCoin];
        
    }
    
    [Stats instance].loginDate = currentDate;
    
    return YES;
}

- (CCScene*) startScene
{
    
    if ([[Stats instance].whereTutorial isEqual:@"Menu"]) {
        return [CCBReader loadAsScene:@"Menu"];
    } else if ([[Stats instance].whereTutorial isEqual:@"CarMenu"]) {
        return [CCBReader loadAsScene:@"CarMenu"];
    } else {
        return [CCBReader loadAsScene:@"Menu"];
    }
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // This needs to be here, otherwise this method won't work.
    [[CCDirector sharedDirector] stopAnimation];
    
    //    Stats *stats = [[Stats alloc] init];
    [self saveCustomObject:[Stats instance] key:@"stats"];
    
}

- (void)saveCustomObject:(Stats *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

- (Stats *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Stats *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}

- (BOOL)isSameDayWithDate1:(NSDate*)date1 date2:(NSDate*)date2 {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
