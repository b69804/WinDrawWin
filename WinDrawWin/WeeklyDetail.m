//
//  WeeklyDetail.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "WeeklyDetail.h"
#import "resultDetailCell.h"
#import "UserScores.h"
#import <Parse/Parse.h>


@interface WeeklyDetail ()

@end

@implementation WeeklyDetail

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self compareResults];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_thatWeeksUsersScores.eachWeeksPicks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    resultDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"weeklyResultCell"];
    if (detailCell != nil)
    {
        selectedPick *weeklyScore = [_thatWeeksUsersScores.eachWeeksPicks objectAtIndex:indexPath.row];
        NSString *eachPickName = weeklyScore.teamPicked.name;
        NSString *eachMatchUp = weeklyScore.matchUp;
        UIImage *result;
        if (weeklyScore.isCorrect) {
            result = [UIImage imageNamed:@"Correct.png"];
        } else if (!weeklyScore.isCorrect){
            result = [UIImage imageNamed:@"Incorrect.png"];
        }
        [detailCell refreshCellWithInfo:eachPickName match:eachMatchUp yesOrNo:result];
    }
    return detailCell;
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    
}

-(void)compareResults
{
    resultArray = [[NSMutableDictionary alloc] init];
    PFQuery *resultsQuery = [PFQuery queryWithClassName:@"Week24"];
    [resultsQuery whereKey:@"resultAvailable" containsString:@"yes"];
    [resultsQuery whereKey:@"Week" containsString:_thatWeeksUsersScores.weekNumber];
    [resultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects){
                if ([object[@"resultAvailable"] isEqualToString:@"yes"]) {
                    [resultArray setObject:object[@"Result"] forKey:object[@"GameNo"]];
                }
            }
            if (resultArray.count == 10){
                int numberCorrect = 0;
                for (selectedPick *myPick in _thatWeeksUsersScores.eachWeeksPicks) {
                    NSNumber *game = myPick.gameNumber;
                    NSString *resultToCompare = [resultArray objectForKey:game];
                    if ([myPick.teamPicked.nickname isEqualToString:resultToCompare]) {
                        myPick.isCorrect = true;
                        (numberCorrect++);
                    } else {
                        myPick.isCorrect = false;
                    }
                }
                PFQuery *highScoreQuery = [PFQuery queryWithClassName:@"Rankings"];
                [highScoreQuery whereKey:@"User" containsString:[PFUser currentUser].username];
                [highScoreQuery whereKey:@"WeekNo" containsString:_thatWeeksUsersScores.weekNumber];
                [highScoreQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count == 0) {
                        NSLog(@"No High Score");
                        NSInteger myScore = numberCorrect * 10;
                        float myNewScore = (myScore + _thatWeeksUsersScores.time);
                        NSNumber *numberScore = [NSNumber numberWithFloat:myNewScore];
                        PFObject *myHighScore = [PFObject objectWithClassName:@"Rankings"];
                        myHighScore[@"Score"] = [numberScore stringValue];
                        myHighScore[@"User"] = [PFUser currentUser].username;
                        myHighScore[@"WeekNo"] = _thatWeeksUsersScores.weekNumber;
                        [myHighScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                            if (succeeded) {
                                [selectedWeeklyScores reloadData];
                                thisWeekLabel.text = [NSString stringWithFormat:@"Results for Week %@  Score: %@", _thatWeeksUsersScores.weekNumber, [numberScore stringValue]];
                            } else {
                                
                            }
                        }];
                    } else {
                        [selectedWeeklyScores reloadData];
                        NSString *Test;
                        for (PFObject *object in objects) {
                            Test = object[@"Score"];
                        }
                        thisWeekLabel.text = [NSString stringWithFormat:@"Results for Week %@  Score: %@", _thatWeeksUsersScores.weekNumber, Test];
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


@end
