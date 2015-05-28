//
//  MyPicks.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/27/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selectedPick.h"
#import "Team.h"
#import <Parse/Parse.h>

@interface MyPicks : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    PFObject *myPickFile;
    NSMutableArray *userPicks;
    selectedPick *testing;
    IBOutlet UITableView *myPicks;
    IBOutlet UILabel *thisWeek;
    NSMutableDictionary *resultArray;
    NSString *objectID;
    NSString *currentWeek;
}

@end
