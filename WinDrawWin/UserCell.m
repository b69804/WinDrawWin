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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)refreshCellWithInfo: (NSString *)thisWeek
{
    eachWeek.text = thisWeek;
    
}

/*-(void)refreshCellWithInfo: (NSString *)thisWeek myScore:(NSString *) myScore
{
    eachWeek.text = thisWeek;
    scoreForThatWeek.text = myScore;
}*/

@end
