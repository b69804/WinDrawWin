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

-(IBAction)createAccount:(id)sender{
    
    BOOL everythingGood = true;
    NSString *check1 = user.text;
    NSString *check2 = password.text;
    NSString *check3 = email.text;
    int length = 8;
    if([check1 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Username not valid"
                              message:@"Please enter a Username."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    } else if ([check2 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Passsword not valid"
                              message:@"Please enter a Password."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    } else if ([check3 isEqualToString:@""]){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Email not valid"
                              message:@"Please enter an Email Address."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    
    } else if(check1.length < length){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Username not long enough."
                              message:@"Please enter a Username with at least 8 characters."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    } else if (check2.length < length){
        everythingGood = false;
        UIAlertView * alert =[[UIAlertView alloc ]
                              initWithTitle:@"Passsword not long enough."
                              message:@"Please enter a Password with at least 8 characters."
                              delegate:self
                              cancelButtonTitle:@"Okay"
                              otherButtonTitles: nil];
        [alert show];
    }
    
    if (everythingGood) {
        PFUser *newUser = [PFUser user];
        newUser.username = user.text;
        newUser.password = password.text;
        newUser.email = email.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
            if (!error) {
                [self performSegueWithIdentifier:@"createdUser" sender:self];
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
