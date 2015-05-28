//
//  selectedPick.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/22/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "selectedPick.h"

@implementation selectedPick

@synthesize teamPicked, matchUp, isCorrect, gameNumber;

// Encodes selected pick to be saved to a file on Parse
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.teamPicked forKey:@"teamPicked"];
    [encoder encodeObject:self.matchUp forKey:@"matchUp"];
    [encoder encodeObject:self.gameNumber forKey:@"gameNumber"];
    [encoder encodeBool:self.isCorrect forKey:@"isCorrect"];
}

// Allows for pick to be decoded when being read from Parse
- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.teamPicked = [decoder decodeObjectForKey:@"teamPicked"];
        self.matchUp = [decoder decodeObjectForKey:@"matchUp"];
        self.isCorrect = [decoder decodeObjectForKey:@"isCorrect"];
        self.gameNumber = [decoder decodeObjectForKey:@"gameNumber"];
    }
    return self;
}

@end
