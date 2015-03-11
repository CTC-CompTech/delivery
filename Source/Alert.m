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
    CCNode *_fadeBackground;
    
    CCButton *_backButton;
    
}

#pragma mark - init

- (void)didLoadFromCCB {
    [_backButton setHitAreaExpansion:40.f];
    
    CCActionFadeIn *fadeBack = [CCActionFadeIn actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
}

#pragma mark - Helpers

- (void)runAlertWithAmount:(NSInteger)passedAmount {
    
    CCActionEaseOut *squeze1 = [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:1 scaleX:1 scaleY:.8] rate:2];
    
    CCActionEaseIn *expand1 = [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:1 scaleX:1 scaleY:1] rate:2];
    
    CCActionSequence *sequence = [CCActionSequence actions: squeze1, expand1, nil];
    
    [_alertMenu runAction:sequence];
    
    NSString *formattedAmount = [self formatter:passedAmount];
    
    _title.string = [NSString stringWithFormat:@"Would you like to buy this car\r\nfor %@ coins?", formattedAmount];
    
    _yesPlease.visible = TRUE;
    _no.visible = TRUE;
    
}

#pragma mark - Buttons

- (void)yesPlease {
    
    CCActionEaseOut *squeze1 = [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:.5 scaleX:1 scaleY:.8] rate:2];
    
    CCActionEaseIn *expand1 = [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:.5 scaleX:1 scaleY:1] rate:2];
    
    CCActionSequence *sequence = [CCActionSequence actions: squeze1, expand1, nil];
    
    [_alertMenu runAction:sequence];
}

- (void)alertMenu {
    
}

- (void)okaySorry {
    
}

- (void)noAlert {
    
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
