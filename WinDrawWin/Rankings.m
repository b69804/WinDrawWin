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

@interface Rankings ()

@end

@implementation Rankings

- (void)viewDidLoad {
    [super viewDidLoad];
    allUsersRankings = [[NSMutableArray alloc] init];
    [self createRankingsInfo];
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
        UserRankings *eachPerson = [sortedArray objectAtIndex:indexPath.row];
        NSString *userName = eachPerson.specificUserName;
        NSUInteger posInArray = [sortedArray indexOfObject:eachPerson] + 1;
        NSString *ranking = [NSString stringWithFormat:@"%lu", (unsigned long)posInArray];
        NSString *score = [NSString stringWithFormat:@"%d", eachPerson.score];
        
        [rankCell refreshCellWithInfo:ranking username:userName userScore:score];
    }
    return rankCell;
}

-(void)createRankingsInfo
{
    UserRankings *user1 = [[UserRankings alloc] init];
    user1.specificUserName = @"mashton237";
    user1.score = 100;
    [allUsersRankings addObject:user1];
    
    UserRankings *user2 = [[UserRankings alloc] init];
    user2.specificUserName = @"soccer is fun";
    user2.score = 95;
    [allUsersRankings addObject:user2];
    
    UserRankings *user3 = [[UserRankings alloc] init];
    user3.specificUserName = @"ilovefootball";
    user3.score = 90;
    [allUsersRankings addObject:user3];
    
    UserRankings *user4 = [[UserRankings alloc] init];
    user4.specificUserName = @"United Forever";
    user4.score = 85;
    [allUsersRankings addObject:user4];
    
    UserRankings *user5 = [[UserRankings alloc] init];
    user5.specificUserName = @"chelsea4life";
    user5.score = 80;
    [allUsersRankings addObject:user5];
    
    UserRankings *user6 = [[UserRankings alloc] init];
    user6.specificUserName = @"giggsLeftFoot";
    user6.score = 75;
    [allUsersRankings addObject:user6];
    
    UserRankings *user7 = [[UserRankings alloc] init];
    user7.specificUserName = @"theCarrickRole";
    user7.score = 70;
    [allUsersRankings addObject:user7];
    
    UserRankings *user8 = [[UserRankings alloc] init];
    user8.specificUserName = @"full time devils";
    user8.score = 65;
    [allUsersRankings addObject:user8];
    
    UserRankings *user9 = [[UserRankings alloc] init];
    user9.specificUserName = @"jack wheelchair";
    user9.score = 60;
    [allUsersRankings addObject:user9];
    
    UserRankings *user10 = [[UserRankings alloc] init];
    user10.specificUserName = @"juan 'hugs' mata";
    user10.score = 55;
    [allUsersRankings addObject:user10];
    
    UserRankings *user11 = [[UserRankings alloc] init];
    user11.specificUserName = @"the best predictor";
    user11.score = 92;
    [allUsersRankings addObject:user11];
    
    UserRankings *user12 = [[UserRankings alloc] init];
    user12.specificUserName = @"GetMoneyAllDay";
    user12.score = 71;
    [allUsersRankings addObject:user12];
    
    UserRankings *user13 = [[UserRankings alloc] init];
    user13.specificUserName = @"i love real madrid";
    user13.score = 78;
    [allUsersRankings addObject:user13];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"score"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    sortedArray = [allUsersRankings sortedArrayUsingDescriptors:sortDescriptors];
    
}

@end
