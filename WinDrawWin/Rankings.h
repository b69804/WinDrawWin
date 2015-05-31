//
//  Rankings.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/29/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Rankings : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *rankTable;
    NSMutableArray *allUsersRankings;
    NSMutableDictionary *dictionaryOfRankings;
    NSArray *sortedArray;
    IBOutlet UILabel *weekString;
    NSString *currentWeek;
}

@end
