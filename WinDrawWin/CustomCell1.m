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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCellWithInfo: (NSString*)myPick matchUp:(NSString *) matchUp
{
    pick.text = myPick;
    matchup.text = matchUp;
}

@end
