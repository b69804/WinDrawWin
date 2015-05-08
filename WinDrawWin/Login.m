//
//  Login.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "Login.h"
#import <Parse/Parse.h>
#import "Reachability.h"

@interface Login ()

@end

@implementation Login

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityDidChange:) name:kReachabilityChangedNotification object:nil];
    
    PFUser *userLoggedIn = [PFUser currentUser];
    if (userLoggedIn) {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}



-(IBAction)login:(id)sender{
    BOOL everythingGood = true;
    NSString *check1 = user.text;
    NSString *check2 = password.text;
    if([check1 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Need your Username"
                              message:@"Please enter your Username."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        alert.tag = 2;
        [alert show];
    } else if ([check2 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Need your Passsword"
                              message:@"Please enter your Password."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        alert.tag = 2;
        [alert show];
    }
    if (everythingGood) {
        [PFUser logInWithUsernameInBackground:user.text password:password.text block:^(PFUser *loggedInUser, NSError *error) {
            if(loggedInUser){
                [self performSegueWithIdentifier:@"login" sender:self];
                NSLog(@"Logged In.");
            } else {
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"Not able to login."
                                      message:@"Please check your Username or Password!"
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: @"Lost Password?", nil];
                alert.tag = 1;
                [alert show];
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        if (buttonIndex == 1) {
            UIAlertView * passwordReset =[[UIAlertView alloc ]
                                  initWithTitle:@"Lost your Password?"
                                  message:@"Please enter your email address below. Click Okay to send an email to your registered email address to reset your password."
                                  delegate:self
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles:@"Cancel", nil];
            passwordReset.alertViewStyle = UIAlertViewStylePlainTextInput;
            passwordReset.tag = 3;
            [passwordReset show];
        }
    } else if (alertView.tag == 2) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    
    } else if(alertView.tag == 3) {
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        if (buttonIndex == 0) {
            UITextField *username = [alertView textFieldAtIndex:0];
            [PFUser requestPasswordResetForEmailInBackground:username.text];
            user.text = @"";
            password.text = @"";
        }
    }
}


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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    PFUser *userLoggedIn = [PFUser currentUser];
    if ([identifier isEqualToString:@"login" ]) {
        if (!userLoggedIn){
            return NO;
        }
    }
    return YES;
}


-(IBAction)removeKeyboard:(id)sender
{
    UITextField *theField = (UITextField*)sender;
    [theField resignFirstResponder];
}



@end
