//
//  ViewController.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 2/4/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "ChooseGames.h"
#import <Parse/Parse.h>

@interface ChooseGames ()

@end

@implementation ChooseGames

- (void)viewDidLoad {
    
    gamesThisWeek = [[NSMutableArray alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Week24"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [query orderByAscending:@"GameNo"];
            for (PFObject *object in objects) {
                [gamesThisWeek addObject:object];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    homeTeamButton.hidden = true;
    awayTeamButton.hidden = true;
    drawButton.hidden = true;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onHomeTeamSelected:(id)sender{

}

-(IBAction)onAwayTeamSelected:(id)sender{

}

-(IBAction)onDrawselected:(id)sender{

}

-(IBAction)onStart:(id)sender{
    
    PFObject *firstGame = [gamesThisWeek objectAtIndex:0];
    NSString *hTeam = firstGame[@"HomeTeam"];
    [homeTeamButton setTitle:hTeam forState:UIControlStateNormal];
    NSString *aTeam = firstGame[@"AwayTeam"];
    [awayTeamButton setTitle:aTeam forState:UIControlStateNormal];
    
    homeTeamButton.hidden = false;
    awayTeamButton.hidden = false;
    drawButton.hidden = false;
}

@end
