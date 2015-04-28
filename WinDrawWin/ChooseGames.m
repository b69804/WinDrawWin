//
//  ViewController.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 2/4/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "ChooseGames.h"
#import "selectedPick.h"
#import "Team.h"
#import <Parse/Parse.h>

@interface ChooseGames ()

@end

@implementation ChooseGames

- (void)viewDidLoad {
    
    gamesThisWeek = [[NSMutableArray alloc]init];
    choosenPick = [[selectedPick alloc] init];
    allPicks = [[NSMutableArray alloc] init];
    allTeams = [[NSMutableArray alloc] init];
    dictionaryOfTeams = [[NSMutableDictionary alloc] init];
    [self createAllTeams];
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
    NSString *hTeam = eachGame[@"HomeTeam"];
    NSString *aTeam = eachGame[@"AwayTeam"];
    choosenPick = [[selectedPick alloc] init];
    choosenPick.teamPicked = [dictionaryOfTeams objectForKey:hTeam];
    NSString *fullHome = choosenPick.teamPicked.name;
    selectedPick *awayTeamMatchUp = [[selectedPick alloc] init];
    awayTeamMatchUp.teamPicked = [dictionaryOfTeams objectForKey:aTeam];
    NSString *fullAway = awayTeamMatchUp.teamPicked.name;
    NSString *match = [NSString stringWithFormat:@"%@ vs %@", fullHome, fullAway];
    choosenPick.matchUp = match;
    [allPicks addObject:choosenPick];
    [self nextGame];
}

-(IBAction)onAwayTeamSelected:(id)sender{
    NSString *hTeam = eachGame[@"HomeTeam"];
    NSString *aTeam = eachGame[@"AwayTeam"];
    choosenPick = [[selectedPick alloc] init];
    choosenPick.teamPicked = [dictionaryOfTeams objectForKey:aTeam];
    NSString *fullAway = choosenPick.teamPicked.name;
    selectedPick *HomeTeamMatchUp = [[selectedPick alloc] init];
    HomeTeamMatchUp.teamPicked = [dictionaryOfTeams objectForKey:hTeam];
    NSString *fullHome = HomeTeamMatchUp.teamPicked.name;
    NSString *match = [NSString stringWithFormat:@"%@ vs %@", fullHome, fullAway];
    choosenPick.matchUp = match;
    [allPicks addObject:choosenPick];
    [self nextGame];
}

-(IBAction)onDrawselected:(id)sender{
    NSString *hTeam = eachGame[@"HomeTeam"];
    NSString *aTeam = eachGame[@"AwayTeam"];
    choosenPick = [[selectedPick alloc] init];
    choosenPick.teamPicked = [dictionaryOfTeams objectForKey:@"draw"];
    selectedPick *HomeTeamMatchUp = [[selectedPick alloc] init];
    HomeTeamMatchUp.teamPicked = [dictionaryOfTeams objectForKey:hTeam];
    NSString *fullHome = HomeTeamMatchUp.teamPicked.name;
    selectedPick *awayTeamMatchUp = [[selectedPick alloc] init];
    awayTeamMatchUp.teamPicked = [dictionaryOfTeams objectForKey:aTeam];
    NSString *fullAway = awayTeamMatchUp.teamPicked.name;
    NSString *match = [NSString stringWithFormat:@"%@ vs %@", fullHome, fullAway];
    
    choosenPick.matchUp = match;
    [allPicks addObject:choosenPick];
    [self nextGame];
}

-(IBAction)onStart:(id)sender{
    gameNumber = 0;
    [self nextGame];
    homeTeamButton.hidden = false;
    awayTeamButton.hidden = false;
    drawButton.hidden = false;
    start.hidden = true;
    
}

- (void)nextGame{
    
    if (gameNumber == 10) {
        UIAlertView *noMoreGames = [[UIAlertView alloc] initWithTitle:@"All Games Selected" message:@"You have made all your selections for this week.  Let's see what you picked." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [noMoreGames show];
    } else {
        eachGame = [gamesThisWeek objectAtIndex:gameNumber];
        NSString *hTeam = eachGame[@"HomeTeam"];
        Team *home = [[Team alloc] init];
        home = [dictionaryOfTeams objectForKey:hTeam];
        //[homeTeamButton setTitle:home.name forState:UIControlStateNormal];
        UIImage *homeImage = [UIImage imageNamed:home.logo];
        homeTeamButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        homeTeamButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        homeTeamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        homeTeamButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [homeTeamButton setBackgroundImage:homeImage forState:UIControlStateNormal];
        
        NSString *aTeam = eachGame[@"AwayTeam"];
        Team *away = [[Team alloc] init];
        away = [dictionaryOfTeams objectForKey:aTeam];
        //[awayTeamButton setTitle:away.name forState:UIControlStateNormal];
        UIImage *awayImage = [UIImage imageNamed:away.logo];
        awayTeamButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
        awayTeamButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        awayTeamButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [awayTeamButton setBackgroundImage:awayImage forState:UIControlStateNormal];
        
        gameNumber++;
    }
    NSLog(@"%d", gameNumber);
}

-(void)writeFile{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allPicks];
    PFFile *file = [PFFile fileWithName:@"picks.txt" data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *myPicks = [PFObject objectWithClassName:@"MyPicks"];
            myPicks[@"myPickFile"] = file;
            [myPicks saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (succeeded) {
                    [self performSegueWithIdentifier:@"myPicks" sender:self];
                } else {
                    NSLog(@"Did not save.");
                }
            }];
        } else {
            NSLog(@"Did not save.");
        }
    }];
}

-(void)createAllTeams{
    
    Team *arsenal = [[Team alloc] init];
    arsenal.name = @"Arsenal";
    arsenal.nickname = @"AFC";
    arsenal.stadium = @"Emirates";
    [allTeams addObject:arsenal];
    [dictionaryOfTeams setObject:arsenal forKey:arsenal.nickname];
    
    Team *leicester = [[Team alloc] init];
    leicester.name = @"Leicster City";
    leicester.nickname = @"LCFC";
    leicester.stadium = @"King Power Stadium";
    leicester.logo = @"LCFC.png";
    [allTeams addObject:leicester];
    [dictionaryOfTeams setObject:leicester forKey:leicester.nickname];
    
    Team *newcastle = [[Team alloc] init];
    newcastle.name = @"Newcastle United";
    newcastle.nickname = @"NUFC";
    newcastle.stadium = @"St. James Park";
    newcastle.logo = @"newcastle.png";
    [allTeams addObject:newcastle];
    [dictionaryOfTeams setObject:newcastle forKey:newcastle.nickname];
    
    Team *astonVilla = [[Team alloc] init];
    astonVilla.name = @"Aston Villa";
    astonVilla.nickname = @"AVFC";
    astonVilla.stadium = @"Villa Park";
    [allTeams addObject:astonVilla];
    [dictionaryOfTeams setObject:astonVilla forKey:astonVilla.nickname];
    
    Team *everton = [[Team alloc] init];
    everton.name = @"Everton";
    everton.nickname = @"EFC";
    everton.stadium = @"Goodison Park";
    [allTeams addObject:everton];
    [dictionaryOfTeams setObject:everton forKey:everton.nickname];
    
    Team *liverpool = [[Team alloc] init];
    liverpool.name = @"Liverpool";
    liverpool.nickname = @"LFC";
    liverpool.stadium = @"Anfield";
    [allTeams addObject:liverpool];
    [dictionaryOfTeams setObject:liverpool forKey:liverpool.nickname];
    
    Team *qpr = [[Team alloc] init];
    qpr.name = @"Queen's Park Rangers";
    qpr.nickname = @"QPR";
    qpr.stadium = @"Loftus Road";
    [allTeams addObject:qpr];
    [dictionaryOfTeams setObject:qpr forKey:qpr.nickname];
    
    Team *sunderland = [[Team alloc] init];
    sunderland.name = @"Sunderland";
    sunderland.nickname = @"SUFC";
    sunderland.stadium = @"Stadium of Light";
    [allTeams addObject:sunderland];
    [dictionaryOfTeams setObject:sunderland forKey:sunderland.nickname];
    
    Team *southampton = [[Team alloc] init];
    southampton.name = @"Southampton";
    southampton.nickname = @"SOFC";
    southampton.stadium = @"St. Mary's";
    [allTeams addObject:southampton];
    [dictionaryOfTeams setObject:southampton forKey:southampton.nickname];
    
    Team *swansea = [[Team alloc] init];
    swansea.name = @"Swansea City";
    swansea.nickname = @"SWAN";
    swansea.stadium = @"Liberty Stadium";
    [allTeams addObject:swansea];
    [dictionaryOfTeams setObject:swansea forKey:swansea.nickname];
    
    Team *stoke = [[Team alloc] init];
    stoke.name = @"Stoke City";
    stoke.nickname = @"STKE";
    stoke.stadium = @"Britannia Stadium";
    [allTeams addObject:stoke];
    [dictionaryOfTeams setObject:stoke forKey:stoke.nickname];
    
    Team *westham = [[Team alloc] init];
    westham.name = @"West Ham";
    westham.nickname = @"WHFC";
    westham.stadium = @"Boleyn Ground";
    [allTeams addObject:westham];
    [dictionaryOfTeams setObject:westham forKey:westham.nickname];
    
    Team *burnley = [[Team alloc] init];
    burnley.name = @"Burnley";
    burnley.nickname = @"BURN";
    burnley.stadium = @"Turf Moor";
    [allTeams addObject:burnley];
    [dictionaryOfTeams setObject:burnley forKey:burnley.nickname];
    
    Team *united = [[Team alloc] init];
    united.name = @"Manchester United";
    united.nickname = @"MUFC";
    united.stadium = @"Old Trafford";
    [allTeams addObject:united];
    [dictionaryOfTeams setObject:united forKey:united.nickname];
    
    Team *westbrom = [[Team alloc] init];
    westbrom.name = @"West Brom";
    westbrom.nickname = @"WBA";
    westbrom.stadium = @"The Hawthorns";
    [allTeams addObject:westbrom];
    [dictionaryOfTeams setObject:westbrom forKey:westbrom.nickname];
    
    Team *chelski = [[Team alloc] init];
    chelski.name = @"Chelsea";
    chelski.nickname = @"CFC";
    chelski.stadium = @"Stamford Bridge";
    [allTeams addObject:chelski];
    [dictionaryOfTeams setObject:chelski forKey:chelski.nickname];
    
    Team *crystalpalace = [[Team alloc] init];
    crystalpalace.name = @"Crystal Palace";
    crystalpalace.nickname = @"CPA";
    crystalpalace.stadium = @"Selhurst Park";
    [allTeams addObject:crystalpalace];
    [dictionaryOfTeams setObject:crystalpalace forKey:crystalpalace.nickname];
    
    Team *citeh = [[Team alloc] init];
    citeh.name = @"Manchester City";
    citeh.nickname = @"MCFC";
    citeh.stadium = @"Etihad Stadium";
    [allTeams addObject:citeh];
    [dictionaryOfTeams setObject:citeh forKey:citeh.nickname];
    
    Team *spurs = [[Team alloc] init];
    spurs.name = @"Tottenham";
    spurs.nickname = @"TOT";
    spurs.stadium = @"White Hart Lane";
    [allTeams addObject:spurs];
    [dictionaryOfTeams setObject:spurs forKey:spurs.nickname];
    
    Team *hull = [[Team alloc] init];
    hull.name = @"Hull City";
    hull.nickname = @"HULL";
    hull.stadium = @"KC Stadium";
    [allTeams addObject:hull];
    [dictionaryOfTeams setObject:hull forKey:hull.nickname];
    
    Team *draw = [[Team alloc] init];
    draw.name = @"Draw";
    draw.nickname = @"draw";
    draw.stadium = @"";
    [allTeams addObject:draw];
    [dictionaryOfTeams setObject:draw forKey:draw.nickname];
    
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self writeFile];
    }
}

@end
