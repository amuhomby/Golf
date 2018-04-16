//
//  BrandViewController.h
//  Dress_d
//
//  Created by MacAdmin on 10/30/17.
//  Copyright © 2017 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandViewController : ProgressViewController
{
    IBOutlet UIButton * btnBack;
    IBOutlet UIButton * btnSrh;
    IBOutlet UIButton * btnStyle;
    IBOutlet UIScrollView * scrollview;
    IBOutlet UIView * viewMain;
    
    NSMutableArray * arrPost;
    NSMutableArray * arrSave;
    NSMutableArray * arrAll;
}
@property (nonatomic, retain) NSString * strBrand;

@end
