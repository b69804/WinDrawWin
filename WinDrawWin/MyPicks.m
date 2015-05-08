//
//  MyPicks.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/27/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "MyPicks.h"
#import "selectedPick.h"
#import "Team.h"
#import "CustomCell1.h"
#import <Parse/Parse.h>
#import "Reachability.h"

@interface MyPicks ()

@end

@implementation MyPicks

- (void)viewDidLoad {
    [super viewDidLoad];
    userPicks = [[NSMutableArray alloc] init];
    resultArray = [[NSMutableDictionary alloc] init];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self getFile];
    [super viewDidAppear:TRUE];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser == nil){
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
}

- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
    } else {
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Check your Interwebs!"
                              message:@"We are having trouble connecting to the internet.  Please check your network settings and get a valid data connection."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        alert.tag = 3;
        [alert show];
    }
}

-(void)getFile{
    PFQuery *weekQuery = [PFQuery queryWithClassName:@"CurrentWeek"];
    [weekQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                currentWeek = object[@"CurrentWeek"];
                thisWeek.text = currentWeek;
                PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
                [query whereKey:@"WeekNo" containsString:currentWeek];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count == 0) {
                        UIAlertView *pickGames = [[UIAlertView alloc] initWithTitle:@"Make Your Picks!" message:@"Looks like you have not made picks yet.  Let's get you started!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        pickGames.tag = 1;
                        [pickGames show];
                    } else if (!error) {
                        for (PFObject *object in objects) {
                            myPickFile = object;
                            objectID = myPickFile.objectId;
                            PFFile *myPickData = myPickFile[@"myPickFile"];
                            [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                                if (data != nil) {
                                    NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                                    for (testing in allMyPicks) {
                                        [userPicks addObject:testing];
                                    }
                                    [myPicks reloadData];
                                }
                            }];
                        }
                        PFQuery *resultsQuery = [PFQuery queryWithClassName:@"Week24"];
                        [resultsQuery whereKey:@"Week" containsString:currentWeek];
                        [resultsQuery whereKey:@"resultAvailable" containsString:@"yes"];
                        [resultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                            if (!error) {
                                for (PFObject *object in objects){
                                    if ([object[@"resultAvailable"] isEqualToString:@"yes"]) {
                                        [resultArray setObject:object[@"Result"] forKey:object[@"GameNo"]];
                                    }
                                }
                                if (resultArray.count == 10){
                                    UIAlertView *results = [[UIAlertView alloc] initWithTitle:@"Results are In!" message:@"All games have finished for this week.  Head over to your profile to see how you did." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                    results.tag = 2;
                                    [results show];
                                }
                            } else {
                                NSLog(@"Error: %@ %@", error, [error userInfo]);
                            }
                        }];
                    } else {
                        // Log details of the failure
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userPicks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell1 *cell = [tableView dequeueReusableCellWithIdentifier:@"matchUpPick"];
    if (cell != nil)
    {
        selectedPick *title = [userPicks objectAtIndex:indexPath.row];
        NSString *myPick = title.teamPicked.name;
        NSString *game = title.matchUp;
 
        [cell refreshCellWithInfo:myPick matchUp:game];
    }
    return cell;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [self performSegueWithIdentifier:@"goToMakePicks" sender:self];
    } else if (alertView.tag == 2){
        NSLog(@"Compare Results.");
        [self calculateResults];
    }
}


-(void)calculateResults{
    int numberCorrect = 0;
    for (selectedPick *myPick in userPicks) {
        NSNumber *game = myPick.gameNumber;
        NSString *resultToCompare = [resultArray objectForKey:game];
        if ([myPick.teamPicked.nickname isEqualToString:resultToCompare]) {
            myPick.isCorrect = true;
            numberCorrect++;
        } else {
            myPick.isCorrect = false;
        }
    }
    NSInteger myScore = numberCorrect * 10;
    NSMutableArray *newData = [[NSMutableArray alloc] init];
    [newData addObjectsFromArray:userPicks];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:newData];
    PFFile *file = [PFFile fileWithName:@"matchPicks.txt" data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
            [query getObjectInBackgroundWithId:objectID block:^(PFObject *updatedPicks, NSError *error) {
                NSNumber *myTime = updatedPicks[@"Time"];
                float myNewTime = [myTime floatValue];
                float myNewScore = (myScore + myNewTime);
                NSNumber *numberScore = [NSNumber numberWithFloat:myNewScore];
                PFObject *myHighScore = [PFObject objectWithClassName:@"Rankings"];
                myHighScore[@"Score"] = [numberScore stringValue];
                myHighScore[@"User"] = [PFUser currentUser].username;
                myHighScore[@"WeekNo"] = currentWeek;
                [myHighScore saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        [updatedPicks saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                            if (succeeded) {
                                NSLog(@"Saved.");
                                updatedPicks[@"completedPicks"] = file;
                                updatedPicks[@"MyScore"] = numberScore;
                                [updatedPicks saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                                    if (succeeded) {
                                        NSLog(@"Saved.");
                                    } else {
                                        NSLog(@"Did not save.");
                                    }
                                }];
                            } else {
                                NSLog(@"Did not save.");
                            }
                        }];
                        } else {
                    }
                }];
                
            }];
        }
    }];
}

@end
