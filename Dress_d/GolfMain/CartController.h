//
//  CartController.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartController : ProgressViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnEdit;
    
    IBOutlet UITableView * tbView;
    IBOutlet UILabel * lbAmount;
    IBOutlet UILabel * lbPrice;
    IBOutlet UIButton * btnNext;
}

@end
