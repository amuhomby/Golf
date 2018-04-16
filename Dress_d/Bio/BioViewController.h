//
//  BioViewController.h
//  Dress_d
//
//  Created by MacAdmin on 10/9/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BioViewController : ProgressViewController
{
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * viewMain;
    IBOutlet UIView * viewContent;
    IBOutlet UITextView * tvbio;
    IBOutlet UIButton * btnSave;
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIView * vwBio;
    IBOutlet UITextField * tfBio;
}

@end
