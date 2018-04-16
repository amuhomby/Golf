//
//  ResetViewController.h
//  Dress_d
//
//  Created by MacAdmin on 11/27/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResetViewController : ProgressViewController
{
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwBack;
    IBOutlet UIView * vwEmail;
    IBOutlet UITextField * tfEmail;
    IBOutlet UITextField * tfCode;

    IBOutlet UIView * vwNewPwd;
    IBOutlet UITextField * tfNewPwd;

    IBOutlet UIView * vwRePwd;
    IBOutlet UITextField * tfRePwd;

    IBOutlet UIButton * btnReset;
    IBOutlet UIButton * btnCode;
    
    IBOutlet UILabel * lbCaution;
}
@end
