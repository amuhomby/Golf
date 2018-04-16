//
//  FriendListViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/29/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
#import "BOZPongRefreshControl.h"
@interface FriendListViewController : ProgressViewController
{
    IBOutlet UIView * viewTop;
    IBOutlet UILabel * lbTitle;
    IBOutlet UIView * vwBack;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UITableView *tbList;
    IBOutlet UILabel * lbNotice;
    NSMutableArray * arrFriends;
    NSMutableArray * arrMuteFriends;
}

@property (nonatomic ,retain) NSString * user_id;
@property (nonatomic ,retain) NSString * name;
@property (nonatomic, retain) NSString * showChk;
@property (nonatomic, retain) NSString * fromSetting;

@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;
@end
