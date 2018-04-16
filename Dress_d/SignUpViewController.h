//
//  SignUpViewController.h
//  Dress_d
//
//  Created by MacAdmin on 11/27/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : ProgressViewController
{
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwBack;
    IBOutlet UIView * vwfname;
    IBOutlet UITextField *tfname;
    IBOutlet UIView * vwlname;
    IBOutlet UITextField *tflname;
    IBOutlet UIView * vwEmail;
    IBOutlet UITextField * tfEmail;
    IBOutlet UIView * vwPwd;
    IBOutlet UITextField * tfPwd;
    IBOutlet UIView * vwRePwd;
    IBOutlet UITextField * tfRePwd;
    IBOutlet UIButton * btnContinue;
    IBOutlet UILabel * lbCaution;
}
@end
