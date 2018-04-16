//
//  TripDetailController.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripDetailController : UIViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIImageView * imgPhoto;
    IBOutlet UIView  * vwMiddle;
    IBOutlet UILabel * lbDate;
    IBOutlet UILabel * lbTripName;
    
    IBOutlet UIView * vwDes;
    IBOutlet UILabel * lbDes;
    
    IBOutlet UIView * vwAmount;
    IBOutlet UILabel * lbShuttleDes;
    IBOutlet UIButton * btnShuttleYes;
    IBOutlet UIButton * btnShuttleNo;
    IBOutlet UILabel * lbMealDes;
    IBOutlet UIButton * btnMealYes;
    IBOutlet UIButton * btnMealNo;
    IBOutlet UIImageView * imgShuttleYes;
    IBOutlet UIImageView * imgShuttleNo;
    IBOutlet UIImageView * imgMealYes;
    IBOutlet UIImageView * imgMealNo;
    
    IBOutlet UILabel * lbTotalPrice;
    IBOutlet UILabel * lbPrice;
    IBOutlet UILabel * lbszPerson;
    IBOutlet UILabel * lbszPersonSelect;
    IBOutlet UIView * vwBottom;
    
    IBOutlet UIButton * btnOnlineConsult;
    IBOutlet UIButton * btnBuy;
}
@end
