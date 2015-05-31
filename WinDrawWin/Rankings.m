//
//  Rankings.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/29/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "Rankings.h"
#import "rankingCell.h"
#import "UserRankings.h"
#import <Parse/Parse.h>

@interface Rankings ()

@end

@implementation Rankings

- (void)viewDidLoad {
    [super viewDidLoad];
    allUsersRankings = [[NSMutableArray alloc] init];
    [self getAllUsers]; // Gets all Rankings 
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
    return [allUsersRankings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    rankingCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"rankingCell"];
    if (rankCell != nil)
    {
        PFObject *eachPerson = [allUsersRankings objectAtIndex:indexPath.row];
        NSString *userName = eachPerson[@"User"];
        NSUInteger posInArray = indexPath.row + 1;
        NSString *ranking = [NSString stringWithFormat:@"%lu", (unsigned long)posInArray];
        NSString *score = eachPerson[@"Score"];
        [rankCell refreshCellWithInfo:ranking username:userName userScore:score];
        
    }
    return rankCell;
}

// Gets all the Rankings for the current week.  Current week is set on Parse.
- (void)getAllUsers
{
    PFQuery *weekQuery = [PFQuery queryWithClassName:@"CurrentWeek"];
    [weekQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            for (PFObject *object in objects) {
                currentWeek = object[@"RankingWeek"];
            }
            // Users with high scores are added and ordered by score
            PFQuery *query = [PFQuery queryWithClassName:@"Rankings"];
            [query orderByDescending:@"ScoreNumber"];
            [query whereKey:@"WeekNo" containsString:currentWeek];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                if (!error) {
                    for (PFObject *object in objects) {
                        [allUsersRankings addObject:object];
                    }
                    [rankTable reloadData];
                    weekString.text = [NSString stringWithFormat:@"Rankings for Week %@", currentWeek]; // Sets the label for the current week
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}

@end
