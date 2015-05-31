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
    // Gets the user's selections for Facebook and Twitter settings
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [thisWeeksPicks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    resultDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"weeklyResultCell"];
    if (detailCell != nil)
    {
        selectedPick *weeklyScore = [[pickDictionary objectForKey:@"picksForWeek"] objectAtIndex:indexPath.row];
        NSString *eachPickName = weeklyScore.teamPicked.name;
        NSString *eachMatchUp = weeklyScore.matchUp;
        UIImage *result;
        if (noresults){
            result = [UIImage imageNamed:@"player_03.png"];
        } else if (weeklyScore.isCorrect) {
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

// Allows for posting to Twitter
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
        UIAlertView *alert = [[UIAlertView alloc]  // Alert stating no Twitter account is logged in
                              initWithTitle:@"Twitter"
                              message:@"You must have your Twitter account setup on this iPhone.  Please go to your settings and link your Twitter account."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

}

// Allows for sharing to Facebook
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
        UIAlertView *alert = [[UIAlertView alloc]  // Alert stating no Facebook account logged in
                              initWithTitle:@"Facebook"
                              message:@"You must have your facebook account setup on this iPhone.  Please go to your Settings and link your Facebook account."
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0){
    
    }
}

// Get the picks for the selected week
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
                // Gets week-specific picks
                NSString *weekNumber = object[@"WeekNo"];
                NSNumber *currentScore = object[@"MyScore"];
                [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (currentScore != nil) {
                        NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        for (eachPick in allMyPicks) {
                            [thisWeeksPicks addObject:eachPick];
                        }
                        // Adds all the picks to dictionary of all Picks for that week
                        NSNumber *timeNumber = object[@"Time"];
                        [pickDictionary setObject:[NSString stringWithFormat:@"Week %@", weekNumber] forKey:@"week"];
                        [pickDictionary setObject:weekNumber forKey:@"weekNumber"];
                        [pickDictionary setObject:currentScore forKey:@"score"];
                        [pickDictionary setObject:timeNumber forKey:@"time"];
                        [pickDictionary setObject:thisWeeksPicks forKey:@"picksForWeek"];
                        
                        [self compareResults]; // Compares results to outcomes
                        
                    } else {
                        PFFile *myPickData = myPickFile[@"myPickFile"];
                        NSString *weekNumber = object[@"WeekNo"];
                        [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                            NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                            for (eachPick in allMyPicks) {
                                [thisWeeksPicks addObject:eachPick];
                            }
                            // Adds all the picks to dictionary of all Picks for that week
                            NSNumber *timeNumber = object[@"Time"];
                            [pickDictionary setObject:[NSString stringWithFormat:@"Week %@", weekNumber] forKey:@"week"];
                            [pickDictionary setObject:weekNumber forKey:@"weekNumber"];
                            [pickDictionary setObject:timeNumber forKey:@"time"];
                            [pickDictionary setObject:thisWeeksPicks forKey:@"picksForWeek"];
                            
                            [self compareResults]; // Compares results to outcomes
                            
                        }];
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

// Compares the user's picks to the actual game outcomes.  A score is calculated based on number correct and time it took to complete the picks
-(void)compareResults
{
    resultArray = [[NSMutableDictionary alloc] init];
    PFQuery *resultsQuery = [PFQuery queryWithClassName:@"Week24"];
    [resultsQuery whereKey:@"Week" containsString:[pickDictionary objectForKey:@"weekNumber"]];
    UIAlertView *noResultsYet = [[UIAlertView alloc] // Alert saying that games are not completed for that week
                                 initWithTitle:@"Games still in progress"
                                 message:@"There is still time for an injury time winner!  Results are not available until all games have finished. Check back soon to see how you did!"
                                 delegate:self
                                 cancelButtonTitle:@"Okay"
                                 otherButtonTitles:nil];
    [resultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects){
                if ([object[@"resultAvailable"] isEqualToString:@"yes"]) {
                    [resultArray setObject:object[@"Result"] forKey:object[@"GameNo"]];
                } else {
                    NSLog(@"No results available.");
                    noresults = YES;
                    [selectedWeeklyScores reloadData];
                }
            }
            if (noresults) {
                thisWeekLabel.text = [NSString stringWithFormat:@"Results for Week %@", [pickDictionary objectForKey:@"weekNumber"]];
                [noResultsYet show];
            }
            if (resultArray.count == 10){
                int numberCorrect = 0;
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
                [highScoreQuery whereKey:@"WeekNo" containsString:[pickDictionary objectForKey:@"weekNumber"]];
                [highScoreQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count == 0) {
                        NSLog(@"No High Score");
                        NSInteger myScore = numberCorrect * 10;
                        NSNumber *timeNumber = [pickDictionary objectForKey:@"time"];
                        float myNewScore = (myScore + [timeNumber floatValue]);
                        NSNumber *numberScore = [NSNumber numberWithFloat:myNewScore];
                        PFObject *myHighScore = [PFObject objectWithClassName:@"Rankings"];
                        myHighScore[@"Score"] = [numberScore stringValue];
                        highScore = [numberScore stringValue];
                        myHighScore[@"User"] = [PFUser currentUser].username;
                        myHighScore[@"WeekNo"] = [pickDictionary objectForKey:@"weekNumber"];
                        [pickDictionary setObject:numberScore forKey:@"score"];
                        [myHighScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                            if (succeeded) {
                                [selectedWeeklyScores reloadData];
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
