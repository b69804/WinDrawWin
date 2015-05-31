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
    NSString *userThatIsLoggedIn = [PFUser currentUser].username;
    userName.text = userThatIsLoggedIn;
    
    [super viewDidLoad];
    
    thisWeeksUserPicks = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [userWeeklyScores reloadData];
    [self getScores];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [passedStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserCell *userCell = [tableView dequeueReusableCellWithIdentifier:@"userCell"];
    if (userCell != nil)
    {
        NSString *thisWeek = [passedStrings objectAtIndex:indexPath.row];
        NSString *weekFormat = [NSString stringWithFormat:@"Week %@", thisWeek];
        [userCell refreshCellWithInfo: (NSString *)weekFormat];
    }
    return userCell;
}

// Passes the week number to the detail view.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"weeklyDetailSegue"])
    {
        WeeklyDetail *detailView = segue.destinationViewController;
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [userWeeklyScores indexPathForCell:cell];
        passedWeek = [passedStrings objectAtIndex:indexPath.row];
        detailView.passedWeekNo = passedWeek;
    }
}

// Gets the weeks that the user has picks for.  
- (void)getScores
{
    passedStrings = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
    [query orderByDescending:@"WeekNo"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            for (PFObject *object in objects) {
                myPickFile = object;
                PFFile *myPickData = myPickFile[@"completedPicks"];
                if (myPickData == nil){
                    myPickData = myPickFile[@"myPickFile"];
                }
                // Sorts scores for weeks by week number
                NSString *weekNumber = object[@"WeekNo"];
                [passedStrings addObject:weekNumber];
                [passedStrings sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    [thisWeeksUserPicks removeAllObjects];
                    if (data != nil) {
                        NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        for (eachPick in allMyPicks) {
                            [thisWeeksUserPicks addObject:eachPick]; // Each week is added an array of weekly picks
                        }
                        [userWeeklyScores reloadData];
                        
                    } else {
                        PFFile *myPickData = myPickFile[@"myPickFile"];
                        NSString *weekNumber = object[@"WeekNo"];
                        [passedStrings addObject:weekNumber];
                        [passedStrings sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
                        [userWeeklyScores  reloadData];
                        [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            [thisWeeksUserPicks removeAllObjects];
                            NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                            for (eachPick in allMyPicks) {
                                [thisWeeksUserPicks addObject:eachPick]; // Each week is added an array of weekly picks
                            }
                            [userWeeklyScores reloadData];
                        }];
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
