//
//  UserRankings.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/29/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRankings : NSObject
{
}

@property (nonatomic, strong) NSString *specificUserName;
@property (nonatomic, assign) int score;
@property (nonatomic, strong) NSString *ranking;


@end
