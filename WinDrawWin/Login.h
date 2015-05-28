//
//  Login.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login : UIViewController <UIAlertViewDelegate>
{
    IBOutlet UIButton *loginButton;
    IBOutlet UIButton *setupAccount;
    IBOutlet UIButton *forgotUsername;
    IBOutlet UITextField *user;
    IBOutlet UITextField *password;
}

-(IBAction)login:(id)sender;
-(IBAction)forgotMyName:(id)sender;
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender;
-(IBAction)removeKeyboard:(id)sender;

@end
