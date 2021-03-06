//
//  UserProfile.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "selectedPick.h"

@interface UserProfile : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *userWeeklyScores;
    IBOutlet UILabel *userName;
    NSMutableArray *allMyScores;
    PFObject *myPickFile;
    NSMutableArray *thisWeeksUserPicks;
    selectedPick *eachPick;
    NSString *passedWeek;
    NSMutableArray *passedStrings;
}

@end
