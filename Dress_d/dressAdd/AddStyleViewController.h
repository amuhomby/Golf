//
//  AddStyleViewController.h
//  Dress_d
//
//  Created by MacAdmin on 12/7/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddStyleViewController : ProgressViewController
{
    IBOutlet UIView * vwButton;
    IBOutlet UIButton * btnConti;
    IBOutlet UIButton * btnCancel;
    
    NSMutableArray * arrStyle;
    NSMutableArray * arruserStyle;
    
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * viewStyle;
}


@property (nonatomic, retain) NSData * imgData1;
@property (nonatomic, retain) NSData * imgData2;
@property (nonatomic, retain) NSData * imgData3;
@property (nonatomic, retain) NSData * imgData4;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * strBrand;

@end
