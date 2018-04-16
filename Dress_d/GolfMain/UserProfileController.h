//
//  UserProfileController.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileController : ProgressViewController
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIView * vwLiveStream;
    IBOutlet UIButton * btnLiveStream;
    IBOutlet UIImageView * imgPhoto;
    IBOutlet UILabel * lbName;
    IBOutlet UIImageView * imgMark1;
    IBOutlet UIImageView * imgMark2;
    IBOutlet UIImageView * imgMark3;
    IBOutlet UIImageView * imgMark4;
    IBOutlet UIImageView * imgMark5;
    IBOutlet UIImageView * imgMark6;
    IBOutlet UILabel * lbFrom;
    IBOutlet UILabel * lbIntroduce;
    IBOutlet UIButton * btn1;
    IBOutlet UIButton * btn2;
    IBOutlet UIButton * btn3;
    
    IBOutlet UIView * vwMsg;
    IBOutlet UIView * vwFocus;
    IBOutlet UIButton * btnMsg;
    IBOutlet UIButton * btnFocus;
    
    IBOutlet UIButton * btnPhoto;
    IBOutlet UILabel * lbPhoto;
    IBOutlet UILabel * lbPhotoNum;
    IBOutlet UILabel * lbLinePhoto;
    IBOutlet UIButton * btnVideo;
    IBOutlet  UILabel * lbVideo;
    IBOutlet  UILabel * lbVideoNum;
    IBOutlet UILabel * lbLineVideo;
    IBOutlet UIButton * btnFans;
    IBOutlet UILabel * lbFan;
    IBOutlet UILabel * lbFanNum;
    IBOutlet UILabel * lbLineFan;
    
    IBOutlet UIScrollView * scrollview;
    IBOutlet UICollectionView * collView1;
    IBOutlet UICollectionView * collView2;
    IBOutlet UITableView * _tbView;
    
    
}
@end
