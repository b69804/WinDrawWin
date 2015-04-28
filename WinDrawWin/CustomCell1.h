//
//  CustomCell1.h
//  WinDrawWin
//
//  Created by Matthew Ashton on 4/27/15.
//  Copyright (c) 2015 MA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell1 : UITableViewCell

{
    IBOutlet UILabel *pick;
    IBOutlet UILabel *matchup;
}

-(void)refreshCellWithInfo: (NSString*)pick matchUp:(NSString *) matchUp;

@end
