//
//  PerviewController.h
//  Dress_d
//
//  Created by MacAdmin on 1/5/18.
//  Copyright © 2018 MacAdmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerviewController : ProgressViewController
{
    NSMutableDictionary * _dicPostDetail;
    NSMutableArray * _arrShop;
    
    IBOutlet UIView * viewTop;
    
    IBOutlet UIScrollView * scrView;
    
    IBOutlet UIView * viewImage;
    IBOutlet UIImageView * imgPhoto;

    IBOutlet UIView * vwCancel;
    IBOutlet UIButton * btnCancel;
    IBOutlet UIButton * btnCaption;
    
    IBOutlet UIView * vwButton;
    IBOutlet UIButton * btnMan;
    IBOutlet UIButton * btnWomen;
    IBOutlet UIView * vwProduct;
    
    IBOutlet UIView * vwOutfit;
    IBOutlet UIButton * btnOutfit;
    
    IBOutlet UIButton * btn1;
    IBOutlet UIButton * btn2;
    IBOutlet UIButton * btn3;
}

@property (nonatomic, retain) UIImage * imgData;

@end
