//
//  StarRankController.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarRankController : ProgressViewController
{
    IBOutlet UIView * vwBack;
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    
    IBOutlet UIButton * btnStar;
    IBOutlet UIButton * btnRich;
    IBOutlet UIButton * btnPraise;
    IBOutlet UIButton * btnCookie;
    
    IBOutlet UILabel * lblineStar;
    IBOutlet UILabel * lblineRich;
    IBOutlet UILabel * lblinePraise;
    IBOutlet UILabel * lblineCookie;
    
    IBOutlet UIButton * btnView;
    IBOutlet UIImageView * imgBlur;
    IBOutlet UIImageView * imgPhoto;
    IBOutlet UILabel * lbNo;
    IBOutlet UILabel * lbName;
    IBOutlet UILabel * lbNum;
    
    IBOutlet UILabel * lbTotal;
    IBOutlet UILabel * lbFan;
    IBOutlet UILabel * lbExp;
    
    IBOutlet UITableView * _tbView;
}
@end
