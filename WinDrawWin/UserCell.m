//
//  UserCell.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// Refreshes cell with the week that the picks will be displayed for.
-(void)refreshCellWithInfo: (NSString *)thisWeek
{
    eachWeek.text = thisWeek;
    
}

@end
