//
//  FTermsViewController.h
//  Dress_d
//
//  Created by MacAdmin on 11/17/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
#import "dressWelcomeController.h"

@interface FTermsViewController : ProgressViewController
{
    IBOutlet UIWebView * webView;
    IBOutlet UIButton * btnAccept;
    IBOutlet UIButton * btnReject;
    IBOutlet UIView * viewBtn;
}

@end
