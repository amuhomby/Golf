//
//  NotifiSettingViewController.h
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotifiSettingViewController : ProgressViewController
{
    IBOutlet UIView * viewBack;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwNoti;
    IBOutlet UIView * vwPrivacy;
    IBOutlet UILabel * lbnoti;
    IBOutlet UILabel * lbprivacy;
    IBOutlet UILabel * lbstyletab;
}
@property (nonatomic, retain) NSString * type;
@end
