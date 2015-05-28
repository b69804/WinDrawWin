//
//  Settings.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 5/14/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "Settings.h"
#import <Parse/Parse.h>

@interface Settings ()

@end

@implementation Settings

- (void)viewDidLoad {

    NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
    twitterSettings = [thisUsersDefaults objectForKey:@"twitter"];
    if (twitterSettings == NO){
        [twitterSwitch setOn:NO];
    } else if (twitterSettings){
        [twitterSwitch setOn:YES];
    }
    
    facebookSettings = [thisUsersDefaults objectForKey:@"facebook"];
    if (facebookSettings == NO){
        [facebookSwitch setOn:NO];
    } else if (facebookSettings){
        [facebookSwitch setOn:YES];
    }
    
    timeSettings = [thisUsersDefaults objectForKey:@"time"];
    if (timeSettings == NO){
        [timeSwitch setOn:NO];
    } else if (timeSettings){
        [timeSwitch setOn:YES];
    }
    
    [super viewDidLoad];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTwitterSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
        BOOL TwitterSetting = YES;
        [thisUsersDefaults setBool:TwitterSetting forKey:@"twitter"];
        [thisUsersDefaults synchronize];
    } else{
        NSLog(@"Switch is OFF");
        NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
        BOOL TwitterSetting = NO;
        [thisUsersDefaults setBool:TwitterSetting forKey:@"twitter"];
        [thisUsersDefaults synchronize];
    }
    
}

- (IBAction)changeFacebookSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
        BOOL FacebookSetting = YES;
        [thisUsersDefaults setBool:FacebookSetting forKey:@"facebook"];
        [thisUsersDefaults synchronize];
    } else{
        NSLog(@"Switch is OFF");
        NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
        BOOL FacebookSetting = NO;
        [thisUsersDefaults setBool:FacebookSetting forKey:@"facebook"];
        [thisUsersDefaults synchronize];
    }
    
}

- (IBAction)changeTimeSwitch:(id)sender{
    
    if([sender isOn]){
        NSLog(@"Switch is ON");
        NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
        BOOL TimeSetting = YES;
        [thisUsersDefaults setBool:TimeSetting forKey:@"time"];
        [thisUsersDefaults synchronize];
    } else{
        NSLog(@"Switch is OFF");
        NSUserDefaults *thisUsersDefaults = [NSUserDefaults standardUserDefaults];
        BOOL TimeSetting = YES;
        [thisUsersDefaults setBool:TimeSetting forKey:@"time"];
        [thisUsersDefaults synchronize];
    }
    
}

- (IBAction)changePassword:(id)sender{
 
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Change your Password" message:@"Enter a new Password.  Keep your picks secure!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert addButtonWithTitle:@"Change Now!"];
    alert.tag = 1;
    [alert show];
}




- (IBAction)changeUsername:(id)sender{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Change your Username or Email" message:@"Please choose what you would like to change..." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
    alert.alertViewStyle = UIAlertViewStyleDefault;
    [alert addButtonWithTitle:@"Change Username"];
    [alert addButtonWithTitle:@"Change Email"];
    alert.tag = 0;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    BOOL everythingGood = true;
    int length = 8;
    if (alertView.tag == 0) {
        if (buttonIndex == 1) {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Change your Username" message:@"Enter a new Username.  We need to know what to put at the top of the leaderboards!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setPlaceholder:@"Change Username"];
            [alert addButtonWithTitle:@"Change Now!"];
            alert.tag = 3;
            [alert show];
        } else if (buttonIndex == 2) {
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Change your Email" message:@"Enter a new Email Address.  We need to know what to use if you forget something!" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [[alert textFieldAtIndex:0] setPlaceholder:@"Change Email"];
            [alert addButtonWithTitle:@"Change Now!"];
            alert.tag = 4;
            [alert show];
        }
    }
    
    if (alertView.tag == 3) {
        UITextField *username = [alertView textFieldAtIndex:0];
        NSString *newUserName = username.text;
            if([newUserName isEqualToString:@""]){
                everythingGood = false;
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"We gotta know what to call you!"
                                      message:@"Please enter a Username so you can brag about your high scores!"
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            } else if (newUserName.length < length){
                everythingGood = false;
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"So close yet so far"
                                      message:@"Please enter a Username with at least 8 characters. You are a couple letters short!"
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            }
            if (everythingGood) {
                PFUser *UsersNewName = [PFUser currentUser];
                UsersNewName.username = newUserName;
                
                [UsersNewName saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (!error) {
                        UIAlertView * alert =[[UIAlertView alloc ]
                                              initWithTitle:@"Username updated!"
                                              message:@"You have successfully changed your name!"
                                              delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
                        [alert show];
                    } else if (error.code == 202){
                        UIAlertView * alert =[[UIAlertView alloc ]
                                              initWithTitle:@"Username already in use!"
                                              message:@"Somebody is already climbing the leaderboards with that name.  Please choose another one!"
                                              delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles: nil];
                        [alert show];
                    }else {
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
    if (alertView.tag == 4) {
        UITextField *email = [alertView textFieldAtIndex:0];
        NSString *newEmail = email.text;
        if([newEmail isEqualToString:@""]){
            everythingGood = false;
            UIAlertView * alert =[[UIAlertView alloc ]
                                  initWithTitle:@"We gotta know where to reach you!"
                                  message:@"Please enter an Email address so we can get in touch if you forget your Username or Password!"
                                  delegate:self
                                  cancelButtonTitle:@"Okay"
                                  otherButtonTitles: nil];
            [alert show];
        }
        if (everythingGood) {
            PFUser *UsersNewEmail = [PFUser currentUser];
            UsersNewEmail.email = newEmail;
            
            [UsersNewEmail saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                if (!error) {
                    UIAlertView * alert =[[UIAlertView alloc ]
                                          initWithTitle:@"Email updated!"
                                          message:@"You have successfully changed your Email!"
                                          delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles: nil];
                    [alert show];
                } else if (error.code == 203){
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
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            UITextField *password = [alertView textFieldAtIndex:0];
            NSString *newPassWord = password.text;
            if([newPassWord isEqualToString:@""]){
                everythingGood = false;
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"You gotta put in a Password"
                                      message:@"Please enter a Password so no one can sabotage your picks."
                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            } else if (newPassWord.length < length){
                everythingGood = false;
                UIAlertView * alert =[[UIAlertView alloc ]
                                      initWithTitle:@"So close yet so far"
                                      message:@"Please enter a Password with at least 8 characters. You are a couple letters short!"                                      delegate:self
                                      cancelButtonTitle:@"Okay"
                                      otherButtonTitles: nil];
                [alert show];
            }
            if (everythingGood) {
                PFUser *UsersNewPassword = [PFUser currentUser];
                UsersNewPassword.password = newPassWord;
                
                [UsersNewPassword saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
                    if (!error) {
                        UIAlertView * alert =[[UIAlertView alloc ]
                                              initWithTitle:@"Password updated!"
                                              message:@"You have successfully changed your Password!"
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
    }    
}

@end
