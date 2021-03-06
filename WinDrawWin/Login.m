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

// Used to provide user a way to retrieve their Username using their provided email address
-(IBAction)forgotMyName:(id)sender
{
    UIAlertView * alert =[[UIAlertView alloc ] // Alert to retrieve Username
                          initWithTitle:@"Can't remember your Username?"
                          message:@"Please enter the email address associated with your account and we will show you your Username!"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert addButtonWithTitle:@"Show me my Username!"];
    alert.tag = 4;
    [alert show];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// Checks login credentials and logs user in.  If there is an error, the User is told what is wrong.
-(IBAction)login:(id)sender{
    BOOL everythingGood = true;
    NSString *check1 = user.text;
    NSString *check2 = password.text;
    if([check1 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ] // Alert for Username issue
                              initWithTitle:@"Need your Username"
                              message:@"Please enter your Username."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        alert.tag = 2;
        [alert show];
    } else if ([check2 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ] // Alert for Password Issue
                              initWithTitle:@"Need your Passsword"
                              message:@"Please enter your Password."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        alert.tag = 2;
        [alert show];
    }
    // If Username and password meet requirements, the user is logged into Parse
    if (everythingGood) {
        [PFUser logInWithUsernameInBackground:user.text password:password.text block:^(PFUser *loggedInUser, NSError *error) {
            if(loggedInUser){
                [self performSegueWithIdentifier:@"login" sender:self]; // User is logged into WinDrawWin
            } else {
                UIAlertView * alert =[[UIAlertView alloc ] // Alert to show there is an error with Login
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
    // Password is incorrect, but Username is accurate.  Password is able to be reset.
    if (alertView.tag == 1)
    {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        if (buttonIndex == 1) {
            UIAlertView * passwordReset =[[UIAlertView alloc ] // Alert to retrieve/reset password
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
        // Alert if no email is found for User
        [alertView dismissWithClickedButtonIndex:1 animated:YES];
        if (buttonIndex == 0) {
            UITextField *username = [alertView textFieldAtIndex:0];
            // Password reset from Parse is sent
            [PFUser requestPasswordResetForEmailInBackground:username.text block:^(BOOL succeeded, NSError *error){
                if (error.code == 125) {
                    UIAlertView * invalidEmail =[[UIAlertView alloc ] // Alert stating that no account is found
                                                  initWithTitle:@"No email address found!"
                                                  message:@"We could try locate a WinDrawWin account under that email address.  Please try again or create a new account!"
                                                  delegate:self
                                                  cancelButtonTitle:@"Okay"
                                                  otherButtonTitles: nil];
                    [invalidEmail show];
                }
                
            }];
            user.text = @"";
            password.text = @"";
        }
    } else if (alertView.tag == 4) {
        if (buttonIndex == 1){
            NSString *email = [alertView textFieldAtIndex:0].text;
            PFQuery *query = [PFUser query];
            [query whereKey:@"email" equalTo:email];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
                if (!error) {
                    for (PFObject *object in objects) {
                        NSString *thisUsersUsername = object[@"username"];
                        NSString *alertMessage = [NSString stringWithFormat:@"The Username associated with the given Email address is:\n %@", thisUsersUsername];
                        UIAlertView * alert =[[UIAlertView alloc ] // Presents Username to user
                                              initWithTitle:@"Found your Username!"
                                              message:alertMessage
                                              delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
                        [alert show];
                    }
                } else {
                
                }
            }];
        }
    }
}

// Test for internet connectivity
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

// Logs user in if they have already been logged in previously.
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    PFUser *userLoggedIn = [PFUser currentUser];
    if ([identifier isEqualToString:@"login" ]) {
        if (!userLoggedIn){
            return NO;
        }
    }
    return YES;
}

// Allows the user to dismiss the keyboard
-(IBAction)removeKeyboard:(id)sender
{
    UITextField *theField = (UITextField*)sender;
    [theField resignFirstResponder];
}


@end
