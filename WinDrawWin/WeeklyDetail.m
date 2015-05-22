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
#import <Social/Social.h>


@interface WeeklyDetail ()

@end

@implementation WeeklyDetail

- (void)viewDidLoad {
    
    NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
    BOOL twitter = [thisUsersDefaults boolForKey:@"twitter"];
    if (twitter == NO){
        tweet.hidden = true;
    }
    
    BOOL fBook = [thisUsersDefaults boolForKey:@"facebook"];
    if (fBook == NO){
        facebook.hidden = true;
    }
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [selectedWeeklyScores reloadData];
    [self getPicksForPassedWeek];
    //[self compareResults];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [thisWeeksPicks count];
    //return [_thatWeeksUsersScores.eachWeeksPicks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    resultDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"weeklyResultCell"];
    if (detailCell != nil)
    {
        /*selectedPick *weeklyScore = [_thatWeeksUsersScores.eachWeeksPicks objectAtIndex:indexPath.row];
        NSString *eachPickName = weeklyScore.teamPicked.name;
        NSString *eachMatchUp = weeklyScore.matchUp;
        UIImage *result;
        if (weeklyScore.isCorrect) {
            result = [UIImage imageNamed:@"Correct.png"];
        } else if (!weeklyScore.isCorrect){
            result = [UIImage imageNamed:@"Incorrect.png"];
        }
        [detailCell refreshCellWithInfo:eachPickName match:eachMatchUp yesOrNo:result];*/
        
        selectedPick *weeklyScore = [[pickDictionary objectForKey:@"picksForWeek"] objectAtIndex:indexPath.row];
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

-(IBAction)shareViaTwitter:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *userTweet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [userTweet setInitialText:[NSString stringWithFormat:@"My High Score for this week is %@ on WinDrawWin.  Can you beat it?", highScore]];
        [userTweet setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled)
             {
                 NSLog(@"Cancelled.");
             }
             else if (result == SLComposeViewControllerResultDone)
             {
                 NSLog(@"Tweet Sent.");
             }
         }];
        [self presentViewController:userTweet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter"
                                                        message:@"You must have your Twitter account setup on this iPhone.  Please go to your settings and link your Twitter account."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}
-(IBAction)shareViaFacebook:(id)sender
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *shareOnFacebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [shareOnFacebook setInitialText:[NSString stringWithFormat:@"My High Score for this week is %@ on WinDrawWin.  Can you beat it?", highScore]];
        [shareOnFacebook setCompletionHandler:^(SLComposeViewControllerResult result)
         {
             if (result == SLComposeViewControllerResultCancelled)
             {
                 NSLog(@"Cancelled.");
             }
             else if (result == SLComposeViewControllerResultDone)
             {
                 NSLog(@"Shared on Facebook.");
             }
         }];
        [self presentViewController:shareOnFacebook animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                        message:@"You must have your facebook account setup on this iPhone.  Please go to your Settings and link your Facebook account."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 2){
    
    }
        
}

- (void)getPicksForPassedWeek
{
    allMyScoresArray = [[NSMutableArray alloc] init];
    pickDictionary = [[NSMutableDictionary alloc] init];
    thisWeeksPicks = [[NSMutableArray alloc] init];
    [allMyScoresArray removeAllObjects];
    PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
    [query whereKey:@"WeekNo" containsString:_passedWeekNo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                PFObject *myPickFile = object;
                PFFile *myPickData = myPickFile[@"completedPicks"];
                if (myPickData == nil){
                    myPickData = myPickFile[@"myPickFile"];
                }
                NSString *weekNumber = object[@"WeekNo"];
                NSNumber *currentScore = object[@"MyScore"];
                [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                   // [thisWeeksPicks removeAllObjects];
                    if (currentScore != nil) {
                        NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        for (eachPick in allMyPicks) {
                            [thisWeeksPicks addObject:eachPick];
                        }
                        /*UserScores *scoreForWeek33 = [[UserScores alloc] init];
                        scoreForWeek33.week = [NSString stringWithFormat:@"Week %@", weekNumber];
                        scoreForWeek33.weekNumber = weekNumber;
                        scoreForWeek33.score = [currentScore intValue];
                        NSNumber *timeNumber = object[@"Time"];
                        scoreForWeek33.time = [timeNumber floatValue];
                        scoreForWeek33.eachWeeksPicks = thisWeeksPicks;
                        [allMyScoresArray addObject:scoreForWeek33];*/
                        NSNumber *timeNumber = object[@"Time"];
                        [pickDictionary setObject:[NSString stringWithFormat:@"Week %@", weekNumber] forKey:@"week"];
                        [pickDictionary setObject:weekNumber forKey:@"weekNumber"];
                        [pickDictionary setObject:currentScore forKey:@"score"];
                        [pickDictionary setObject:timeNumber forKey:@"time"];
                        [pickDictionary setObject:thisWeeksPicks forKey:@"picksForWeek"];
                        
                        [self compareResults];
                        
                    } else {
                        NSLog(@"No matchPick file. Getting myPickFile.");
                        PFFile *myPickData = myPickFile[@"myPickFile"];
                        NSString *weekNumber = object[@"WeekNo"];
                        [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            //[thisWeeksPicks removeAllObjects];
                            NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                            for (eachPick in allMyPicks) {
                                [thisWeeksPicks addObject:eachPick];
                            }
                            /*UserScores *scoreForWeek33 = [[UserScores alloc] init];
                            scoreForWeek33.week = [NSString stringWithFormat:@"Week %@", weekNumber];
                            scoreForWeek33.weekNumber = weekNumber;
                            scoreForWeek33.score = [currentScore intValue];
                            NSNumber *timeNumber = object[@"Time"];
                            scoreForWeek33.time = [timeNumber floatValue];
                            scoreForWeek33.eachWeeksPicks = thisWeeksPicks;
                            [allMyScoresArray addObject:scoreForWeek33];*/
                            NSNumber *timeNumber = object[@"Time"];
                            [pickDictionary setObject:[NSString stringWithFormat:@"Week %@", weekNumber] forKey:@"week"];
                            [pickDictionary setObject:weekNumber forKey:@"weekNumber"];
                            //[pickDictionary setObject:currentScore forKey:@"score"];
                            [pickDictionary setObject:timeNumber forKey:@"time"];
                            [pickDictionary setObject:thisWeeksPicks forKey:@"picksForWeek"];
                            
                            [self compareResults];
                            
                        }];
                        
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

-(void)compareResults
{
    resultArray = [[NSMutableDictionary alloc] init];
    PFQuery *resultsQuery = [PFQuery queryWithClassName:@"Week24"];
    //[resultsQuery whereKey:@"Week" containsString:_thatWeeksUsersScores.weekNumber];
    [resultsQuery whereKey:@"Week" containsString:[pickDictionary objectForKey:@"weekNumber"]];
    //[resultsQuery whereKey:@"resultAvailable" containsString:@"yes"];
    [resultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects){
                if ([object[@"resultAvailable"] isEqualToString:@"yes"]) {
                    [resultArray setObject:object[@"Result"] forKey:object[@"GameNo"]];
                } else {
                    NSLog(@"No results available.");
                    for (selectedPick *myPick in [pickDictionary objectForKey:@"picksForWeek"]) {
                        myPick.isCorrect = false;
                    }
                    [selectedWeeklyScores reloadData];
                    UIAlertView *noResultsYet = [[UIAlertView alloc] initWithTitle:@"All Games Selected" message:@"You have made all your selections for this week.  Let's see what you picked." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    noResultsYet.tag = 0;
                    [noResultsYet show];
                }
            }
            if (resultArray.count == 10){
                int numberCorrect = 0;
                /*for (selectedPick *myPick in _thatWeeksUsersScores.eachWeeksPicks) {
                    NSNumber *game = myPick.gameNumber;
                    NSString *resultToCompare = [resultArray objectForKey:game];
                    if ([myPick.teamPicked.nickname isEqualToString:resultToCompare]) {
                        myPick.isCorrect = true;
                        (numberCorrect++);
                    } else {
                        myPick.isCorrect = false;
                    }
                }*/
                
                
                for (selectedPick *myPick in [pickDictionary objectForKey:@"picksForWeek"]) {
                    NSNumber *game = myPick.gameNumber;
                    NSString *resultToCompare = [resultArray objectForKey:game];
                    if ([myPick.teamPicked.nickname isEqualToString:resultToCompare]) {
                        myPick.isCorrect = true;
                        (numberCorrect++);
                    } else {
                        myPick.isCorrect = false;
                    }
                }
                
                NSString *userName = [PFUser currentUser].username;
                PFQuery *highScoreQuery = [PFQuery queryWithClassName:@"Rankings"];
                [highScoreQuery whereKey:@"User" containsString:userName];
                //[highScoreQuery whereKey:@"WeekNo" containsString:_thatWeeksUsersScores.weekNumber];
                [highScoreQuery whereKey:@"WeekNo" containsString:[pickDictionary objectForKey:@"weekNumber"]];
                [highScoreQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count == 0) {
                        NSLog(@"No High Score");
                        NSInteger myScore = numberCorrect * 10;
                        //float myNewScore = (myScore + _thatWeeksUsersScores.time);
                        NSNumber *timeNumber = [pickDictionary objectForKey:@"time"];
                        float myNewScore = (myScore + [timeNumber floatValue]);
                        NSNumber *numberScore = [NSNumber numberWithFloat:myNewScore];
                        PFObject *myHighScore = [PFObject objectWithClassName:@"Rankings"];
                        myHighScore[@"Score"] = [numberScore stringValue];
                        highScore = [numberScore stringValue];
                        myHighScore[@"User"] = [PFUser currentUser].username;
                        myHighScore[@"WeekNo"] = [pickDictionary objectForKey:@"weekNumber"];
                        //myHighScore[@"WeekNo"] = _thatWeeksUsersScores.weekNumber;
                        [pickDictionary setObject:numberScore forKey:@"score"];
                        [myHighScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                            if (succeeded) {
                                [selectedWeeklyScores reloadData];
                                /*thisWeekLabel.text = [NSString stringWithFormat:@"Results for Week %@  Score: %@", _thatWeeksUsersScores.weekNumber, [numberScore stringValue]];*/
                                thisWeekLabel.text = [NSString stringWithFormat:@"Results for Week %@  Score: %@", [pickDictionary objectForKey:@"weekNumber"], [numberScore stringValue]];
                                
                                
                            } else {
                                
                            }
                        }];
                    } else {
                        [selectedWeeklyScores reloadData];
                    
                        for (PFObject *object in objects) {
                            highScore = object[@"Score"];
                        }
                        thisWeekLabel.text = [NSString stringWithFormat:@"Results for Week %@  Score: %@", [pickDictionary objectForKey:@"weekNumber"], highScore];
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}




@end
