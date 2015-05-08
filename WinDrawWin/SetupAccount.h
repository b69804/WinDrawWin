//
//  SetupAccount.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetupAccount : UIViewController
{
    IBOutlet UIButton *createAccount;
    IBOutlet UITextField *user;
    IBOutlet UITextField *password;
    IBOutlet UITextField *email;
}

-(IBAction)removeKeyboard:(id)sender;
-(IBAction)createAccount:(id)sender;

@end
