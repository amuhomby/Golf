//
//  SelectStyleView.h
//  Dress_d
//
//  Created by MacAdmin on 21/09/2017.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressViewController.h"

@interface SelectStyleView : ProgressViewController
{
    IBOutlet UIView * viewBack;
    IBOutlet UITableView * tbStyle;
    IBOutlet UIButton * btnConti;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * viewStyle;
    
    NSMutableArray * arrStyle;
    NSMutableArray * arruserStyle;
    
}


@end
