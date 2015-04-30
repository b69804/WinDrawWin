//
//  selectedPick.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/22/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "selectedPick.h"

@implementation selectedPick

@synthesize teamPicked, matchUp, isCorrect;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.teamPicked forKey:@"teamPicked"];
    [encoder encodeObject:self.matchUp forKey:@"matchUp"];
    [encoder encodeBool:self.isCorrect forKey:@"isCorrect"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.teamPicked = [decoder decodeObjectForKey:@"teamPicked"];
        self.matchUp = [decoder decodeObjectForKey:@"matchUp"];
        self.isCorrect = [decoder decodeObjectForKey:@"isCorrect"];
    }
    return self;
}

@end
