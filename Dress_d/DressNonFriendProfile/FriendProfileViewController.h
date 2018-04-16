//
//  FriendProfileViewController.h
//  Dress_d
//
//  Created by MacAdmin on 10/26/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BOZPongRefreshControl.h"

@interface FriendProfileViewController : ProgressViewController
{
    NSString * profile_name;
    NSString * profile_ig;
    NSString * send_invite;
    NSString * blockState;
    NSString * szFriend;
    NSString * szMuteFriend;
    NSString * strBio;
    NSMutableArray * arrStyle;
    NSMutableArray * arrAPost;
    NSMutableArray * arrSPost;
    
    
    IBOutlet UILabel * lbTitle;
    IBOutlet UIView * vwBack;
    IBOutlet UIView * viewTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnBackArrow;
    IBOutlet UIButton * btnSrh;
    
    IBOutlet UIScrollView * scrV;
    
    IBOutlet UIButton * btnDel;
    IBOutlet UIButton * btnBlock;
    IBOutlet UIView * viewFriend;
    
    
    IBOutlet UIView * viewFriendProperty;
    IBOutlet UIButton * btnMute;
    IBOutlet UILabel * lbMute;
    IBOutlet UIButton * btnFri;
    IBOutlet UILabel * lbFriendNum;
    IBOutlet UIButton * btnBio;
    
    IBOutlet UIView * viewNonProperty;
    IBOutlet UIButton * btnNonFri;
    IBOutlet UILabel * lbNonFri;
    IBOutlet UIButton * btnNonMute;
    IBOutlet UILabel * lbNonMute;
    
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
    
    IBOutlet UIView * viewNonFriend;
}
@property (strong, nonatomic) BOZPongRefreshControl* pongRefreshControl;
@property (nonatomic, retain) NSString * friendid;
+(FriendProfileViewController *)sharedInstance;
-(void)getData;
-(void)ToTop:(BOOL)flag;

@end
