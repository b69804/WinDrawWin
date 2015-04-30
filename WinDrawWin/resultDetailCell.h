//
//  resultDetailCell.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/30/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface resultDetailCell : UITableViewCell
{
    IBOutlet UILabel *teamPicked;
    IBOutlet UILabel *matchUp;
    IBOutlet UIImageView *correctOrNot;
}

-(void)refreshCellWithInfo: (NSString *)pick match:(NSString *) match yesOrNo:(UIImage *) yesOrNo;

@end
