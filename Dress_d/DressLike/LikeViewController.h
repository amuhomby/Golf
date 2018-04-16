//
//  LikeViewController.h
//  Dress_d
//
//  Created by MacAdmin on 10/6/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
#import "BOZPongRefreshControl.h"

@interface LikeViewController : ProgressViewController
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UITableView * tbLike;
    IBOutlet UILabel * lbNotice;
    NSMutableArray * arrLike;
}
@property(nonatomic, retain) NSString * post_id;
@property(nonatomic, retain) NSString * like_num;
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;
@end
