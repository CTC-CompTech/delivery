//
//  musicRandomizer.m
//  Delivery
//
//  Created by Grant Jennings on 3/11/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "musicRandomizer.h"

@interface musicRandomizer ()

@property NSArray* musicNames;

@property NSMutableArray* musicArray;

@property OALAudioTrack* previousTrack;

-(OALAudioTrack*)getRandomTrack;

@end

@implementation musicRandomizer

-(id)init{
    self = [super init];
    self.musicArray = [NSMutableArray arrayWithCapacity:10];
    self.musicNames = [NSArray arrayWithObjects:@"Party.mp3", @"Dieseldotogg.mp3", nil];
    for (NSString* musicTitle in self.musicNames){
        OALAudioTrack* tempTrack = [[OALAudioTrack alloc] init];
        [tempTrack preloadFileAsync:musicTitle target:nil selector:nil];
        [self.musicArray addObject:tempTrack];
    }
    return self;
}

-(void)update:(CCTime)delta{
    if (self.previousTrack.playing == false || self.previousTrack == nil){
        self.previousTrack = [self getRandomTrack];
        [self.previousTrack play];
        
    }
}

-(OALAudioTrack*)getRandomTrack{
    OALAudioTrack* tempAudio;
    tempAudio = [self.musicArray objectAtIndex:arc4random_uniform((self.musicArray.count-1))];
    
    return tempAudio;
}

-(void)dealloc{
    [self.previousTrack stop];
}

@end
