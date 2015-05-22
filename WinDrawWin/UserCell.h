//
//  UserCell.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
{
    IBOutlet UILabel *eachWeek;
    IBOutlet UILabel *scoreForThatWeek;
}


//-(void)refreshCellWithInfo: (NSString *)thisWeek myScore:(NSString *) myScore;
-(void)refreshCellWithInfo: (NSString *)thisWeek;

@end
