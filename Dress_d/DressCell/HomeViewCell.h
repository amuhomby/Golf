//
//  HomeViewCell.h
//  Dress_d
//
//  Created by MacAdmin on 9/12/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView * imgPhoto;
@property (nonatomic,retain) IBOutlet UIButton * btnName;
@property (nonatomic,retain) IBOutlet UIImageView * igClock;
@property (nonatomic , retain) IBOutlet UILabel * lbExpHour;
@property (nonatomic, retain) IBOutlet UIView * viewImage;
@property (nonatomic, retain) IBOutlet UIScrollView * scrImage;
@property (nonatomic, retain) IBOutlet UIImageView * moreIcon;

@property (nonatomic,retain) IBOutlet UIView * viewlike;
@property (nonatomic,retain) IBOutlet UIView * viewlikeOne;
@property (nonatomic, retain) IBOutlet UIView * viewlikeTwo;


@property (nonatomic, retain) IBOutlet UIButton * btn1;
@property (nonatomic, retain) IBOutlet UIButton * btn2;
@property (nonatomic, retain) IBOutlet UIButton * btn3;
@property (nonatomic, retain) IBOutlet UILabel * lblike1;
@property (nonatomic, retain) IBOutlet UILabel * lblike2;
@property (nonatomic, retain) IBOutlet UILabel * lblike3;

@property (nonatomic,retain) IBOutlet UIButton * btn4;
@property (nonatomic, retain) IBOutlet UILabel * lblike4;
@property (nonatomic, retain) IBOutlet UIButton * btnStar;
@property (nonatomic, retain) IBOutlet UIButton * btnReport;

@property (nonatomic, retain) IBOutlet UIView * viewCaption;
@property (nonatomic, retain) IBOutlet UILabel * lbCaption;
@property (nonatomic, retain) IBOutlet UILabel * lbLine;;
@property (nonatomic, retain) IBOutlet UIView * viewBrand;
@property (nonatomic, retain) IBOutlet UIScrollView * scrShopStyle;
@property (nonatomic, retain) IBOutlet UIView * viewShop;
@property (nonatomic, retain) IBOutlet UILabel * lbUshop;
@property (nonatomic, retain) IBOutlet UILabel * lbLshop;

@end
