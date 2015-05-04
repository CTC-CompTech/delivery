/*
 * SpriteBuilder: http://www.spritebuilder.org
 *
 * Copyright (c) 2014 Apportable Inc.
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


#import "DeliveryActivity.h"

#import <AndroidKit/AndroidKeyEvent.h>

#import "Stats.h"

@implementation DeliveryActivity

- (CCScene *)startScene
{
    
    // Load defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"stats"] != nil) {
        Stats *stats = [self loadCustomObjectWithKey:@"stats"];
        
        // Make the statss
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
            
        }
    }
    
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
    
    if ([[Stats instance].whereTutorial isEqual:@"Menu"]) {
        return [CCBReader loadAsScene:@"Menu"];
    } else if ([[Stats instance].whereTutorial isEqual:@"CarMenu"]) {
        return [CCBReader loadAsScene:@"CarMenu"];
    } else {
        return [CCBReader loadAsScene:@"Menu"];
    }
    
}

- (BOOL)onKeyUp:(int32_t)keyCode keyEvent:(AndroidKeyEvent *)event
{
    if (keyCode == AndroidKeyEventKeycodeBack)
    {
        [self finish];
    }
    return NO;
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
