//
//  RechargeController.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargeController : ProgressViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIView * vwBack;
    IBOutlet UILabel * lbAmount;
    IBOutlet UITextField * editAmount;
    IBOutlet UIButton * btnCharge;
    IBOutlet UILabel * lbCaution;
}
@end
