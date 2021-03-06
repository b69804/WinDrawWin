//
//  selectedPick.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/22/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Team.h"

@interface selectedPick : NSObject <NSCoding>
{
    Team *teamPicked;
    NSString *matchUp;
    bool isCorrect;
}

@property Team *teamPicked;
@property NSNumber *gameNumber;
@property NSString *matchUp;
@property bool isCorrect;


@end
