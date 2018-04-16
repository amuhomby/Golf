//
//  DetailController.h
//  Golf
//
//  Created by MacAdmin on 3/31/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailController : ProgressViewController
{
    IBOutlet UIView * vwTop;
    IBOutlet UIButton * btnBack;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * vwThumb;
    IBOutlet UIButton * btnThumb;
    IBOutlet UILabel * lbTitle;
    IBOutlet UILabel * lbTitleR;
    IBOutlet UILabel * lbDes;
    IBOutlet UILabel * lbDesR;
    IBOutlet UILabel * lbCont;
    IBOutlet UILabel * lbContR;
    
}@end
