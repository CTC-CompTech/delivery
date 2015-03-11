//
//  Alert.m
//  Delivery
//
//  Created by Michael Blades on 2/27/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Alert.h"
#import "ScrollViewTable.h"
#import "CarMenu.h"

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
    
//    CCActionEaseOut *squeze1 = [CCActionEaseOut actionWithAction:[CCActionScaleTo actionWithDuration:1 scaleX:1 scaleY:.8] rate:2];
//    
//    CCActionEaseIn *expand1 = [CCActionEaseIn actionWithAction:[CCActionScaleTo actionWithDuration:1 scaleX:1 scaleY:1] rate:2];
//    
//    CCActionSequence *sequence = [CCActionSequence actions: squeze1, expand1, nil];
//    
//    [_alertMenu runAction:sequence];
    
    NSString *formattedAmount = [self formatter:passedAmount];
    
    _title.string = [NSString stringWithFormat:@"Would you like to buy this car\r\nfor %@ coins?", formattedAmount];
    
    _yesPlease.visible = TRUE;
    _no.visible = TRUE;
    
}

- (void)fadeAndDelete {
    CCActionFadeOut *fadeBack = [CCActionFadeOut actionWithDuration:.5];
    [_fadeBackground runAction:fadeBack];
    
    for (CCNode *node in self.children) {
        CCActionFadeOut *fade = [CCActionFadeOut actionWithDuration:.5];
        [node runAction:fade];
        
        // Handle buttons
        if ([node isKindOfClass:[CCButton class]]) {
            [node setCascadeOpacityEnabled:TRUE];
        }
    }
    
    [self performSelector:@selector(deleteSelf) withObject:nil afterDelay:.6f];
    
    // Remove buttons
//    [self removeChildByName:@"Yes"];
//    [self removeChildByName:@"No"];
//    [self removeChildByName:@"Okay"];
}

- (void)deleteSelf {
    [self removeFromParent];
}

#pragma mark - Buttons

- (void)yesPlease {
    
    // Delete and send back to scrollviewtable as yes
    [self fadeAndDelete];
    
//    // Prepare for later use
//    if ([self.parent isKindOfClass:[CarMenu class]]) {
//        [scrollView didWantToBuy];
//    }
    
}

- (void)okaySorry {
    
    [self fadeAndDelete];
    
}

- (void)noAlert {
    
    // Don't do anything
    [self fadeAndDelete];
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
