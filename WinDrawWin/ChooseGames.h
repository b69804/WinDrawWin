//
//  ViewController.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 2/4/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseGames : UIViewController
{
    NSMutableArray *gamesThisWeek;
    IBOutlet UIButton *homeTeamButton;
    IBOutlet UIButton *awayTeamButton;
    IBOutlet UIButton *drawButton;
    IBOutlet UIButton *start;
    int *gameNumber;
}

-(IBAction)onHomeTeamSelected:(id)sender;
-(IBAction)onAwayTeamSelected:(id)sender;
-(IBAction)onDrawselected:(id)sender;
-(IBAction)onStart:(id)sender;



@end

