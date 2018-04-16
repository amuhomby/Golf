//
//  AddViewController.h
//  Dress_d
//
//  Created by MacAdmin on 16/09/2017.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
@interface AddViewController : ProgressViewController
{
    IBOutlet UIView * vwButton;
    IBOutlet UIButton * btnContinue;
    IBOutlet UIButton * btnCancel;
    
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIImageView * igFirst;
    IBOutlet UIView * viewMain;
    IBOutlet UIButton * btnAdd;
    IBOutlet UIView * viewCap;
    IBOutlet UITextField * tfCap;
    
    IBOutlet UIView * viewBrand;
    IBOutlet UITextField * tfBrand;
    
    IBOutlet UIView * viewBrandShow;
    IBOutlet UILabel * lbStyle;
    IBOutlet UILabel * lbLine;
    
    IBOutlet UIView * viewStyle;


    IBOutlet UIImageView * igSecond;
    IBOutlet UIImageView * igThird;
    IBOutlet UIImageView * igFourth;
    
    
    NSMutableArray * _arrStyle;
    NSMutableArray * arrSelStyle;
    
}
@property (nonatomic,readwrite) int szCount;

+(AddViewController *) sharedInstance;
@end
