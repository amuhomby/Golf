//
//  PrivacyViewController.h
//  Dress_d
//
//  Created by MacAdmin on 10/11/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrivacyViewController : ProgressViewController<UIWebViewDelegate>
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIWebView * webview;
}
@property (nonatomic , retain) NSString * webAddress;
@end
