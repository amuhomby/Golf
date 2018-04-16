//
//  MyProfileSettingViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/14/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface MyProfileSettingViewController : ProgressViewController
{
    IBOutlet UIView * viewBack;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    
    IBOutlet UIButton * btnEdCap;
    IBOutlet UIButton * btnDelPhoto;
    IBOutlet UIButton * btnSave;
    
}
@property (nonatomic, retain) NSString * post_id;
@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSString * subject;
@end
