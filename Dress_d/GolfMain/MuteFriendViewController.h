//
//  MuteFriendViewController.h
//  Dress_d
//
//  Created by MacAdmin on 10/9/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOZPongRefreshControl.h"

@interface MuteFriendViewController : ProgressViewController
{
    IBOutlet UIView * viewTop;
    IBOutlet UILabel * lbTitle;
    IBOutlet UIView * vwBack;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UITableView *tbList;
    IBOutlet UILabel * lbNotice;
    NSMutableArray * arrFriends;
}

@property (nonatomic, retain) NSString * friend_id;
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;
@end
