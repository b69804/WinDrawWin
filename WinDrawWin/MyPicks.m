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
}

-(void)getFile{
    PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
    /*if (query.trace == NO ) {
        NSLog(@"No Query");
        UIAlertView *pickGames = [[UIAlertView alloc] initWithTitle:@"Make Your Picks!" message:@"Looks like you have not made picks yet.  Let's get you started!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                        [pickGames show];
    }*/
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (objects.count == 0) {
            UIAlertView *pickGames = [[UIAlertView alloc] initWithTitle:@"Make Your Picks!" message:@"Looks like you have not made picks yet.  Let's get you started!" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [pickGames show];
        }
        if (!error) {
            // Do something with the found objects
            for (PFObject *object in objects) {
                if (objects == nil) {
                    if (userPicks.count == 0) {
                    }
                }
                myPickFile = object;
                PFFile *myPickData = myPickFile[@"myPickFile"];
                [myPickData getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (data != nil) {
                        NSMutableArray *allMyPicks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        //[userPicks addObject:allMyPicks];
                        NSLog(@"%@", allMyPicks);
                        for (testing in allMyPicks) {
                            NSLog(@"%@", testing.teamPicked.name);
                            [userPicks addObject:testing];
                            
                        }
                        [myPicks reloadData];
                        
                    }
                }];
            }
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
    if (buttonIndex == 0)
    {
        [self performSegueWithIdentifier:@"goToMakePicks" sender:self];
    }
}

@end
