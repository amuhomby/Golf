//
//  NonFProfViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/16/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface NonFProfViewController : ProgressViewController
{
    NSString * profile_name;
    NSString * profile_ig;
    NSMutableArray * arrStyle;
    NSMutableArray * arrAPost;
    NSMutableArray * arrSPost;
    NSString * send_invite;
    
    
    IBOutlet UIView * viewTop;
    IBOutlet UIButton * btnBack;
    
    IBOutlet UIScrollView * scrV;
    
    IBOutlet UIView * vwProfile;
    IBOutlet UIImageView * igProfile;
    IBOutlet UILabel * lbName;
    IBOutlet UIView  * vwStyle;
    IBOutlet UIButton * btnInvite;
    
    IBOutlet UIView * vwA;
    IBOutlet UIView * vwAImage;
    
    IBOutlet UIView * vwS;
    IBOutlet UIView * vwSImage;
    
    
}
@property (nonatomic, retain) NSString * nonfriend_id;
@end
