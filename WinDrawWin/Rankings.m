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
    //[self createRankingsInfo];
    [self getAllUsers];
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
    return [allUsersRankings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    rankingCell *rankCell = [tableView dequeueReusableCellWithIdentifier:@"rankingCell"];
    if (rankCell != nil)
    {
        PFObject *eachPerson = [allUsersRankings objectAtIndex:indexPath.row];
        NSString *userName = eachPerson[@"User"];
        NSUInteger posInArray = [sortedArray indexOfObject:eachPerson] + 1;
        NSString *ranking = [NSString stringWithFormat:@"%lu", (unsigned long)posInArray];
        //NSString *score = [NSString stringWithFormat:@"%d", eachPerson.score];
        NSString *score = eachPerson[@"Score"];
        [rankCell refreshCellWithInfo:ranking username:userName userScore:score];
    }
    return rankCell;
}

- (void)getAllUsers
{
    PFQuery *weekQuery = [PFQuery queryWithClassName:@"CurrentWeek"];
    [weekQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            for (PFObject *object in objects) {
                currentWeek = object[@"RankingWeek"];
            }
            PFQuery *query = [PFQuery queryWithClassName:@"Rankings"];
            [query orderByAscending:@"Score"];
            [query whereKey:@"WeekNo" containsString:currentWeek];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                if (!error) {
                    for (PFObject *object in objects) {
                        [allUsersRankings addObject:object];
                    }
                    [rankTable reloadData];
                    weekString.text = [NSString stringWithFormat:@"Rankings for Week %@", currentWeek];
                } else {
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}

@end
