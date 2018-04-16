//
//  NotificationViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/16/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOZPongRefreshControl.h"

@interface NotificationViewController : ProgressViewController
{
    IBOutlet UIView * viewTop;
    IBOutlet UILabel * lbATitle;
    
    IBOutlet UIView * vwBack;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UILabel * lbTitle;
    IBOutlet UITableView * tbNoti;
    NSMutableArray * arrNot;
    IBOutlet UIView * viewNo;
    IBOutlet UILabel * lbNo;
}
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;
+ (NotificationViewController*)sharedNotifi;
- (void)getData;
-(void)ToTop:(BOOL)flag;
@end
