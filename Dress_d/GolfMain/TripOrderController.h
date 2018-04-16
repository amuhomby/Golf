//
//  TripOrderController.h
//  Golf
//
//  Created by MacAdmin on 4/1/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSCalendar/FSCalendar.h>

@interface TripOrderController : UIViewController
{
    IBOutlet UIScrollView * scrollView;
    IBOutlet UITextView * tvDes;
    IBOutlet UIView * vwStartTime;
    IBOutlet UIView * vwEndTime;
    
    IBOutlet UILabel * lbData;
    IBOutlet UIButton * btnDate;
    IBOutlet UIView * vwCalendar;
    IBOutlet UIButton * btnCalendar;
    IBOutlet FSCalendar * mCalendar;
}
@end
