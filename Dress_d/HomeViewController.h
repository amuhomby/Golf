//
//  HomeViewController.h
//  Vala
//
//  Created by MacAdmin on 5/31/16.
//  Copyright © 2016 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface HomeViewController : ProgressViewController
{
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwBack;
    IBOutlet UIView * viewEmail;
    IBOutlet UITextField *tfEmail;
    IBOutlet UIView * viewPwd;
    IBOutlet UITextField *tfPwd;
    IBOutlet UIButton *btnSignUp;
    IBOutlet UIButton *btnReset;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnFBLogin;

}

@end
