//
//  Alert.m
//  Delivery
//
//  Created by Michael Blades on 2/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Alert.h"

@interface Alert ()

@property NSInteger amountToTakeOut;

@end

@implementation Alert {
    
    CCButton *_okaySorry;
    CCButton *_yesPlease;
    CCButton *_no;
    
    CCLabelTTF *_title;
    
    CCNode *_alertMenu;
    
    CCButton *_backButton;
    
}

- (void)didLoadFromCCB {
    [_backButton setHitAreaExpansion:40.f];
}

- (void)runAlertWithAmount:(NSInteger)passedAmount {
    _alertMenu.position = ccp(480, _alertMenu.position.y);
    [self performSelector:@selector(sweepContent) withObject:nil afterDelay:.1];
    
    NSString *formattedAmount = [self formatter:passedAmount];
    
    _title.string = [NSString stringWithFormat:@"Would you like to buy this car\r\nfor %@ coins?", formattedAmount];
    
    _yesPlease.visible = TRUE;
    _no.visible = TRUE;
    
}

- (void)sweepContent {
    CCActionMoveTo *moveContent = [CCActionMoveTo actionWithDuration:.5 position:ccp(0, _alertMenu.position.y)];
    [_alertMenu runAction:moveContent];
}

- (void)yesPlease {
    
    
    
}

- (void)alertMenu {
    
}

#pragma mark - Formatter

- (NSString *)formatter:(NSInteger)toFormat {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    NSNumber *numToFormat = [NSNumber numberWithInteger:toFormat];
    NSString *formatted = [formatter stringFromNumber:numToFormat];
    
    return formatted;
    
}

@end
