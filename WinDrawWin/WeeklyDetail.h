//
//  WeeklyDetail.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserScores.h"

@interface WeeklyDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate>
{
    NSMutableArray *selectedArray;
    NSMutableArray *allMyScoresArray;
    NSMutableDictionary *resultArray;
    NSMutableDictionary *pickDictionary;
    NSMutableArray *thisWeeksPicks;
    selectedPick *eachPick;
    BOOL noresults;
    IBOutlet UITableView *selectedWeeklyScores;
    IBOutlet UILabel *thisWeekLabel;
    IBOutlet UIButton *tweet;
    IBOutlet UIButton *facebook;
    NSString *highScore;
    
}

@property (nonatomic, strong)UserScores *thatWeeksUsersScores;
@property (nonatomic, strong)NSString *passedWeekNo;

-(IBAction)done:(UIStoryboardSegue *)segue;
-(IBAction)shareViaTwitter:(id)sender;
-(IBAction)shareViaFacebook:(id)sender;

@end
