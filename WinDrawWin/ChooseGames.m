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
#import "Reachability.h"

@interface ChooseGames ()

@end

@implementation ChooseGames

@synthesize progressView;

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    // User defaults for time label
    NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
    BOOL timeSetting = [thisUsersDefaults boolForKey:@"time"];
    if (timeSetting == YES) {
        gameTime.hidden = true;
        countdown.hidden = true;
    }
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser == nil){
        [self performSegueWithIdentifier:@"logout" sender:self];
    }
    gamesThisWeek = [[NSMutableArray alloc]init];
    choosenPick = [[selectedPick alloc] init];
    allPicks = [[NSMutableArray alloc] init];
    allTeams = [[NSMutableArray alloc] init];
    dictionaryOfTeams = [[NSMutableDictionary alloc] init];
    [self createAllTeams]; // Creates all the EPL teams
    // get the games for the current week.  Current week is set in Parse.
    PFQuery *weekQuery = [PFQuery queryWithClassName:@"CurrentWeek"];
    [weekQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                currentWeek = object[@"CurrentWeek"];
                PFQuery *query = [PFQuery queryWithClassName:@"Week24"];
                [query whereKey:@"Week" containsString:currentWeek];
                [query orderByAscending:@"GameNo"];
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            [gamesThisWeek addObject:object]; // Adds game objects from Parse
                        }
                    } else {
                        NSLog(@"Error: %@ %@", error, [error userInfo]);
                    }
                }];
            }
        } else {
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

// Home team is selected and that pick is logged.
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
    choosenPick.gameNumber = eachGame[@"GameNo"];
    [allPicks addObject:choosenPick];  // Home team is picked, and the matchup is added to the choosen picks array
    [self nextGame];
}

// Away team is set and pick is logged.
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
    choosenPick.gameNumber = eachGame[@"GameNo"];
    [allPicks addObject:choosenPick]; // Away team is picked, and the matchup is added to the choosen picks array
    [self nextGame];
}

// Draw is selected and pick is logged.
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
    choosenPick.gameNumber = eachGame[@"GameNo"];
    choosenPick.matchUp = match;
    [allPicks addObject:choosenPick]; // Draw is picked, and the matchup is added to the choosen picks array
    [self nextGame];
}

// Checks internet connectivity
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
    } else {
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Check your Interwebs!"
                              message:@"We are having trouble connecting to the internet.  Please check your network settings and get a valid data connection."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    }
}

// Starts the Game Pick process.  Also checks if user made picks.
-(IBAction)onStart:(id)sender
{
    [allPicks removeAllObjects];
    PFQuery *weekQuery = [PFQuery queryWithClassName:@"CurrentWeek"];
    [weekQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if (!error) {
            for (PFObject *object in objects) {
                currentWeek = object[@"CurrentWeek"];
                PFQuery *query = [PFQuery queryWithClassName:@"MyPicks"];
                [query whereKey:@"WeekNo" containsString:currentWeek];
                // if picks are present for the user, an alert is shown
                [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                    if (objects.count == 1) {
                        UIAlertView *pickGames = [[UIAlertView alloc] // Alert stating picks have already been made
                                                  initWithTitle:@"Picks already made!"
                                                  message:@"Looks like you have already made picks for this week.  Please review your picks."
                                                  delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles:nil];
                        pickGames.tag = 1;
                        [pickGames show];
                    } else {
                        gameNumber = 0;
                        [self nextGame]; // Next game is loaded
                        homeTeamButton.hidden = false;
                        awayTeamButton.hidden = false;
                        drawButton.hidden = false;
                        start.hidden = true;
                        [self StartTimer]; // Timer starts
                    }  
                }];
            }
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    
    }];
    
}

// Loads the next game matchup
- (void)nextGame{
    
    if (gameNumber == 10) {
        paused = YES;
        [self writeFile]; // Saves file to Parse
        UIAlertView *noMoreGames = [[UIAlertView alloc] // When all picks are made, alert is shown saying all picks are made
                                    initWithTitle:@"All Games Selected"
                                    message:@"You have made all your selections for this week.  Let's see what you picked."
                                    delegate:self
                                    cancelButtonTitle:@"Okay"
                                    otherButtonTitles:nil];
        noMoreGames.tag = 2;
        [noMoreGames show];
    } else {
        // Gets next match up from array.  Loads images to buttons
        drawImageView.hidden = true;
        eachGame = [gamesThisWeek objectAtIndex:gameNumber];
        NSString *hTeam = eachGame[@"HomeTeam"];
        Team *home = [[Team alloc] init];
        home = [dictionaryOfTeams objectForKey:hTeam];
        UIImage *homeImage = [UIImage imageNamed:home.logo];
        homeImageView.image = homeImage;
        
        NSString *aTeam = eachGame[@"AwayTeam"];
        Team *away = [[Team alloc] init];
        away = [dictionaryOfTeams objectForKey:aTeam];
        UIImage *awayImage = [UIImage imageNamed:away.logo];
        awayImageView.image = awayImage;
        
        drawImageView.image = [UIImage imageNamed:@"Draw.png"];
        
        drawImageView.hidden = false;
        gameNumber++;
    }
}

// Saves completed picks to Parse.
-(void)writeFile{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:allPicks];
    PFUser* current = [PFUser currentUser];
    PFFile *file = [PFFile fileWithName:@"picks.txt" data:data];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            PFObject *myPicks = [PFObject objectWithClassName:@"MyPicks"];
            myPicks.ACL = [PFACL ACLWithUser:current]; // Sets the picks to only the current user
            myPicks[@"myPickFile"] = file;
            myPicks[@"WeekNo"] = eachGame[@"Week"];
            myTimeForPicks = [NSNumber numberWithInt:(90 - timeSec)];
            myPicks[@"Time"] = myTimeForPicks;
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus internetStatus = [reachability currentReachabilityStatus];
            if (internetStatus != NotReachable){
                [myPicks saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (succeeded) {
                        progressView.hidden = false;
                        [self startCount]; // Starts progress bar while data is saving
                    } else {
                        NSLog(@"Did not save.");
                    }
                }];
            }
        } else {
            NSLog(@"Did not save.");
        }
    }];
}

// Starts timer
-(void) StartTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}


// Starts game timer
- (void)timerTick:(NSTimer *)timer
{
    if (paused == NO){
        timeSec++;
        if (timeSec == 90)
        {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Time's Up!"
                                                             message:@"You have run out of time!"
                                                            delegate:self
                                                   cancelButtonTitle:@"Okay."
                                                   otherButtonTitles: nil];
            [alert show];
            paused = YES;
        }
        NSString* timeNow = [NSString stringWithFormat:@"%02d", timeSec];
        countdown.text= timeNow;
    }
}

// Timer for progress bar
- (void)startCount
{
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI:) userInfo:nil repeats:YES];
}

// Updates progress bar
- (void)updateUI:(NSTimer *)timer
{
    static int count =0; count++;
    
    if (count <=5)
    {
        self.progressView.progress = (float)count/5.0f;
    } else
    {
        [self.myTimer invalidate];
        self.myTimer = nil;
    } 
}

// Creates Array for all EPL Teams.
-(void)createAllTeams{
    
    Team *arsenal = [[Team alloc] init];
    arsenal.name = @"Arsenal";
    arsenal.nickname = @"AFC";
    arsenal.stadium = @"Emirates";
    arsenal.logo = @"arsenal.png";
    [allTeams addObject:arsenal];
    [dictionaryOfTeams setObject:arsenal forKey:arsenal.nickname];
    
    Team *leicester = [[Team alloc] init];
    leicester.name = @"Leicster City";
    leicester.nickname = @"LCFC";
    leicester.stadium = @"King Power Stadium";
    leicester.logo = @"lcfc.png";
    [allTeams addObject:leicester];
    [dictionaryOfTeams setObject:leicester forKey:leicester.nickname];
    
    Team *newcastle = [[Team alloc] init];
    newcastle.name = @"Newcastle United";
    newcastle.nickname = @"NUFC";
    newcastle.stadium = @"St. James Park";
    newcastle.logo = @"nufc.png";
    [allTeams addObject:newcastle];
    [dictionaryOfTeams setObject:newcastle forKey:newcastle.nickname];
    
    Team *astonVilla = [[Team alloc] init];
    astonVilla.name = @"Aston Villa";
    astonVilla.nickname = @"AVFC";
    astonVilla.stadium = @"Villa Park";
    astonVilla.logo = @"villa.png";
    [allTeams addObject:astonVilla];
    [dictionaryOfTeams setObject:astonVilla forKey:astonVilla.nickname];
    
    Team *everton = [[Team alloc] init];
    everton.name = @"Everton";
    everton.nickname = @"EFC";
    everton.stadium = @"Goodison Park";
    everton.logo = @"everton.png";
    [allTeams addObject:everton];
    [dictionaryOfTeams setObject:everton forKey:everton.nickname];
    
    Team *liverpool = [[Team alloc] init];
    liverpool.name = @"Liverpool";
    liverpool.nickname = @"LFC";
    liverpool.stadium = @"Anfield";
    liverpool.logo = @"liverpool.png";
    [allTeams addObject:liverpool];
    [dictionaryOfTeams setObject:liverpool forKey:liverpool.nickname];
    
    Team *qpr = [[Team alloc] init];
    qpr.name = @"Queen's Park Rangers";
    qpr.nickname = @"QPR";
    qpr.stadium = @"Loftus Road";
    qpr.logo = @"QPR.png";
    [allTeams addObject:qpr];
    [dictionaryOfTeams setObject:qpr forKey:qpr.nickname];
    
    Team *sunderland = [[Team alloc] init];
    sunderland.name = @"Sunderland";
    sunderland.nickname = @"SUFC";
    sunderland.stadium = @"Stadium of Light";
    sunderland.logo = @"sunderland.png";
    [allTeams addObject:sunderland];
    [dictionaryOfTeams setObject:sunderland forKey:sunderland.nickname];
    
    Team *southampton = [[Team alloc] init];
    southampton.name = @"Southampton";
    southampton.nickname = @"SOFC";
    southampton.stadium = @"St. Mary's";
    southampton.logo = @"southampton.png";
    [allTeams addObject:southampton];
    [dictionaryOfTeams setObject:southampton forKey:southampton.nickname];
    
    Team *swansea = [[Team alloc] init];
    swansea.name = @"Swansea City";
    swansea.nickname = @"SWAN";
    swansea.stadium = @"Liberty Stadium";
    swansea.logo = @"swansea.png";
    [allTeams addObject:swansea];
    [dictionaryOfTeams setObject:swansea forKey:swansea.nickname];
    
    Team *stoke = [[Team alloc] init];
    stoke.name = @"Stoke City";
    stoke.nickname = @"STKE";
    stoke.stadium = @"Britannia Stadium";
    stoke.logo = @"stokecity.png";
    [allTeams addObject:stoke];
    [dictionaryOfTeams setObject:stoke forKey:stoke.nickname];
    
    Team *westham = [[Team alloc] init];
    westham.name = @"West Ham";
    westham.nickname = @"WHFC";
    westham.stadium = @"Boleyn Ground";
    westham.logo = @"westham.png";
    [allTeams addObject:westham];
    [dictionaryOfTeams setObject:westham forKey:westham.nickname];
    
    Team *burnley = [[Team alloc] init];
    burnley.name = @"Burnley";
    burnley.nickname = @"BURN";
    burnley.stadium = @"Turf Moor";
    burnley.logo = @"burnley.png";
    [allTeams addObject:burnley];
    [dictionaryOfTeams setObject:burnley forKey:burnley.nickname];
    
    Team *united = [[Team alloc] init];
    united.name = @"Manchester United";
    united.nickname = @"MUFC";
    united.stadium = @"Old Trafford";
    united.logo = @"united.png";
    [allTeams addObject:united];
    [dictionaryOfTeams setObject:united forKey:united.nickname];
    
    Team *westbrom = [[Team alloc] init];
    westbrom.name = @"West Brom";
    westbrom.nickname = @"WBA";
    westbrom.stadium = @"The Hawthorns";
    westbrom.logo = @"westbrom.png";
    [allTeams addObject:westbrom];
    [dictionaryOfTeams setObject:westbrom forKey:westbrom.nickname];
    
    Team *chelski = [[Team alloc] init];
    chelski.name = @"Chelsea";
    chelski.nickname = @"CFC";
    chelski.stadium = @"Stamford Bridge";
    chelski.logo = @"chelsea.png";
    [allTeams addObject:chelski];
    [dictionaryOfTeams setObject:chelski forKey:chelski.nickname];
    
    Team *crystalpalace = [[Team alloc] init];
    crystalpalace.name = @"Crystal Palace";
    crystalpalace.nickname = @"CPA";
    crystalpalace.stadium = @"Selhurst Park";
    crystalpalace.logo = @"palace.png";
    [allTeams addObject:crystalpalace];
    [dictionaryOfTeams setObject:crystalpalace forKey:crystalpalace.nickname];
    
    Team *citeh = [[Team alloc] init];
    citeh.name = @"Manchester City";
    citeh.nickname = @"MCFC";
    citeh.stadium = @"Etihad Stadium";
    citeh.logo = @"citeh.png";
    [allTeams addObject:citeh];
    [dictionaryOfTeams setObject:citeh forKey:citeh.nickname];
    
    Team *spurs = [[Team alloc] init];
    spurs.name = @"Tottenham";
    spurs.nickname = @"TOT";
    spurs.stadium = @"White Hart Lane";
    spurs.logo = @"spurs.png";
    [allTeams addObject:spurs];
    [dictionaryOfTeams setObject:spurs forKey:spurs.nickname];
    
    Team *hull = [[Team alloc] init];
    hull.name = @"Hull City";
    hull.nickname = @"HULL";
    hull.stadium = @"KC Stadium";
    hull.logo = @"hull.png";
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
    if (alertView.tag == 2)
    {
        [self performSegueWithIdentifier:@"myPicks" sender:self];
    } else if (alertView.tag == 1){
        [self performSegueWithIdentifier:@"myPicks" sender:self];
    }
}

@end
