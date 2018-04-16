//
//  PhotoViewController.h
//  Dress_d
//
//  Created by MacAdmin on 11/27/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : ProgressViewController
{
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwBack;
    IBOutlet UIImageView * igProfile;

    IBOutlet UIButton * btnTakePhoto;
    IBOutlet UIButton * btnContinue;
    IBOutlet UIView * vwCover;
}

@property (nonatomic, retain) NSString * strFname;
@property (nonatomic, retain) NSString * strLname;
@property (nonatomic, retain) NSString * strEmail;
@property (nonatomic, retain) NSString * strPwd;
@end
