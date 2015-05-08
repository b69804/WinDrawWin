//
//  UserProfile.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "UserProfile.h"
#import "UserCell.h"
#import "UserScores.h"
#import "WeeklyDetail.h"
#import <Parse/Parse.h>


@interface UserProfile ()

@end

@implementation UserProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    allMyScores = [[NSMutableArray alloc] init];
    thisWeeksUserPicks = [[NSMutableArray alloc] init];
    [self getAllMyScores];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allMyScores count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (userCell != nil)
    {
        UserScores *weeklyScore = [allMyScores objectAtIndex:indexPath.row];
        NSString *thisWeek = weeklyScore.week;
        NSString *thisWeeksScore = [NSString stringWithFormat:@"%d", weeklyScore.score];
        
        [userCell refreshCellWithInfo: (NSString *)thisWeek myScore:(NSString *) thisWeeksScore];
    }
    return userCell;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"weeklyDetailSegue"])
    {
        WeeklyDetail *detailView = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [userWeeklyScores indexPathForCell:cell];
        
        UserScores *weeklyScore = [allMyScores objectAtIndex:indexPath.row];
        detailView.thatWeeksUsersScores = weeklyScore;
        
    }
    
    
}

-(void)getAllMyScores
{
    [PFQuery clearAllCachedResults];
    PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                myPickFile = object;
                PFFile *myPickData = myPickFile[@"completedPicks"];
                NSString *weekNumber = object[@"WeekNo"];
                NSNumber *currentScore = object[@"MyScore"];
                [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (data != nil) {
                        NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        for (eachPick in allMyPicks) {
                            [thisWeeksUserPicks addObject:eachPick];
                        }
                        UserScores *scoreForWeek33 = [[UserScores alloc] init];
                        scoreForWeek33.week = [NSString stringWithFormat:@"Week %@", weekNumber];
                        scoreForWeek33.weekNumber = weekNumber;
                        scoreForWeek33.score = [currentScore intValue];
                        NSNumber *timeNumber = object[@"Time"];
                        scoreForWeek33.time = [timeNumber floatValue];
                        scoreForWeek33.eachWeeksPicks = thisWeeksUserPicks;
                        [allMyScores addObject:scoreForWeek33];
                        
                        [userWeeklyScores reloadData];
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue
{
    
}


@end
