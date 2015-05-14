//
//  Settings.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 5/14/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "Settings.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
