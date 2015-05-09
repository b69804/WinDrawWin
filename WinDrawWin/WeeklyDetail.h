//
//  WeeklyDetail.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserScores.h"

@interface WeeklyDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray *selectedArray;
    NSMutableDictionary *resultArray;
    IBOutlet UITableView *selectedWeeklyScores;
    IBOutlet UILabel *thisWeekLabel;
    IBOutlet UIButton *tweet;
    IBOutlet UIButton *facebook;
    NSString *highScore;
}

@property (nonatomic, strong)UserScores *thatWeeksUsersScores;

-(IBAction)done:(UIStoryboardSegue *)segue;
-(IBAction)shareViaTwitter:(id)sender;
-(IBAction)shareViaFacebook:(id)sender;

@end
