//
//  ShoesDetailController.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoesDetailController : ProgressViewController
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnEdit;
    IBOutlet UIImageView * imgPhoto;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwInfo;
    IBOutlet UILabel * lbGoodName;
    IBOutlet UILabel * lbGoodDes;
    IBOutlet UILabel * lbPrice;
    IBOutlet UIView * vwSelect;
    IBOutlet UIView * vwQuick;
    IBOutlet UIButton * btnSelect;
    IBOutlet UIButton * btnQuick;
    
    IBOutlet UIView * vwBtn;
    IBOutlet UIButton * btnCollect;
    IBOutlet UIButton * btnCar;
    IBOutlet UIButton * btnBuy;
    IBOutlet UIButton * btnAdd;
}
@end
