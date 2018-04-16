//
//  dressStyleController.h
//  Strangrs
//
//  Created by MacAdmin on 9/6/17.
//  Copyright © 2017 AppDupe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"
@interface dressStyleController : ProgressViewController
{
    IBOutlet UITableView * tbStyle;
    IBOutlet UIButton * btnConti;
    
    NSMutableArray * arrStyle;
    NSMutableArray * arruserStyle;
    
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * viewStyle;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnNext;
}
@end
