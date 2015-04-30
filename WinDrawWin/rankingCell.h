//
//  rankingCell.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/29/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface rankingCell : UITableViewCell
{
    IBOutlet UILabel *rank;
    IBOutlet UILabel *userName;
    IBOutlet UILabel *score;
}

-(void)refreshCellWithInfo: (NSString *)rank username:(NSString *) username  userScore:(NSString *) userScore;

@end
