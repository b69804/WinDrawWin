//
//  Settings.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 5/14/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController <UIAlertViewDelegate>

{
    IBOutlet UISwitch *twitterSwitch;
    IBOutlet UISwitch *facebookSwitch;
    IBOutlet UISwitch *timeSwitch;
    IBOutlet UISwitch *notificationsSwitch;
    IBOutlet UIButton *changeUsername;
    IBOutlet UIButton *changePassword;
    
    BOOL twitterSettings;
    BOOL facebookSettings;
    BOOL timeSettings;
    BOOL notifications;
}

- (IBAction)changeTwitterSwitch:(id)sender;
- (IBAction)changeFacebookSwitch:(id)sender;
- (IBAction)changeTimeSwitch:(id)sender;
- (IBAction)changeUsername:(id)sender;
- (IBAction)changePassword:(id)sender;

@end
