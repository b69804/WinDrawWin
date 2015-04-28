//
//  Team.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/27/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject <NSCoding>
{
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *stadium;
@property (nonatomic, strong) NSMutableArray *allTeams;
@property (nonatomic, strong) NSString *logo;

@end
