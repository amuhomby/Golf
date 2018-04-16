//
//  DressSettingViewController.h
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKShareKit/FBSDKAppInviteContent.h>
@interface DressSettingViewController : UIViewController<FBSDKAppInviteDialogDelegate>{
    IBOutlet UIView * viewCover;
    IBOutlet UIScrollView * scrollview;
}
@end
