//
//  ShoesBuyController.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoesBuyController : ProgressViewController
{
    IBOutlet UIImageView * imgPhoto;
    IBOutlet UILabel * lbName;
    IBOutlet UILabel * lbPrice;
    IBOutlet UIButton * btnM;
    IBOutlet UIButton * btnL;
    IBOutlet UIButton * btnXL;
    IBOutlet UIButton * btnXXL;
    IBOutlet UIButton * btnMinus;
    IBOutlet UIButton * btnPlus;
    IBOutlet UIButton * btnSz;
    
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnBuy;
    IBOutlet UIButton * btnAdd;
}
@end
