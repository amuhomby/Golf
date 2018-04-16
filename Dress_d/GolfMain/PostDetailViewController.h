//
//  PostDetailViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/12/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface PostDetailViewController : ProgressViewController
{
    
    NSMutableDictionary * _dicPostDetail;
    NSMutableArray * _arrComment;
    NSString * _myCommentFlag;
    NSString * _mySaveFlag;
    
    NSString * subject;
    
    IBOutlet UIView * viewTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    
    IBOutlet UIScrollView * scrView;
    
    IBOutlet UIView * viewMain;
    IBOutlet UIImageView * imgProfile;
    IBOutlet UIButton * btnName;
    IBOutlet UILabel * lbexphour;
    IBOutlet UIImageView * igClock;
    IBOutlet UIView * viewImage;
    IBOutlet UIScrollView * scrImage;
    IBOutlet UIImageView * moreIcon;
    
    IBOutlet UIView * viewlike;
    IBOutlet UIView * viewlikeOne;
    IBOutlet UIView * viewlikeTwo;
    IBOutlet UIButton * btn5;
    IBOutlet UILabel* lblike5;
    IBOutlet UIButton * btn1;
    IBOutlet UIButton * btn2;
    IBOutlet UIButton * btn3;
    IBOutlet UILabel * lblike1;
    IBOutlet UILabel * lblike2;
    IBOutlet UILabel * lblike3;
    IBOutlet UIButton * btnSetting;
    IBOutlet UIButton * btnSave;
    IBOutlet UIButton * btnStar;
    
    IBOutlet UILabel * lbSubj;
    IBOutlet UILabel * lbLine;
    IBOutlet UIView * viewBrand;

    IBOutlet UIView * viewCmt;
//    IBOutlet UIButton * btnComment;
    IBOutlet UIButton * btnSendComm;
    IBOutlet UIImageView * igTick;
    IBOutlet UITextField * tvComment;
    IBOutlet UIView * viewCnt;
    
    IBOutlet UIView * viewSample;
    IBOutlet UILabel * lbNameSample;
    IBOutlet UILabel * lbComSample;
}

@property (nonatomic, retain) NSString * post_id;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSString * fromView;
@end
