//
//  ReportViewController.h
//  Dress_d
//
//  Created by MacAdmin on 11/17/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : ProgressViewController
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIView * viewBack;
    IBOutlet UILabel * lbReport;
    IBOutlet UIButton * btnReport;
    IBOutlet UILabel * lbThanks;
}
@property (nonatomic, retain) NSString * post_id;
@end
