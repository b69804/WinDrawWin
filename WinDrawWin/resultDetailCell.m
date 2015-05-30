//
//  resultDetailCell.m
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import "resultDetailCell.h"

@implementation resultDetailCell



- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)refreshCellWithInfo: (NSString *)pick match:(NSString *) match yesOrNo:(UIImage *) yesOrNo
{
    teamPicked.text = pick;
    matchUp.text = match;
    correctOrNot.image = yesOrNo;
}

-(IBAction)done:(UIStoryboardSegue *)segue
{
    
}

@end
