//
//  ExpireHourViewController.h
//  Dress_d
//
//  Created by MacAdmin on 9/20/17.
//  Copyright © 2017 dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface ExpireHourViewController : ProgressViewController
{
    IBOutlet UIView * viewBack;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIView * viewParent;
    IBOutlet UIView * viewMain;
    IBOutlet UILabel * lbHours;
    IBOutlet UIButton * btnHours;
    IBOutlet UIButton * btnNoExpire;
    IBOutlet UIButton * btnCon;
    IBOutlet UIButton * btnCancel;
    IBOutlet UIView * viewPick;
    IBOutlet UIButton * btnDone;
    IBOutlet UIPickerView * picker;
}

@property (nonatomic, retain) NSData * imgData1;
@property (nonatomic, retain) NSData * imgData2;
@property (nonatomic, retain) NSData * imgData3;
@property (nonatomic, retain) NSData * imgData4;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * strBrand;
@property (nonatomic, retain) NSString * style_ids;

@end
