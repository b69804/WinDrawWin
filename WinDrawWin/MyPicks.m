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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [self getFile];
    [super viewDidAppear:TRUE];
    NSLog(@"View did appear");
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
    PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
   // PFUser* current = [PFUser currentUser];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            UIAlertView *pickGames = [[UIAlertView alloc] initWithTitle:@"Make Your Picks!" message:@"Looks like you have not made picks yet.  Let's get you started!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            pickGames.tag = 1;
            [pickGames show];
        } else if (!error) {
            for (PFObject *object in objects) {
                myPickFile = object;
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
            [resultsQuery whereKey:@"resultsAvailable" containsString:@"yes"];
            [resultsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSLog(@"Results are available");
                    UIAlertView *results = [[UIAlertView alloc] initWithTitle:@"Results are In!" message:@"All games have finished for this week.  Let's see how you did!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                    results.tag = 2;
                    [results show];
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
        //[self performSegueWithIdentifier:@"goToMakePicks" sender:self];
        NSLog(@"Compare Results.");
    }
}

@end
