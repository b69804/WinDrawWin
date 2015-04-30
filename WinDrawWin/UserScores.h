//
//  UserScores.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "selectedPick.h"

@interface UserScores : NSObject
{

}

@property (nonatomic, strong) NSString *week;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) selectedPick *myPick;
@property (nonatomic, strong) NSMutableArray *eachWeeksPicks;


@end
