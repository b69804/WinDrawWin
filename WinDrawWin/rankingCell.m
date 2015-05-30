//
//  rankingCell.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/29/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "rankingCell.h"

@implementation rankingCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

// Refreshes with the User's info and rank.  Info is populated from Parse.
-(void)refreshCellWithInfo: (NSString *)userRank username:(NSString *) username  userScore:(NSString *) userScore
{
    rank.text = userRank;
    userName.text = username;
    score.text = userScore;
}

@end
