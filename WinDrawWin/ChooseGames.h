//
//  ViewController.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 2/4/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Team.h"

@class selectedPick;

@interface ChooseGames : UIViewController <UIAlertViewDelegate>


{
    NSMutableArray *gamesThisWeek;
    IBOutlet UIButton *homeTeamButton;
    IBOutlet UIButton *awayTeamButton;
    IBOutlet UIButton *drawButton;
    IBOutlet UIImageView *homeImageView;
    IBOutlet UIImageView *awayImageView;
    IBOutlet UIImageView *drawImageView;
    IBOutlet UILabel *countdown;
    IBOutlet UILabel *gameTime;
    NSTimer *timer;
    BOOL paused;
    int timeSec;
    IBOutlet UIButton *start;
    NSNumber *myTimeForPicks;
    PFObject *eachGame;
    int gameNumber;
    bool *firstGame;
    selectedPick *choosenPick;
    NSMutableArray *allPicks;
    NSMutableArray *allTeams;
    NSMutableDictionary *dictionaryOfTeams;
    NSString *currentWeek;
    IBOutlet UIProgressView *progressView;
}

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;

-(IBAction)onHomeTeamSelected:(id)sender;
-(IBAction)onAwayTeamSelected:(id)sender;
-(IBAction)onDrawselected:(id)sender;
-(IBAction)onStart:(id)sender;
-(void)createAllTeams;
-(void) StartTimer;



@end

