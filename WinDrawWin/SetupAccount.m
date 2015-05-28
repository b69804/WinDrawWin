//
//  SetupAccount.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "SetupAccount.h"
#import "Reachability.h"
#import <Parse/Parse.h>

@interface SetupAccount ()

@end

@implementation SetupAccount

- (void)viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Checks for internet connectivity
- (void)reachabilityDidChange:(NSNotification *)notification {
    Reachability *reachability = (Reachability *)[notification object];
    
    if ([reachability isReachable]) {
        NSLog(@"Reachable");
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

// Checks for various username and password requirements.
-(IBAction)createAccount:(id)sender{
    
    BOOL everythingGood = true;
    NSString *check1 = user.text;
    NSString *check2 = password.text;
    NSString *check3 = email.text;
    int length = 8;
    if([check1 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"We gotta know what to call you!"
                              message:@"Please enter a Username so you can brag about your high scores!"
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    } else if ([check2 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Make your profile secure!"
                              message:@"Please enter a Password so no one can sabotage your picks."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    } else if ([check3 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Just in case you forget your stuff..."
                              message:@"Please enter an Email Address so you can retrieve any of your info."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    
    } else if(check1.length < length){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"So close yet so far"
                              message:@"Please enter a Username with at least 8 characters. You are a couple letters short!"
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    } else if (check2.length < length){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"So close yet so far"
                              message:@"Please enter a Password with at least 8 characters. You are a couple letters short!"
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    }
    // User account is created if everything is good.
    if (everythingGood) {
        PFUser *newUser = [PFUser user];
        newUser.username = user.text;
        newUser.password = password.text;
        newUser.email = email.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                [self performSegueWithIdentifier:@"createdUser" sender:self];
            } else if (error.code == 202){
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"Username already in use!"
                                      message:@"Somebody is already climbing the leaderboards with that name.  Please choose another one!"
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            }else if (error.code == 203){
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"Email already in use!"
                                      message:@"There is already an account registered with that email address.  Please use a different email or head on back to the main page to login and start making picks."
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            } else {
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"Registration not Complete"
                                      message:@"There was an issue with your Registration. Please try again."
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            }
        }];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

-(IBAction)removeKeyboard:(id)sender
{
    UITextField *theField = (UITextField*)sender;
    [theField resignFirstResponder];
}


@end
