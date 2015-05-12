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
#import "Options.h"
#import "Menu.h"
#import "Stats.h"

@interface Alert ()

@property NSInteger amountToTakeOut;

@end

@implementation Alert {
    
    CCButton *_okaySorry;
    CCButton *_yesPlease;
    CCButton *_no;
    CCButton *_reset;
    
    CCLabelTTF *_title;
    
    CCNode *_alertMenu;
    CCNode *_fadeBackground;
    
}

#pragma mark - init

- (void)didLoadFromCCB {
    [_okaySorry setHitAreaExpansion:40.f];
    [_yesPlease setHitAreaExpansion:40.f];
    [_no setHitAreaExpansion:40.f];
    [_reset setHitAreaExpansion:40.f];
    
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

- (void)runOkayAlertScrollView {
    
     _title.string = @"You do not have enough\r\ncoins to buy this car.";
    
    _okaySorry.visible = TRUE;
    
}

- (void)runAlertReset {
    
    _title.string = @"Are you sure you would\r\nlike to reset all stats?";
    
    _yesPlease.visible = TRUE;
    _no.visible = TRUE;
    
}

- (void)runAlertTutorial {
    
    _title.string = @"Would you like to run\r\nthrough the tutorial?";
    
    _yesPlease.visible = TRUE;
    _no.visible = TRUE;
    
}

-(void)runAlertResetTutorial {
    _title.string = @"Would you like\r\nto restart the tutorial?";
    
    _reset.visible = TRUE;
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

- (void)disableButtons {
    _okaySorry.enabled = FALSE;
    _yesPlease.enabled = FALSE;
    _no.enabled = FALSE;
    _reset.enabled = FALSE;
}

- (void)deleteSelf {
    [self removeFromParent];
}

#pragma mark - Buttons

- (void)yesPlease {
    
    // Delete and send back to scrollviewtable as yes
    [self fadeAndDelete];
    
    [self disableButtons];
    
    // Prepare for later use
    if ([self.parent isKindOfClass:[CarMenu class]]) {
        ScrollViewTable *scrollView = [[ScrollViewTable alloc] init];
        [scrollView didWantToBuy];
    }
    
    if ([self.parent isKindOfClass:[Options class]]) {
        Options *options = [[Options alloc] init];
        [options didWantReset];
    }
    
    if ([self.parent isKindOfClass:[Menu class]]) {
        Menu *menu = [[Menu alloc] init];
        [menu didSayYes];
    }
    
}

- (void)okaySorry {
    
    [self fadeAndDelete];
    
    [self disableButtons];
    
}

- (void)noAlert {
    
    if ([self.parent isKindOfClass:[Menu class]]) {
        [Stats instance].shouldTutorial = NO;
        [Stats instance].whereTutorial = @"";
    }
    
    // Don't do anything
    [self fadeAndDelete];
    
    [self disableButtons];
    
}

- (void)resetTut {
    
    [self fadeAndDelete];
    
    [self disableButtons];
    
    if ([self.parent isKindOfClass:[Options class]]) {
        Options *options = [[Options alloc] init];
        [options didTut];
    }
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
