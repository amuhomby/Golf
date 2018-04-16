//
//  AddFBFriendViewController.h
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
#import "BOZPongRefreshControl.h"

@interface AddFBFriendViewController : ProgressViewController
{
    IBOutlet UITableView * tbfriend;
    
  
    NSMutableArray *arrAppFriend;
    NSMutableArray *arrFbFriend;
    NSMutableArray *arrFbShow;
    NSMutableArray * arrInviteFriend;
    
    IBOutlet UILabel * lbNo;
    IBOutlet UIView * viewNo;
    
}
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;


@end
