//
//  DressProfileViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/13/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
#import "BOZPongRefreshControl.h"

@interface DressProfileViewController : ProgressViewController
{
    NSString * profile_id;
    NSString * profile_name;
    NSString * profile_ig;
    NSString * send_invite;
    NSString * szFriend;
    NSString * szMuteFriend;
    NSString * strBio;
    NSMutableArray * arrStyle;
    NSMutableArray * arrAPost;
    NSMutableArray * arrSPost;
    
    
    
    IBOutlet UIView * viewTop;
    IBOutlet UILabel * lbTitle;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnBackArrow;
    IBOutlet UIButton * btnSrh;
    
    IBOutlet UIView * vwBack;
    IBOutlet UIScrollView * scrV;
    
    IBOutlet UIButton * btnDel;
    IBOutlet UIView * viewFriend;
    IBOutlet UIView * viewFriendProperty;
    IBOutlet UIButton * btnMute;
    IBOutlet UILabel * lbMute;
    IBOutlet UIButton * btnFri;
    IBOutlet UILabel * lbFriendNum;
    IBOutlet UIButton * btnBio;
    IBOutlet UIButton * btnSetting;
    
    IBOutlet UIView * viewMyProperty;
    IBOutlet UIButton * btnMyFri;
    IBOutlet UILabel * lbMyFri;
    IBOutlet UIButton * btnMyBio;
    
    IBOutlet UIView * vwProfile;
    IBOutlet UIImageView * igProfile;
    IBOutlet UILabel * lbName;
    IBOutlet UIView  * vwStyle;
    
    IBOutlet UIView * vwA;
    IBOutlet UIButton * btnSaveOutfit;
    IBOutlet UIButton * btnActvOutfit;
    IBOutlet UIView * vwAImage;
    
    IBOutlet UIView * vwS;
    IBOutlet UIView * vwSImage;
    
    IBOutlet UIButton * btnProfile;
    IBOutlet UIView * viewRealParent;
    IBOutlet UIView * viewBio;
    IBOutlet UIView * viewParent;
    IBOutlet UIView * viewContent;
    IBOutlet UILabel * lbBio;
    
}
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;

+(DressProfileViewController *)sharedInstance;
-(void)getData;
-(void)ToTop:(BOOL)flag;
@end
