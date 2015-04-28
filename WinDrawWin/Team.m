//
//  Team.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/27/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize name, nickname, stadium, allTeams, logo;

- (void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.nickname forKey:@"nickname"];
    [encoder encodeObject:self.stadium forKey:@"stadium"];
    [encoder encodeObject:self.logo forKey:@"logo"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self != nil )
    {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.nickname = [decoder decodeObjectForKey:@"nickname"];
        self.stadium = [decoder decodeObjectForKey:@"stadium"];
        self.logo = [decoder decodeObjectForKey:@"logo"];
    }
    return self;
}


@end
