//
//  CustomCell1.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/27/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "CustomCell1.h"

@implementation CustomCell1

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Refreshes Cell with the User's pick and the matchup
-(void)refreshCellWithInfo: (NSString*)myPick matchUp:(NSString *) matchUp
{
    pick.text = myPick;
    matchup.text = matchUp;
}

@end
