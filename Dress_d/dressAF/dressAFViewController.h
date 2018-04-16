//
//  dressAFViewController.h
//  Strangrs
//
//  Created by MacAdmin on 9/6/17.
//  Copyright © 2017 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface dressAFViewController : ProgressViewController
{
    IBOutlet UITableView * tbfriend;
    IBOutlet UIButton * btnConti;
    
    
    NSMutableArray *arrAppFriend;
    NSMutableArray *arrFbFriend;
    NSMutableArray *arrFbShow;
    NSMutableArray * arrInviteFriend;

    IBOutlet UILabel * lbNo;

}
@end
