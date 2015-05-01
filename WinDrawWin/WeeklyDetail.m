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


@end
